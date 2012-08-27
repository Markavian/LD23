package net.mkv25.ld23.game;
import net.mkv25.ld23.world.data.Model;
import net.mkv25.ld23.world.data.Sounds;
import net.mkv25.ld23.world.display.Button;
import net.mkv25.ld23.world.display.CraftingBar;
import net.mkv25.ld23.world.display.CraftSlot;
import net.mkv25.ld23.world.display.StarRenderer;
import net.mkv25.ld23.world.display.WorldRenderer;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.Lib;
import haxe.Timer;
import nme.media.Sound;
import nme.media.SoundChannel;
import nme.media.SoundTransform;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;

/**
 * The main game screen...
 * @author John Beech
 */

class Game {

	public var artwork:Sprite;
	public var worldSpace:Sprite;
	public var backgroundBitmap:Bitmap;
	public var stars:StarRenderer;
	
	public var seedTime:Int;
	public var lastSeedTime:Int;
	public var gameTime:Int;
	public var gameTimeDiff:Float;
	public var lastUpdateTime:Float;
	
	public var model:Model;
	public var worlds:Array<WorldRenderer>;
	public var craftingBar:CraftingBar;
	public var selectedItem:CraftSlot;
	
	public var restartButton:Button;
	public var instructionsButton:Button;
	public var instructionsBitmap:Bitmap;
	
	private var animating:Bool;
	private var forceRedraw:Bool;
		
	public function new() {
		initialize();
	}
	
	private function initialize():Void {
		Lib.current.stage.align = StageAlign.TOP_LEFT;
			
		createChildren();
		organiseChildren();
		attachEvents();
		
		Sounds.setVolume(0.5);
		Sounds.playBGM(Sounds.bgmMinatureWorldsOST);
		
		// pause initally
		animating = true;
		forceRedraw = false;
		
		// draw stars
		stars.update(0);
	}
	
	public function createChildren():Void {
		artwork = new Sprite();
		worldSpace = new Sprite();
		
		model = new Model();
		worlds = new Array<WorldRenderer>();
		var world:WorldRenderer;
		for (i in 0...3) {
			world = new WorldRenderer("assets/tw_sphere.png", model);
			worlds.push(world);
			worldSpace.addChild(world.artwork);
		}
		
		craftingBar = new CraftingBar(model);
		selectedItem = new CraftSlot();
		selectedItem.background.artwork.visible = false;
		selectedItem.artwork.mouseEnabled = false;
		selectedItem.artwork.mouseChildren = false;
		
		backgroundBitmap = new Bitmap();
		backgroundBitmap.bitmapData = Assets.getBitmapData("assets/tw_background.png");
		backgroundBitmap.x = - (backgroundBitmap.width / 2);
		backgroundBitmap.y = - (backgroundBitmap.height / 2);
		
		stars = new StarRenderer(20, backgroundBitmap.width, backgroundBitmap.height);
		stars.artwork.x = backgroundBitmap.x;
		stars.artwork.y = backgroundBitmap.y;
		
		restartButton = new Button("assets/tw_button_restart.png", 128, 48);
		instructionsButton = new Button("assets/tw_button_instructions.png", 128, 48);
		instructionsBitmap = new Bitmap();
		instructionsBitmap.bitmapData = Assets.getBitmapData("assets/tw_instructions_screen.png");
		instructionsBitmap.visible = false;
		
		restartButton.artwork.x = 180;
		restartButton.artwork.y = 320 - restartButton.artwork.height + 15;
		
		instructionsButton.artwork.x = 640 - 180;
		instructionsButton.artwork.y = 320 - restartButton.artwork.height + 15;
	}
	
	public function organiseChildren():Void {
		
		worldSpace.addChildAt(backgroundBitmap, 0);
		worldSpace.addChildAt(stars.artwork, 1);
		
		artwork.addChild(worldSpace);
		artwork.addChild(craftingBar.artwork);
		artwork.addChild(selectedItem.artwork);
		artwork.addChild(restartButton.artwork);
		artwork.addChild(instructionsButton.artwork);
		artwork.addChild(instructionsBitmap);
		
		resize();
	}
	
	public function attachEvents():Void {
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.stage.addEventListener(Event.ACTIVATE, stage_onActivate);
		Lib.current.stage.addEventListener(Event.DEACTIVATE, stage_onDeactivate);
		Lib.current.stage.addEventListener(Event.RESIZE, stage_onResize);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_onMouseDown);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, stage_onMouseUp);
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, stage_onEnterFrame);
		
		restartButton.addEventListener(MouseEvent.CLICK, restartGame);
		instructionsButton.addEventListener(MouseEvent.CLICK, showInstructions);
		Lib.current.stage.addEventListener(MouseEvent.CLICK, hideInstructions);
		
		model.addEventListener(Event.CHANGE, modelChanged);
	}
	
	public function restartGame(e:Event = null):Void {
		model.resetInventory();
		animateIn();
	}
	
	public function showInstructions(e:Event = null):Void {
		instructionsBitmap.visible = true;
	}
	
	public function hideInstructions(e:Event = null):Void {
		if(instructionsBitmap.visible) {
			instructionsBitmap.visible = false;
		}
	}
		
	public function animateIn():Void {
		animating = true;
		artwork.mouseEnabled = false;
		artwork.mouseChildren = false;
		
		// redraw worlds
		var i:Int = 0;
		for (world in model.worlds) {
			var renderer:WorldRenderer = worlds[i];
			renderer.render(world, seedTime);
			world.randomize();
			i++;
			
			var time:Float = 0.8;
			renderer.animateIn(time);
			Actuate.timer(time).onComplete(animateInComplete);
		}
		
		Sounds.playBGM(Sounds.bgmMinatureWorldsOST, 38000);
		
		craftingBar.update(model);
	}
	
	public function animateInComplete():Void {
		animating = false;
		artwork.mouseEnabled = true;
		artwork.mouseChildren = true;
	}
	
	private function modelChanged(e:Event):Void {
		forceRedraw = true;
		Sounds.playSFX(Sounds.sfxTing);
	}
	
	private function gameloop():Void {
		if (animating) {
			return;
		}
		
		// calculate time difference
		var now:Float = Timer.stamp();
		gameTimeDiff = ((now - lastUpdateTime) * 30);
		gameTime = cast (gameTime + Math.round(gameTimeDiff * 1));
		lastUpdateTime = now;
		
		// calculate seed difference, a factor of game time
		seedTime = cast (gameTime / 10);
		seedTime = seedTime % 324567;
		
		// redraw stars
		if (seedTime != lastSeedTime) {
			stars.update(seedTime);
		}
		
		// redraw worlds
		if(seedTime != lastSeedTime) {
			var i:Int = 0;
			for (world in model.worlds) {
				world.update(seedTime);
				
				var renderer:WorldRenderer = worlds[i];
				renderer.render(world, seedTime);
				i++;
			}
		}
		
		// force redraw when model changes
		if (forceRedraw) {
			craftingBar.update(model);
			forceRedraw = false;
		}
		
		// track selected item to mouse
		if (model.selectedItem == null) {
			if (selectedItem.artwork.visible) {
				selectedItem.clearItem();
				selectedItem.artwork.visible = false;
			}
		}
		else {
			selectedItem.artwork.x = artwork.mouseX;
			selectedItem.artwork.y = artwork.mouseY;
			selectedItem.artwork.visible = true;
			if(selectedItem.inventoryItem == null) {
				selectedItem.itemContainer.setItem(model.selectedItem.type);
				selectedItem.quantityText.text = "1";
			}
		}
		
		// hide restart and close buttons if inventory is open
		restartButton.artwork.visible = !craftingBar.open;
		instructionsButton.artwork.visible = !craftingBar.open;
		
		lastSeedTime = seedTime;
	}
	
	private function resize():Void {
		worldSpace.x = Lib.current.stage.stageWidth / 2;
		worldSpace.y = Lib.current.stage.stageHeight / 2;
		
		craftingBar.artwork.x = worldSpace.x;
		craftingBar.artwork.y =  Lib.current.stage.stageHeight - 35;
	}
	
	// Event Handlers
	private function stage_onActivate(event:Event):Void {
		
		Actuate.resumeAll();
	}
	
	private function stage_onDeactivate(event:Event):Void {
		Actuate.pauseAll();
	}
	
	private function stage_onResize(e:Event):Void {
		resize();
	}
	
	private function stage_onMouseDown(e:MouseEvent):Void {
		
	}
	
	private function stage_onMouseUp(e:MouseEvent):Void {
		
	}
	
	private function stage_onEnterFrame(e:Event):Void {
		gameloop();
	}
}
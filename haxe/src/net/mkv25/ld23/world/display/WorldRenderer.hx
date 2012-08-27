package net.mkv25.ld23.world.display;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Elastic;
import com.eclecticdesignstudio.motion.easing.Quad;
import net.mkv25.ld23.world.data.Model;
import net.mkv25.ld23.world.data.Sounds;
import net.mkv25.ld23.world.type.ItemType;
import net.mkv25.ld23.world.type.WeatherType;
import net.mkv25.ld23.world.data.World;
import net.mkv25.ld23.util.ImageMap;
import nme.Assets;
import nme.display.BitmapData;
import nme.display.Bitmap;
import nme.display.BlendMode;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.text.Font;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

/**
 * Renders a world...
 * @author John Beech
 */

class WorldRenderer {
	private var assetName:String;
	private var model:Model;
	
	public var artwork:Sprite;
	public var bitmapGroup:Sprite;
	public var tiles:Array<BitmapData>;
	
	private var glassBitmap:Bitmap;
	private var highlightBitmap:Bitmap;
	private var terrainBitmap:Bitmap;
	private var skyBitmap:Bitmap;
	
	private var notification:Sprite;
	private var notificationBitmap:Bitmap;
	
	private var weather:WeatherRenderer;
	private var vegetation:VegetationRenderer;
	private var assignedWorld:World;
	
	private var appliedItemText:TextField;
	
	private var harvestItem:ItemContainer;
	
	public static var ZOOM:Float = 0.5;
		
	public function new(assetName:String, model:Model) {
		this.assetName = assetName;
		this.model = model;
		
		createChildren();
		organiseChildren();
		attachEvents();
	}
	
	private function createChildren():Void {
		artwork = new Sprite();
		bitmapGroup = new Sprite();
		tiles = ImageMap.createMap(assetName, 512, 512);
		
		glassBitmap = new Bitmap();
		highlightBitmap = new Bitmap();
		terrainBitmap = new Bitmap();
		skyBitmap = new Bitmap();
		
		glassBitmap.smoothing = true;
		highlightBitmap.smoothing = true;
		terrainBitmap.smoothing = true;
		skyBitmap.smoothing = true;
		
		notification = new Sprite();
		notificationBitmap = new Bitmap();
		notificationBitmap.bitmapData = tiles[13];
		notification.visible = false;
		
		var font:Font = Assets.getFont("assets/trebuchet.ttf");
		var format:TextFormat = new TextFormat(font.fontName, 32, 0xFFFFFF);
		format.align = TextFormatAlign.CENTER;
		
		appliedItemText = new TextField();
		appliedItemText.defaultTextFormat = format;
		appliedItemText.selectable = false;
		appliedItemText.embedFonts = true;
		appliedItemText.width = 512;
		appliedItemText.height = 90;
		appliedItemText.mouseEnabled = false;
		appliedItemText.wordWrap = true;
		appliedItemText.text = "";
		
		weather = new WeatherRenderer();
		vegetation = new VegetationRenderer();
		harvestItem = new ItemContainer();
		
		glassBitmap.blendMode = BlendMode.DARKEN;
		highlightBitmap.blendMode = BlendMode.OVERLAY;
		
		pulseNotification();
	}
	
	private function organiseChildren():Void {
		notification.addChild(notificationBitmap);
		
		notification.x = 256;
		notification.y = 256;
		notificationBitmap.x = -256;
		notificationBitmap.y = -256;
				
		bitmapGroup.addChild(notification);
		bitmapGroup.addChild(skyBitmap);
		bitmapGroup.addChild(terrainBitmap);
		bitmapGroup.addChild(vegetation.artwork);
		bitmapGroup.addChild(weather.artwork);
		bitmapGroup.addChild(glassBitmap);
		bitmapGroup.addChild(highlightBitmap);
		bitmapGroup.addChild(harvestItem.artwork);
		bitmapGroup.addChild(appliedItemText);
				
		bitmapGroup.x = bitmapGroup.y = -256;
		
		weather.artwork.x = 256;
		weather.artwork.y = 256;
		
		appliedItemText.x = 0;
		appliedItemText.y = 440;
		
		vegetation.artwork.x = 256;
		vegetation.artwork.y = 256;
		
		harvestItem.artwork.x = 256;
		harvestItem.artwork.y = 256;
		
		artwork.addChild(bitmapGroup);
	}
	
	private function attachEvents():Void {
		artwork.addEventListener(MouseEvent.MOUSE_OVER, worldHover);
		artwork.addEventListener(MouseEvent.MOUSE_UP, worldHover);
		artwork.addEventListener(MouseEvent.MOUSE_DOWN, worldDown);
		artwork.addEventListener(MouseEvent.MOUSE_OUT, worldDefault);
		
		artwork.addEventListener(MouseEvent.MOUSE_DOWN, worldClicked);
		artwork.mouseChildren = false;
	}
	
	public function animateIn(time:Float):Void {
		var w:World = assignedWorld;
		
		// Move to top middle screen and tween down
		artwork.scaleX = artwork.scaleY = (ZOOM * w.scale) * 0.65;
		artwork.x = 0;
		artwork.y = - 250;
		var scale:Float = ZOOM * w.scale;
		Actuate.tween(artwork, time, { scaleX: scale, scaleY: scale, y: w.position.y, x: w.position.x } ).ease(Quad.easeOut);
	}
	
	private function pulseNotification():Void {
		if (assignedWorld == null || assignedWorld.worldDestroyed) {
			return;
		}
		
		if (notification.visible) {
			notification.scaleX = notification.scaleY = 0.9;
			var scale:Float = 1.0;
			Actuate.tween(notification, 4.0, { scaleX: scale, scaleY: scale } ).ease(Elastic.easeOut).onComplete(pulseNotification);
		}
	}
	
	private function animateAppliedItem(item:ItemType):Void {
		harvestItem.setItem(item);
		harvestItem.artwork.y = 256;
		harvestItem.artwork.scaleX = harvestItem.artwork.scaleY = 1 / ZOOM;
		var scale:Float = harvestItem.artwork.scaleX * 2.0;
		Actuate.tween(harvestItem.artwork, 1.2, { y: 256, scaleX: scale, scaleY: scale} ).ease(Quad.easeInOut).onComplete(hideHarvestIcon);
	}
	
	private function worldDefault(e:Event = null):Void {
		tweenWorld(-1, 1.00, 0.5);
	}
	
	private function worldDown(e:Event=null):Void {
		tweenWorld(-1, 0.90, 0.2);
	}
	
	private function worldHover(e:Event=null):Void {
		tweenWorld(-1, 1.10, 0.2);
	}
		
	private function tweenWorld(from:Float, to:Float, time:Float=0.2):Void {
		var w:World = assignedWorld;
		if (from == -1) {
			// do nothing
		}
		else {
			artwork.scaleX = artwork.scaleY = w.scale * ZOOM * from;
		}

		var scale:Float = w.scale * ZOOM * to;
		Actuate.tween(artwork, time, { scaleX:scale, scaleY:scale } ).ease(Quad.easeOut);
	}
	
	private function worldClicked(e:Event):Void {
		if (assignedWorld.worldDestroyed) {
			return;
		}
		else if (model.selectedItem != null) {
			// apply item to world
			model.applySelectedItemToWorld(assignedWorld);
			
			Sounds.playSFX(Sounds.sfxTing);
			
			appliedItemText.text = assignedWorld.appliedEffect;
			animateAppliedItem(assignedWorld.appliedItem);
		}
		else if (assignedWorld.workRemainingTilHarvest == 0) {
			// harvest
			var item:ItemType = assignedWorld.harvestItem();
			// change model
			model.addInventoryItem(item, 1);
			
			harvestItem.setItem(item);
			harvestItem.artwork.y = 256;
			harvestItem.artwork.scaleX = harvestItem.artwork.scaleY = 1 / ZOOM;
			Actuate.tween(harvestItem.artwork, 1.2, { y: 128 } ).ease(Quad.easeInOut).onComplete(hideHarvestIcon);
			
			appliedItemText.text = assignedWorld.appliedEffect;
		}
	}
	
	private function hideHarvestIcon():Void {
		harvestItem.clearItem();
		appliedItemText.text = "";
	}
	
	public function render(world:World, seed:Int = 0):Void {
		assignedWorld = world;
		
		if (world.worldDestroyed) {
			glassBitmap.bitmapData = tiles[14];
			highlightBitmap.bitmapData = null;
			skyBitmap.bitmapData = null;
			terrainBitmap.bitmapData = tiles[3 + world.biome.tileOffset];
			
			weather.render(world.weather, seed);
			vegetation.render(world);
			
			notification.visible = false;
		}
		else {
			glassBitmap.bitmapData = tiles[0];
			highlightBitmap.bitmapData = tiles[1];
			skyBitmap.bitmapData = tiles[2];
			terrainBitmap.bitmapData = tiles[3 + world.biome.tileOffset];
			
			weather.render(world.weather, seed);
			vegetation.render(world);
			
			if (world.workRemainingTilHarvest == 0) {
				if(notification.visible == false) {
					notification.visible = true;
					pulseNotification();
				}
			}
			else {
				notification.visible = false;
			}
		}
	}
}
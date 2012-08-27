package net.mkv25.ld23.menu;
import net.mkv25.ld23.game.Game;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;

/**
 * Represents the main items, outside of the game...
 * @author John Beech
 */

class Menu {

	public var artwork:Sprite;
	public var titleBitmap:Bitmap;
	public var game:Game;
	
	public function new(game:Game) {
		this.game = game;
		
		createChildren();
		organiseChildren();
		attachEvents();
	}
	
	public function createChildren():Void {
		artwork = new Sprite();
		
		titleBitmap = new Bitmap();
		titleBitmap.bitmapData = Assets.getBitmapData("assets/tw_title_screen.png");
	}
	
	public function organiseChildren():Void {
		artwork.addChild(titleBitmap);
	}
	
	public function attachEvents():Void {
		artwork.addEventListener(MouseEvent.CLICK, menuClicked);
	}
	
	private function menuClicked(e:Event):Void {
		artwork.visible = false;
		
		game.animateIn();
	}
	
}
package net.mkv25.ld23.world.display;
import net.mkv25.ld23.util.ImageMap;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.EventDispatcher;
import nme.events.MouseEvent;

/**
 * Represents a clickable button with hover and down states.
 * @author John Beech
 */

class Button extends EventDispatcher {

	private var assetName:String;
	private var width:Int;
	private var height:Int;
	private var tiles:Array<BitmapData>;
	
	public var artwork:Sprite;
	public var buttonBitmap:Bitmap;
	
	public function new(assetName:String, width:Int, height:Int) {
		super();
		
		this.assetName = assetName;
		this.width = width;
		this.height = height;
		
		createChildren();
		attachEvents();
		
		buttonDefault();
	}
	
	private function createChildren():Void {
		tiles = ImageMap.createMap(assetName, width, height);
		
		artwork = new Sprite();
		buttonBitmap = new Bitmap();
		
		buttonBitmap.x = - (width / 2);
		buttonBitmap.y = - (height / 2);
		
		artwork.addChild(buttonBitmap);
	}
	
	private function attachEvents():Void {
		artwork.addEventListener(MouseEvent.MOUSE_OVER, buttonHover);
		artwork.addEventListener(MouseEvent.MOUSE_UP, buttonHover);
		artwork.addEventListener(MouseEvent.MOUSE_DOWN, buttonDown);
		artwork.addEventListener(MouseEvent.MOUSE_OUT, buttonDefault);
		
		artwork.addEventListener(MouseEvent.CLICK, buttonClick);
	}
	
	private function buttonDefault(e:Event=null):Void {
		buttonBitmap.bitmapData = tiles[0];
	}
	
	private function buttonHover(e:Event):Void {
		if(tiles.length > 1) {
			buttonBitmap.bitmapData = tiles[1];
		}
	}
	
	private function buttonDown(e:Event):Void {
		if(tiles.length > 2) {
			buttonBitmap.bitmapData = tiles[2];
		}
	}
	
	private function buttonClick(e:Event):Void {
		e.stopImmediatePropagation();
		
		dispatchEvent(new Event(MouseEvent.CLICK));
	}
}
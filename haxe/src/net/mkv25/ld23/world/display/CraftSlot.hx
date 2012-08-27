package net.mkv25.ld23.world.display;
import haxe.Timer;
import net.mkv25.ld23.util.ImageMap;
import net.mkv25.ld23.world.data.InventoryItem;
import net.mkv25.ld23.world.type.ItemType;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;
import nme.events.Event;
import nme.events.EventDispatcher;
import nme.events.MouseEvent;
import nme.text.Font;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

/**
 * A crafting slot, that displays an item
 * @author John Beech
 */

class CraftSlot extends EventDispatcher {

	public var artwork:Sprite;
	
	public var inventoryItem:InventoryItem;
	
	public var background:ItemContainer;
	public var itemContainer:ItemContainer;
	public var quantityText:TextField;
	
	private var mouseDown:Bool;
	private var mouseDownStart:Float;
	private var dragMode:Bool;
	
	public function new() {
		super();
		
		createChildren();
		attachEvents();
	}
	
	private function createChildren():Void {
		artwork = new Sprite();
		
		background = new ItemContainer();
		itemContainer = new ItemContainer();
		
		var font:Font = Assets.getFont("assets/trebuchet.ttf");
		var format:TextFormat = new TextFormat(font.fontName, 16, 0x000000);
		format.align = TextFormatAlign.RIGHT;
		
		quantityText = new TextField();
		quantityText.defaultTextFormat = format;
		quantityText.selectable = false;
		quantityText.embedFonts = true;
		quantityText.width = 30;
		quantityText.height = 25;
		quantityText.mouseEnabled = false;
		
		background.artwork.x = 34;
		background.artwork.y = 34;
		
		itemContainer.artwork.x = 34;
		itemContainer.artwork.y = 34;
		
		quantityText.x = 68 - quantityText.width - 5;
		quantityText.y = 68 - quantityText.height;
		
		artwork.addChild(background.artwork);
		artwork.addChild(itemContainer.artwork);
		artwork.addChild(quantityText);
		
		artwork.mouseChildren = false;
		
		quantityText.text = "0";
		mouseDown = false;
		dragMode = false;
		
		itemDefault();
	}
	
	private function attachEvents():Void {
		artwork.addEventListener(MouseEvent.MOUSE_OVER, itemHover);
		artwork.addEventListener(MouseEvent.MOUSE_UP, itemHover);
		artwork.addEventListener(MouseEvent.MOUSE_DOWN, itemDown);
		artwork.addEventListener(MouseEvent.MOUSE_OUT, itemDefault);
		
		artwork.addEventListener(MouseEvent.CLICK, itemSelected);
		artwork.addEventListener(MouseEvent.MOUSE_UP, itemRelease);
	}
	
	private function itemDefault(e:Event=null):Void {
		tweenIcon( -1, 0.90, 0.5);
		
		mouseDown = false;
		dragMode = false;
	}
	
	private function itemDown(e:Event=null):Void {
		tweenIcon( -1, 0.80, 0.2);
		
		mouseDown = true;
		Actuate.timer(0.300).onComplete(mouseDownTimeout);
	}
	
	private function mouseDownTimeout():Void {
		if (mouseDown) {
			dispatchEvent(new Event(Event.SELECT_ALL));
		}
	}
	
	private function itemHover(e:Event=null):Void {
		tweenIcon( -1, 1.00, 0.2);
		
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	private function itemRelease(e:Event):Void {
		mouseDown = false;
		
		dispatchEvent(new Event(Event.CLOSE));
	}
	
	private function itemSelected(e:Event):Void {
		if (inventoryItem == null || inventoryItem.quantity == 0) {
			return;
		}
		
		if(dragMode == false) {
			dispatchEvent(new Event(Event.SELECT));
		}
		else {
			dragMode = false;
		}
	}
	
	public function draw():Void {
		background.setItem(ItemType.Background);
	}
	
	public function clearItem():Void {
		this.inventoryItem = null;
		itemContainer.clearItem();
	}
	
	public function setItem(item:InventoryItem):Void {
		
		if (item.quantity == 0) {
			clearItem();
			quantityText.text = "";
		}
		else if(inventoryItem == null) {
			this.inventoryItem = item;
		}
		
		if (inventoryItem != null && Std.parseInt(quantityText.text) != inventoryItem.quantity) {
			itemContainer.setItem(item.type);
			quantityText.text = cast item.quantity;
			tweenIcon(0.65, 0.90, 0.3);
		}
	}
	
	private function tweenIcon(from:Float, to:Float, time:Float=0.2):Void {
		if (from == -1) {
			from = itemContainer.artwork.scaleX;
		}
		
		itemContainer.artwork.scaleX = itemContainer.artwork.scaleY = from;
		Actuate.tween(itemContainer.artwork, time, { scaleX:to, scaleY:to } ).ease(Quad.easeOut);
	}
	
}
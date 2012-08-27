package net.mkv25.ld23.world.display;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;
import net.mkv25.ld23.world.data.InventoryItem;
import net.mkv25.ld23.world.data.Model;
import net.mkv25.ld23.world.data.Recipe;
import net.mkv25.ld23.world.data.Sounds;
import net.mkv25.ld23.world.type.ItemType;
import nme.Assets;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.Lib;
import nme.text.Font;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

/**
 * A neat bar for displaying craft items, and crafting...
 * @author John Beech
 */

class CraftingBar {

	private var model:Model;
	public var artwork:Sprite;
	
	public var slideContainer:Sprite;
	public var slotsContainer:Sprite;
	public var slots:Array<CraftSlot>;
	
	public var inventoryButton:Button;
	public var closeButton:Button;
	public var hoverText:TextField;
	public var craftText:TextField;
	
	private var animating:Bool;
	public var open:Bool;
	
	private var mouseLock:Bool;
	
	private static var COLUMNS:Int = 8;
	
	public function new(model:Model) {
		this.model = model;
		
		createChildren();
		attachEvents();
		
		open = false;
		mouseLock = false;
	}
	
	private function createChildren():Void {
		artwork = new Sprite();
		
		slideContainer = new Sprite();
		slotsContainer = new Sprite();
		slots = new Array<CraftSlot>();
		
		var slot:CraftSlot;
		for (i in 0...24) {
			slot = new CraftSlot();
			slots.push(slot);
			
			slotsContainer.addChild(slot.artwork);
			
			slot.artwork.x = (i % COLUMNS) * 68;
			slot.artwork.y = Math.floor(i / COLUMNS) * 68;
			
			registerEvents(slot);
			
			slot.draw();
		}
		
		slotsContainer.x = ( - 34 * COLUMNS);
		slotsContainer.y = 0;
		
		inventoryButton = new Button("assets/tw_button_inventory.png", 128, 48);
		closeButton = new Button("assets/tw_button_close.png", 128, 48);
		
		var font:Font = Assets.getFont("assets/trebuchet.ttf");
		var format:TextFormat = new TextFormat(font.fontName, 16, 0xFFFFFF);
		format.align = TextFormatAlign.CENTER;
			
		hoverText = new TextField();
		hoverText.defaultTextFormat = format;
		hoverText.selectable = false;
		hoverText.embedFonts = true;
		hoverText.width = 300;
		hoverText.height = 40;
		hoverText.y = -10;
		hoverText.x = - 350;
		hoverText.mouseEnabled = false;
		hoverText.wordWrap = true;
		hoverText.text = "";
		hoverText.mouseEnabled = false;
		
		craftText = new TextField();
		craftText.defaultTextFormat = format;
		craftText.selectable = false;
		craftText.embedFonts = true;
		craftText.width = 300;
		craftText.height = 40;
		craftText.y = -10;
		craftText.x = 50;
		craftText.mouseEnabled = false;
		craftText.wordWrap = true;
		craftText.text = "";
		craftText.mouseEnabled = false;
		
		slideContainer.addChild(slotsContainer);
		artwork.addChild(inventoryButton.artwork);
		artwork.addChild(closeButton.artwork); 
		artwork.addChild(hoverText);
		artwork.addChild(craftText);
		artwork.addChild(slideContainer);
		
		closeButton.artwork.visible = false;
		slideContainer.y = 25;
	}
	
	private function attachEvents():Void {		
		inventoryButton.addEventListener(MouseEvent.CLICK, openInventory);
		closeButton.addEventListener(MouseEvent.CLICK, closeInventory);
	}
	
	private function registerEvents(slot:CraftSlot):Void {
		slot.addEventListener(Event.SELECT, craftItemSelect);
		slot.addEventListener(Event.SELECT_ALL, craftItemDrag);
		slot.addEventListener(Event.CLOSE, craftItemRelease);
		slot.addEventListener(Event.CHANGE, craftItemHover);
	}
	
	private function craftItemSelect(e:Event):Void {
		var slot:CraftSlot = cast e.target;
		var item:InventoryItem = slot.inventoryItem;
			
		if (mouseLock) {
			return;
		}
		
		if(model.selectedItem == null) {
			model.pickUpItem(item);
			closeInventory(e);
		}
		else {
			model.dropItem();
		}
	}
	
	private function craftItemDrag(e:Event):Void {
		var slot:CraftSlot = cast e.target;
		var item:InventoryItem = slot.inventoryItem;
		
		if (mouseLock) {
			return;
		}
		
		if(model.selectedItem == null) {
			model.pickUpItem(item);
		}
		else if (item == null) {
			model.dropItem();
		}
	}
	
	private function craftItemRelease(e:Event):Void {
		var slot:CraftSlot = cast e.target;
		var item:InventoryItem = slot.inventoryItem;
		
		if (mouseLock) {
			return;
		}
		
		if (item != null && model.hoveredItem == null && model.selectedItem != null && model.selectedItem.type != item.type) {
			model.hoveredItem = item;
			var craftResult:Recipe = model.mergeInventoryItems();
			
			Sounds.playSFX(Sounds.sfxMetalDrop);
			
			if (craftResult != null) {
				craftText.text = "Crafted " + craftResult.result.name + " x" + craftResult.yield + "!";
			}
			else {
				craftText.text = "No craft result. Try another combination...";
			}
			
			mouseLock = true;
			Actuate.timer(0.3).onComplete(unlockMouse);
		}
		else if (item == null) {
			model.dropItem();
		}
	}
	
	private function unlockMouse():Void {
		mouseLock = false;
	}
	
	private function craftItemHover(e:Event):Void {
		var slot:CraftSlot = cast e.target;
		var item:InventoryItem = slot.inventoryItem;
		
		if (mouseLock) {
			return;
		}
		
		if(item != null && open == true) {
			hoverText.text = item.type.name + ", quantity: " + item.quantity;
		}
		else {
			hoverText.text = "";
		}
	}
	
	public function update(model:Model):Void {
		var n:Int = 0;
		var slot:CraftSlot;
		for (item in model.inventory) {
			if(item != null) {
				slot = slots[n];
				slot.setItem(item);
				
				n++;
			}
		}
		
		if (n < slots.length) {
			while (n < slots.length) {
				var slot:CraftSlot = slots[n];
				slot.itemContainer.clearItem();
				slot.quantityText.text = "";
				n++;
			}
		}
	}
	
	private function openInventory(e:Event):Void {
		if (animating) {
			return;
		}
		animating = true;
		Actuate.tween(slideContainer, 0.4, { y: - slideContainer.height - 35 } ).ease(Quad.easeOut).onComplete(animationComplete);
		open = true;
		
		closeButton.artwork.visible = false;
		Sounds.playSFX(Sounds.sfxTink);
	}
	
	private function closeInventory(e:Event):Void {
		if (animating) {
			return;
		}
		animating = true;
		Actuate.tween(slideContainer, 0.4, { y: 25 } ).ease(Quad.easeOut).onComplete(animationComplete);
		open = false;
		
		inventoryButton.artwork.visible = false;
		Sounds.playSFX(Sounds.sfxTink);
		
		craftText.text = "";
		hoverText.text = "";
	}
	
	private function animationComplete():Void {
		animating = false;
		
		closeButton.artwork.visible = open;
		inventoryButton.artwork.visible = !open;
	}
}
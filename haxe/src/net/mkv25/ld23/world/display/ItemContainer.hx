package net.mkv25.ld23.world.display;
import net.mkv25.ld23.util.ImageMap;
import net.mkv25.ld23.world.type.ItemType;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;

/**
 * Represents an item, offset for scaling/animation
 * @author John Beech
 */

class ItemContainer 
{
	public var artwork:Sprite;
	public var itemBitmap:Bitmap;
	
	public var itemTiles:Array<BitmapData>;
	
	public function new() 
	{
		artwork = new Sprite();
		itemBitmap = new Bitmap();
		itemTiles = ImageMap.createMap("assets/tw_crafting_items.png", 68, 68);
		
		itemBitmap.x = -34;
		itemBitmap.y = -34;
		
		itemBitmap.smoothing = true;
		
		artwork.addChild(itemBitmap);
	}
	
	public function setItem(itemType:ItemType):Void {
		if (itemType == null) {
			itemBitmap.bitmapData = null;
		}
		else {
			itemBitmap.bitmapData = itemTiles[itemType.index];
		}
	}
	
	public function clearItem():Void {
		itemBitmap.bitmapData = null;
	}
	
}
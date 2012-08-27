package net.mkv25.ld23.world.data;
import net.mkv25.ld23.world.type.ItemType;

/**
 * Craft recipe for merging two items
 * @author John Beech
 */

class Recipe {

	public var item1:ItemType;
	public var item2:ItemType;
	
	public var result:ItemType;
	public var yield:Int;
	
	public function new(item1:ItemType, item2:ItemType, result:ItemType, yield:Int) {
		this.item1 = item1;
		this.item2 = item2;
		this.result = result;
		this.yield = yield;
	}
	
	public function isCompatable(itemA:ItemType, itemB:ItemType):Bool {
		if (itemA == item1) {
			if (itemB == item2) {
				return true;
			}
		}
		else if (itemB == item1) {
			if (itemA == item2) {
				return true;
			}
		}
		return false;
	}
	
}
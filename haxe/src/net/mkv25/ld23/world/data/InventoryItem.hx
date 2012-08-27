package net.mkv25.ld23.world.data;
import net.mkv25.ld23.world.type.ItemType;

/**
 * Represents an item in the player's inventory.
 * @author John Beech
 */

class InventoryItem 
{
	public var quantity:Int;
	public var type:ItemType;
	
	public function new(type:ItemType, quantity:Int=0) {
		this.type = type;
		this.quantity = quantity;
	}
	
}
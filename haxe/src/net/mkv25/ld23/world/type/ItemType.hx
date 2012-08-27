package net.mkv25.ld23.world.type;

class ItemType {
	
	public static var Background:ItemType;
	public static var PlusOne:ItemType;
	public static var Fire:ItemType;
	public static var Ice:ItemType;
	public static var Water:ItemType;
	public static var Stone:ItemType;
	public static var Wood:ItemType;
	public static var Copper:ItemType;
	public static var Iron:ItemType;
	public static var Sand:ItemType;
	public static var Steam:ItemType;
	public static var Lava:ItemType;
	public static var Glass:ItemType;
	public static var Food:ItemType;
	public static var Humans:ItemType;
	public static var Meteorite:ItemType;
	public static var CopperHammer:ItemType;
	public static var IronHammer:ItemType;
	public static var FrozenMeteorite:ItemType;
	
	public var index:Int;
	public var name:String;
	
	public function new(index:Int, name:String) {
		this.index = index;
		this.name = name;
	}
}
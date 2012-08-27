package net.mkv25.ld23.world.data;

import net.mkv25.ld23.world.type.ItemType;
import net.mkv25.ld23.world.type.TemperatureType;
import net.mkv25.ld23.world.type.MoistureType;
import net.mkv25.ld23.world.type.WeatherType;
import nme.events.Event;
import nme.events.EventDispatcher;

/**
 * Model for all game data...
 * @author John Beech
 */

class Model extends EventDispatcher {
	public var biomes:List<Biome>;
	public var worlds:List<World>;
	public var inventory:Array<InventoryItem>;
	public var recipes:Array<Recipe>;
	public var selectedItem:InventoryItem;
	public var hoveredItem:InventoryItem;
	
	public function new() {
		super();
		
		// define biomes
		biomes = new List<Biome>();
		
		Biome.Snow = new Biome(0, TemperatureType.Cold, MoistureType.Wet, [WeatherType.HeavySnow, WeatherType.Snow, WeatherType.HeavySnow, WeatherType.None, WeatherType.Cumulus, WeatherType.Snow]);
		Biome.Wetland = new Biome(1, TemperatureType.Mild, MoistureType.Wet, [WeatherType.Rain, WeatherType.None, WeatherType.Thunder, WeatherType.Downpour, WeatherType.Rain]);
		Biome.Jungle = new Biome(2, TemperatureType.Hot, MoistureType.Wet, [WeatherType.Rain, WeatherType.None, WeatherType.Thunder, WeatherType.Downpour, WeatherType.Rain, WeatherType.Thunder, WeatherType.Downpour, WeatherType.None]);
		Biome.Permafrost = new Biome(3, TemperatureType.Cold, MoistureType.Mild, [WeatherType.Rain, WeatherType.Snow, WeatherType.None, WeatherType.Cumulus, WeatherType.Snow]);
		Biome.Grass = new Biome(4, TemperatureType.Mild, MoistureType.Mild, [WeatherType.Rain, WeatherType.None, WeatherType.Cumulus, WeatherType.Thunder, WeatherType.Rain, WeatherType.Cumulus, WeatherType.Rain, WeatherType.None]);
		Biome.Scrub = new Biome(5, TemperatureType.Hot, MoistureType.Mild, [WeatherType.Rain, WeatherType.None, WeatherType.Cumulus, WeatherType.Cirrus, WeatherType.None, WeatherType.Cumulus, WeatherType.None, WeatherType.Cumulus]);
		Biome.Rock = new Biome(6, TemperatureType.Cold, MoistureType.Dry, [WeatherType.Cirrus, WeatherType.None, WeatherType.Cumulus, WeatherType.Cirrus, WeatherType.None]);
		Biome.Desert = new Biome(7, TemperatureType.Mild, MoistureType.Dry, [WeatherType.Cirrus, WeatherType.None, WeatherType.Cumulus, WeatherType.Cirrus, WeatherType.None]);
		Biome.Volcano = new Biome(8, TemperatureType.Hot, MoistureType.Dry, [WeatherType.Ash, WeatherType.Volcanic, WeatherType.Cirrus, WeatherType.Ash, WeatherType.Volcanic]);
		Biome.DestroyedGlass = new Biome(9, TemperatureType.Cold, MoistureType.Dry, [WeatherType.None]);
		
		// define items
		ItemType.Background = new ItemType(0, "Background");
		ItemType.PlusOne = new ItemType(1, "Plus One symbol");
		ItemType.Fire = new ItemType(2, "Fire");
		ItemType.Ice = new ItemType(3, "Ice");
		ItemType.Water = new ItemType(4, "Water");
		ItemType.Stone = new ItemType(5, "Stone");
		ItemType.Wood = new ItemType(6, "Wood");
		ItemType.Copper = new ItemType(7, "Copper");
		ItemType.Iron = new ItemType(8, "Iron");
		ItemType.Sand = new ItemType(9, "Sand");
		ItemType.Steam = new ItemType(10, "Steam");
		ItemType.Lava = new ItemType(11, "Lava");
		ItemType.Glass = new ItemType(12, "Glass");
		ItemType.Food = new ItemType(13, "Food");
		ItemType.Humans = new ItemType(14, "Humans");
		ItemType.Meteorite = new ItemType(15, "Meteorite");
		ItemType.CopperHammer = new ItemType(16, "Copper Hammer");
		ItemType.IronHammer = new ItemType(17, "Iron Hammer");
		ItemType.FrozenMeteorite = new ItemType(18, "Frozen Meteorite");
		
		// define recipes
		recipes = new Array<Recipe>();
		addRecipe(ItemType.CopperHammer, ItemType.Wood, ItemType.Copper, 1);
		addRecipe(ItemType.IronHammer, ItemType.Wood, ItemType.Iron, 1);
		addRecipe(ItemType.Meteorite, ItemType.Stone, ItemType.Lava, 1);
		addRecipe(ItemType.FrozenMeteorite, ItemType.Meteorite, ItemType.Ice, 1);
		addRecipe(ItemType.Lava, ItemType.Fire, ItemType.Stone, 1);
		addRecipe(ItemType.Glass, ItemType.Sand, ItemType.Fire, 1);
		addRecipe(ItemType.Fire, ItemType.Wood, ItemType.Lava, 5);
		addRecipe(ItemType.Ice, ItemType.Water, ItemType.Ice, 2);
		addRecipe(ItemType.Ice, ItemType.FrozenMeteorite, ItemType.CopperHammer, 5);
		addRecipe(ItemType.Ice, ItemType.FrozenMeteorite, ItemType.IronHammer, 8);
		addRecipe(ItemType.Humans, ItemType.Humans, ItemType.Food, 2);
		addRecipe(ItemType.Steam, ItemType.Water, ItemType.Fire, 2);
		addRecipe(ItemType.Water, ItemType.Fire, ItemType.Ice, 2);
		addRecipe(ItemType.Stone, ItemType.Water, ItemType.Lava, 2);
		addRecipe(ItemType.Iron, ItemType.Meteorite, ItemType.Water, 2);
		addRecipe(ItemType.Food, ItemType.Food, ItemType.Water, 2);
		addRecipe(ItemType.Fire, ItemType.Humans, ItemType.Wood, 5);
		addRecipe(ItemType.Sand, ItemType.IronHammer, ItemType.Stone, 5);
		addRecipe(ItemType.Sand, ItemType.CopperHammer, ItemType.Stone, 3);
		addRecipe(ItemType.Fire, ItemType.Wood, ItemType.Fire, 5);
		
		// inventory
		inventory = new Array<InventoryItem>();
		resetInventory();
		
		// define starting worlds
		worlds = new List<World>();
		
		var world:World = new World();
		world.randomize();
		world.position.x = -200;
		world.position.y = -50;
		world.scale = 0.8;
		world.weather = WeatherType.Rain;
		addWorld(world);
		
		var world:World = new World();
		world.randomize();
		world.position.x = 0;
		world.position.y = -50;
		world.scale = 1.0;
		world.weather = WeatherType.Thunder;
		addWorld(world);
		
		var world:World = new World();
		world.randomize();
		world.position.x = 200;
		world.position.y = -50;
		world.scale = 0.8;
		world.weather = WeatherType.Cumulus;
		addWorld(world);
	}
	
	public function resetInventory():Void {
		for (item in inventory) {
			item.quantity = 0;
		}
		
		addInventoryItem(ItemType.Fire, 5);
		addInventoryItem(ItemType.Ice, 5);
		addInventoryItem(ItemType.Water, 5);
		addInventoryItem(ItemType.Stone, 5);
		addInventoryItem(ItemType.Wood, 5);
		addInventoryItem(ItemType.Copper, 0);
		addInventoryItem(ItemType.Iron, 0);
		addInventoryItem(ItemType.Sand, 5);
		addInventoryItem(ItemType.Steam, 0);
		addInventoryItem(ItemType.Lava, 0);
		addInventoryItem(ItemType.Glass, 0);
		addInventoryItem(ItemType.Food, 5);
		addInventoryItem(ItemType.Humans, 5);
		addInventoryItem(ItemType.Meteorite, 0);
		addInventoryItem(ItemType.CopperHammer, 0);
		addInventoryItem(ItemType.IronHammer, 0);
	}
	
	public function addWorld(world:World):Void {
		worlds.push(world);
	}
	
	public function addRecipe(result:ItemType, item1:ItemType, item2:ItemType, yield:Int):Void {
		var recipe:Recipe = new Recipe(item1, item2, result, yield);
		
		recipes.push(recipe);
	}
	
	public function addInventoryItem(itemType:ItemType, quantity:Int):Void {
		var item:InventoryItem;
		var pos:Int = indexOfInventoryItem(inventory, itemType);
		
		if (pos == -1) {
			item = new InventoryItem(itemType);
			item.quantity = quantity;
			inventory.push(item);
		}
		else {
			item = inventory[pos];
			item.quantity = item.quantity + quantity;
			
			modelChanged();
		}
	}
	
	public function pickUpItem(item:InventoryItem):Void {
		selectedItem = item;
		addInventoryItem(item.type, -1);
	}
	
	public function dropItem():Void {
		if(selectedItem != null) {
			addInventoryItem(selectedItem.type, 1);
			selectedItem = null;
		}
	}
	
	public function applySelectedItemToWorld(world:World):Void {
		world.applyItem(selectedItem.type);
		selectedItem = null;
	}
	
	public function mergeInventoryItems():Recipe {
		var item1:InventoryItem = selectedItem;
		var item2:InventoryItem = hoveredItem;
		
		if (item1 == item2 || item1 == null || item2 == null) {
			if (selectedItem != null) {					
				// failiure, return selected item
				addInventoryItem(selectedItem.type, 1);
			}
			selectedItem = null;
			hoveredItem = null;
			return null;
		}
		
		var result:Recipe = mergeItems(item1, item2);
		if (result == null) {
			// failiure, return selected item
			addInventoryItem(selectedItem.type, 1);
		}
		else {
			// success, remove one of the hovered items from the inventory
			addInventoryItem(hoveredItem.type, -1);
		}
		selectedItem = null;
		hoveredItem = null;
		
		return result;
	}
	
	public function mergeItems(item1:InventoryItem, item2:InventoryItem):Recipe {
		for (recipe in recipes) {
			if (recipe.isCompatable(item1.type, item2.type)) {
				addInventoryItem(recipe.result, recipe.yield);
				return recipe;
			}
		}
		return null;
	}
	
	private static function indexOfInventoryItem(haystack:Array<InventoryItem>, needle:ItemType):Int {
		var n:Int = 0;
		for (item in haystack) {
			if (item == null) {
				// skip over
			}
			else if (item.type == needle) {
				return n;
			}
			n++;
		}
		return -1;
	}
	
	private function modelChanged():Void {
		dispatchEvent(new Event(Event.CHANGE));
	}
	
	private function nameFor(itemType:ItemType):Void {
		
	}
}
package net.mkv25.ld23.world.data;
import net.mkv25.ld23.world.type.ItemType;
import net.mkv25.ld23.world.type.MoistureType;
import net.mkv25.ld23.world.type.TemperatureType;
import net.mkv25.ld23.world.type.WeatherType;
import nme.geom.Point;
import nme.Vector;

/**
 * Represents a world in all its data.
 * @author John Beech
 */

class World {
	public var biome:Biome;
	public var dynamicBiome:Bool;
	public var worldDestroyed:Bool;
	
	public var temperature:Float;
	public var moisture:Float;
	public var vegetation:Float;
	public var constructs:List<Construct>;
	
	public var temperatureType:TemperatureType;
	public var moistureType:MoistureType;
	
	public var temperatureDeltaVelocity:Float;
	public var moistureDeltaVelocity:Float;
	public var vegetationDeltaVelocity:Float;
	public var climateFriction:Float;
	public var glassStrength:Float;
	
	public var weather:WeatherType;
	public var harvestableItem:ItemType;
	public var appliedItem:ItemType;
	public var appliedEffect:String;
	
	public var population:Float;
	public var workerSpeed:Float;
	public var workRemainingTilHarvest:Float;
	
	public var position:Point;
	public var scale:Float;
		
	public static var MOISTURE_RANGE:Float = 50.0;
	public static var TEMPERATURE_RANGE:Float = 50.0;
	public static var VEGETATION_RANGE:Float = 5.0;
	public static var WORKERSPEED_RANGE:Float = 10.0;
	
	private var weatherChangeDelay:Int;
		
	public function new() {
		scale = 0.0;
		
		randomize();
	}
	
	public function randomize():Void {
		// Initial settings:
		biome = Biome.Grass;
		dynamicBiome = true;
		worldDestroyed = false;
				
		temperature = 0.0;
		moisture = 0.0;
		vegetation = 1.0;
		constructs = new List<Construct>();
		
		temperatureType = TemperatureType.Mild;
		moistureType = MoistureType.Mild;
		
		temperatureDeltaVelocity = 0.0;
		moistureDeltaVelocity = 0.0;
		vegetationDeltaVelocity = 0.0;
		climateFriction = 0.95;
		glassStrength = 2.0;
		
		weather = WeatherType.Rain;
		harvestableItem = ItemType.Food;
		
		population = 1.0;
		workerSpeed = 1.0 + Math.random() * 5;
		workRemainingTilHarvest = 50;
		
		if(position == null) {
			position = new Point();
		}
		if(scale == 0.0) {
			scale = 1.0;
		}
		
		weatherChangeDelay = 0;
		
		// Random settings:
		temperature = (0.5 - Math.random()) * (TEMPERATURE_RANGE * 2);
		moisture = (0.5 - Math.random()) * (MOISTURE_RANGE * 2);
		vegetation = Math.random() * VEGETATION_RANGE;
		
		temperatureDeltaVelocity = (0.5 - Math.random()) * 10;
		moistureDeltaVelocity = (0.5 - Math.random()) * 10;
		vegetationDeltaVelocity = (0.5 - Math.random()) * 3;
		
		update(0);
	}
	
	public function update(seed:Int):Void {
		if (dynamicBiome) {
			// apply changes (tick)
			temperature = temperature + temperatureDeltaVelocity;
			moisture = moisture + moistureDeltaVelocity;
			vegetation = vegetation + vegetationDeltaVelocity;
			workRemainingTilHarvest = workRemainingTilHarvest - workerSpeed;
			
			// limit temperature range
			if (temperature > TEMPERATURE_RANGE) {
				temperature = TEMPERATURE_RANGE;
			}
			else if (temperature < - TEMPERATURE_RANGE) {
				temperature = - TEMPERATURE_RANGE;
			}
			
			// limit moisture range
			if (moisture < - MOISTURE_RANGE) {
				moisture = - MOISTURE_RANGE;
			}
			else if (moisture > MOISTURE_RANGE) {
				moisture = MOISTURE_RANGE;
			}
			
			// limit vegetation range
			if (vegetation < 0) {
				vegetation = 0;
			}
			else if (vegetation > VEGETATION_RANGE) {
				vegetation = VEGETATION_RANGE;
			}
			
			// limit worker speed
			if (workerSpeed > WORKERSPEED_RANGE) {
				workerSpeed = WORKERSPEED_RANGE;
			}
			if (workerSpeed < 1) {
				workerSpeed = 1;
			}
			
			// apply climate friction
			temperatureDeltaVelocity = temperatureDeltaVelocity * climateFriction;
			moistureDeltaVelocity = moistureDeltaVelocity * climateFriction;
			vegetationDeltaVelocity = vegetationDeltaVelocity * climateFriction;
			
			// check for harvest
			if (workRemainingTilHarvest < 0) {
				workRemainingTilHarvest = 0;
			}
			
			// ressasign biome
			autoAssignBiome();
		}
		
		// update weather
		if (weatherChangeDelay == 0) {
			weatherChangeDelay = cast (10 + (0.5 - Math.random()) * 10);
			
			weather = biome.weatherPattern[(seed + biome.tileOffset) % biome.weatherPattern.length];
		}
		else {
			weatherChangeDelay = weatherChangeDelay - 1;
		}
		
		// check glass strength
		if (glassStrength <= 0.0) {
			destroyWorld();
		}
		
	}
	
	public function destroyWorld():Void {
		glassStrength = 0;
		dynamicBiome = false;
		worldDestroyed = true;
		
		biome = Biome.DestroyedGlass;
	}
	
	public function harvestItem():ItemType {
		workRemainingTilHarvest = 1000;
		
		appliedEffect = "Harvested " + harvestableItem.name + "!";
		
		return harvestableItem;
	}
	
	public function applyItem(item:ItemType):Void {
		if (item == ItemType.Fire) {
			appliedEffect = "Getting Hotter!";
			temperatureDeltaVelocity = temperatureDeltaVelocity + 1.0;
		}
		else if (item == ItemType.Ice) {
			appliedEffect = "Getting Colder!";
			temperatureDeltaVelocity = temperatureDeltaVelocity - 1.0;
		}
		else if (item == ItemType.Water) {
			appliedEffect = "Getting Wetter!";
			moistureDeltaVelocity = moistureDeltaVelocity + 1.0;
		}
		else if (item == ItemType.Stone) {
			appliedEffect = "Getting Cooler, and Drier!";
			temperatureDeltaVelocity = temperatureDeltaVelocity - 0.5;
			moistureDeltaVelocity = moistureDeltaVelocity - 0.5;
		}
		else if (item == ItemType.Wood) {
			appliedEffect = "Getting Moist, and Warm!";
			temperatureDeltaVelocity = temperatureDeltaVelocity + 0.5;
			moistureDeltaVelocity = moistureDeltaVelocity + 0.5;
			vegetationDeltaVelocity = vegetationDeltaVelocity + 0.1;
		}
		else if (item == ItemType.Copper) {
			appliedEffect = "Getting Cooler, and Drier!";
			temperatureDeltaVelocity = temperatureDeltaVelocity - 0.5;
			moistureDeltaVelocity = moistureDeltaVelocity - 0.5;
		}
		else if (item == ItemType.Iron) {
			appliedEffect = "Getting Cooler, and Drier!";
			temperatureDeltaVelocity = temperatureDeltaVelocity - 0.5;
			moistureDeltaVelocity = moistureDeltaVelocity - 0.5;
		}
		else if (item == ItemType.Sand) {
			appliedEffect = "Getting much much Drier!";
			moistureDeltaVelocity = moistureDeltaVelocity - 1.0;
		}
		else if (item == ItemType.Steam) {
			appliedEffect = "Getting very Hot and Wet!";
			temperatureDeltaVelocity = temperatureDeltaVelocity + 0.8;
			moistureDeltaVelocity = moistureDeltaVelocity + 0.8;
		}
		else if (item == ItemType.Lava) {
			appliedEffect = "Getting very Hot and Dry!";
			temperatureDeltaVelocity = temperatureDeltaVelocity + 0.8;
			moistureDeltaVelocity = moistureDeltaVelocity - 0.8;
		}
		else if (item == ItemType.Glass) {
			appliedEffect = "Increased strength of Glass!";
			glassStrength = glassStrength + 0.2;
		}
		else if (item == ItemType.Food) {
			appliedEffect = "Increased Vegetation!";
			vegetationDeltaVelocity = vegetationDeltaVelocity + 0.2;
		}
		else if (item == ItemType.Humans) {
			appliedEffect = "Increased Population, and Work Speed!";
			population = population + 1.0;
			workerSpeed = workerSpeed + 1.0;
		}
		else if (item == ItemType.Meteorite) {
			appliedEffect = "Destroyed vegetation! Getting Hotter! ";
			temperatureDeltaVelocity = temperatureDeltaVelocity + 3.0;
			moistureDeltaVelocity = moistureDeltaVelocity - 1.0;
			vegetationDeltaVelocity = vegetationDeltaVelocity - 1.0;
		}
		else if (item == ItemType.CopperHammer) {
			appliedEffect = "Made a scratch in the glass!";
			glassStrength = glassStrength - 0.2;
		}
		else if (item == ItemType.IronHammer) {
			appliedEffect = "Made a crack in the glass!";
			glassStrength = glassStrength - 0.5;
		}
		else if (item == ItemType.FrozenMeteorite) {
			appliedEffect = "Destroyed vegetation! Getting Very Cold! ";
			temperatureDeltaVelocity = temperatureDeltaVelocity - 3.0;
			moistureDeltaVelocity = moistureDeltaVelocity + 1.0;
			vegetationDeltaVelocity = vegetationDeltaVelocity - 1.0;
		}
		else {
			appliedEffect = item.name + "had no effect ;__;";
		}
	}
	
	private function autoAssignBiome():Void {
		// categorise moisture
		if (moisture < - 20.0) {
			moistureType = MoistureType.Dry;
		}
		else if(moisture > 20.0) {
			moistureType = MoistureType.Wet;
		}
		else { 
			moistureType = MoistureType.Mild;
		}
		// categorise temperature
		if (temperature < - 20.0) {
			temperatureType = TemperatureType.Cold;
		}
		else if (temperature > 20.0) {
			temperatureType = TemperatureType.Hot;
		}
		else {
			temperatureType = TemperatureType.Mild;
		}
		
		// select biome
		if (moistureType == MoistureType.Dry) {
			if (temperatureType == TemperatureType.Cold) {
				biome = Biome.Rock;
				harvestableItem = ItemType.Stone;
			}
			else if (temperatureType == TemperatureType.Mild) {
				biome = Biome.Desert;
				harvestableItem = ItemType.Sand;
			}
			else if (temperatureType == TemperatureType.Hot) {
				biome = Biome.Volcano;
				harvestableItem = ItemType.Lava;
			}
		}
		else if (moistureType == MoistureType.Mild) {
			if (temperatureType == TemperatureType.Cold) {
				biome = Biome.Permafrost;
				harvestableItem = ItemType.Iron;
			}
			else if (temperatureType == TemperatureType.Mild) {
				biome = Biome.Grass;
				harvestableItem = ItemType.Food;
			}
			else if (temperatureType == TemperatureType.Hot) {
				biome = Biome.Scrub;
				harvestableItem = ItemType.Copper;
			}
		}
		else if (moistureType == MoistureType.Wet) {
			if (temperatureType == TemperatureType.Cold) {
				biome = Biome.Snow;
				harvestableItem = ItemType.Ice;
			}
			else if (temperatureType == TemperatureType.Mild) {
				biome = Biome.Wetland;
				harvestableItem = ItemType.Water;
			}
			else if (temperatureType == TemperatureType.Hot) {
				biome = Biome.Jungle;
				harvestableItem = ItemType.Steam;
			}
		}
	}
	
}
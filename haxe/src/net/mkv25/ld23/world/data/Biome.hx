package net.mkv25.ld23.world.data;
import net.mkv25.ld23.world.type.MoistureType;
import net.mkv25.ld23.world.type.TemperatureType;
import net.mkv25.ld23.world.type.WeatherType;

/**
 * Represents a bicome
 * @author John Beech
 */

class Biome {

	public static var Snow:Biome;
	public static var Permafrost:Biome;
	public static var Rock:Biome;
	
	public static var Wetland:Biome;
	public static var Grass:Biome;
	public static var Desert:Biome;
	
	public static var Jungle:Biome;
	public static var Scrub:Biome;
	public static var Volcano:Biome;
	
	public static var DestroyedGlass:Biome;
	
	public var tileOffset:Int;
	public var temperatureType:TemperatureType;
	public var moistureType:MoistureType;
	public var weatherPattern:Array<WeatherType>;
	
	public function new(tileOffset:Int, temperatureType:TemperatureType, moistureType:MoistureType, pattern:Array<WeatherType>) {
		this.tileOffset = tileOffset;
		this.temperatureType = temperatureType;
		this.moistureType = moistureType;
		
		weatherPattern = pattern;
	}
	
}
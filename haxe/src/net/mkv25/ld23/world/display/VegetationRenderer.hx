package net.mkv25.ld23.world.display;
import net.mkv25.ld23.util.ImageMap;
import net.mkv25.ld23.world.data.Biome;
import net.mkv25.ld23.world.data.World;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.geom.Point;

/**
 * ...
 * @author John Beech
 */

class VegetationRenderer 
{
	public var artwork:Sprite;
	public var vegetationTiles:Array<BitmapData>;
	public var vegetationBitmaps:Array<Bitmap>;
	
	public var positions:Array<Point>;
	
	public static var VEGETATION_LEVELS:Int = 5;
	
	public function new() {
		artwork = new Sprite();
		vegetationTiles = ImageMap.createMap("assets/tw_vegetation.png", 48, 48);
	
		vegetationBitmaps = new Array<Bitmap>();
		positions = new Array<Point>();
		positions.push(new Point(-10, 0));
		positions.push(new Point(10, 50));
		positions.push(new Point(-120, 40));
		positions.push(new Point(110, 20));
		positions.push(new Point(-75, 80));
		positions.push(new Point(80, 80));
		
		var bitmap:Bitmap;
		var position:Point;
		for (i in 0...6) {
			bitmap = new Bitmap();
			artwork.addChild(bitmap);
			vegetationBitmaps.push(bitmap);
			
			position = positions[i];
			bitmap.x = position.x - 24;
			bitmap.y = position.y - 24;
		}
	}
	
	public function render(world:World):Void {
		var vegetationType:Int = 0;
		
		// select vegetation type based off biome
		if (world.biome == Biome.Desert) {
			vegetationType = 0;
		}
		else if (world.biome == Biome.Grass) {
			vegetationType = 2;
		}
		else if (world.biome == Biome.Jungle) {
			vegetationType = 4;
		}
		else if (world.biome == Biome.Permafrost) {
			vegetationType = 7;
		}
		else if (world.biome == Biome.Rock) {
			vegetationType = 7;
		}
		else if (world.biome == Biome.Scrub) {
			vegetationType = 3;
		}
		else if (world.biome == Biome.Snow) {
			vegetationType = 1;
		}
		else if (world.biome == Biome.Volcano) {
			vegetationType = 6;
		}
		else if (world.biome == Biome.Wetland) {
			vegetationType = 5;
		}
		
		if (world.worldDestroyed) {
			artwork.visible = false;
		}
		else {
			artwork.visible = true;
			
			var n:Int = 0;
			var level:Int = Math.floor(world.vegetation / World.VEGETATION_RANGE * VEGETATION_LEVELS);
			for (bitmap in vegetationBitmaps) {
				var adjust:Int = 0 - n % 2;
				var adjustLevel:Int = cast Math.max(level + adjust, 0);
				bitmap.bitmapData = vegetationTiles[vegetationType * VEGETATION_LEVELS + adjustLevel % VEGETATION_LEVELS];
				n++;
			}
		}
	}
	
}
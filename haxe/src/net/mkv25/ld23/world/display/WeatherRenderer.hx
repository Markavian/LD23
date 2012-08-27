package net.mkv25.ld23.world.display;

import net.mkv25.ld23.world.type.WeatherType;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import net.mkv25.ld23.util.ImageMap;

/**
 * Renders weather patterns into a cloud
 * @author John Beech
 */

class WeatherRenderer 
{
	private var assetName:String;
	
	public var artwork:Sprite;
	public var bitmapGroup:Sprite;
	
	public var cloudTiles:Array<BitmapData>;
	public var rainTiles:Array<BitmapData>;
	
	public var cloudBitmap:Bitmap;
	public var rainBitmap:Bitmap;
	public var thunderBitmap:Bitmap;
	
	private var frameCount:Int;

	public function new() {
		createChildren();
		organiseChildren();
		attachEvents();
	}
	
	private function createChildren():Void {
		artwork = new Sprite();
		bitmapGroup = new Sprite();
		
		cloudTiles = ImageMap.createMap("assets/tw_clouds.png", 168, 114);
		rainTiles = ImageMap.createMap("assets/tw_rain.png", 55, 86);
		
		cloudBitmap = new Bitmap();
		rainBitmap = new Bitmap();
		thunderBitmap = new Bitmap();
	}
	
	private function organiseChildren():Void {
		bitmapGroup.x = - 168 / 2;
		bitmapGroup.y = - 80;
		
		bitmapGroup.addChild(rainBitmap);
		bitmapGroup.addChild(thunderBitmap);
		bitmapGroup.addChild(cloudBitmap);
		
		cloudBitmap.x = 0;
		cloudBitmap.y = -80;
		
		rainBitmap.x = 50;
		rainBitmap.y = 20;
		
		thunderBitmap.x = 0;
		thunderBitmap.y = 10;
		
		artwork.addChild(bitmapGroup);
	}
	
	private function attachEvents():Void {
		
	}
	
	public function render(type:WeatherType, seed:Int):Void {
		var offset:Int = seed % 2;
		
		thunderBitmap.bitmapData = null;
		
		if (type == WeatherType.None) {
			cloudBitmap.bitmapData = null;
			rainBitmap.bitmapData = null;
		}
		else if (type == WeatherType.Cumulus) {
			cloudBitmap.bitmapData = cloudTiles[1];
			rainBitmap.bitmapData = null;
		}
		else if (type == WeatherType.Cirrus) {
			cloudBitmap.bitmapData = cloudTiles[0];
			rainBitmap.bitmapData = null;
		}
		else if (type == WeatherType.Rain) {
			cloudBitmap.bitmapData = cloudTiles[5];
			rainBitmap.bitmapData = rainTiles[2 + offset];
		}
		else if (type == WeatherType.Volcanic) {
			cloudBitmap.bitmapData = cloudTiles[3];
			rainBitmap.bitmapData = rainTiles[4 + offset];
		}
		else if (type == WeatherType.Ash) {
			cloudBitmap.bitmapData = cloudTiles[3];
			rainBitmap.bitmapData = null;
		}
		else if (type == WeatherType.HeavySnow) {
			cloudBitmap.bitmapData = cloudTiles[5];
			rainBitmap.bitmapData = rainTiles[6 + offset];
		}
		else if (type == WeatherType.Snow) {
			cloudBitmap.bitmapData = cloudTiles[1];
			rainBitmap.bitmapData = rainTiles[6 + offset];
		}
		else if (type == WeatherType.Downpour) {
			cloudBitmap.bitmapData = cloudTiles[3];
			rainBitmap.bitmapData = rainTiles[0 + offset];
		}
		else if (type == WeatherType.Thunder) {
			cloudBitmap.bitmapData = cloudTiles[3];
			rainBitmap.bitmapData = rainTiles[0 + offset];
			if (seed % 5 == 1 || seed % 7 == 3) {
				thunderBitmap.bitmapData = cloudTiles[4];
			}
		}
		else {
			cloudBitmap.bitmapData = null;
			rainBitmap.bitmapData = null;
		}
	}
	
	
}
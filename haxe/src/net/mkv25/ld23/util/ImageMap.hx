package net.mkv25.ld23.util;

import nme.display.BitmapData;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.Assets;

/**
 * Utility class for breaking up assets
 * @author John Beech
 */

class ImageMap {

	public function new() {
		throw "Usage Error: The ImageMap class is not meant to be instantiated.";
	}
	
	private static var cache:Hash<Array<BitmapData>>;
	
	public static function createMap(assetName:String, width:Int, height:Int = 0):Array<BitmapData> {
		if (cache == null) {
			cache = new Hash<Array<BitmapData>>();
		}
		
		if (cache.exists(assetName)) {
			return cache.get(assetName);
		}
		
		var bitmap:BitmapData = Assets.getBitmapData(assetName);
		
		if (height == 0) {
			height = width;
		}
		
		if (width == 0 || height == 0) {
			throw "No valid image data returned for (" + assetName + ").";
		}
		
		var r:Rectangle = new Rectangle();
		var p:Point = new Point();
		
		var cols:Int = cast bitmap.width / width;
		var rows:Int = cast bitmap.height / height;
		
		var tiles:Array<BitmapData> = new Array<BitmapData>(); 
		
		var tile:BitmapData; 
		r.width = width;
		r.height = height;
		for (y in 0...rows) {
			r.y = y * height;
			for (x in 0...cols) {
				r.x = x * width;
				tile = new BitmapData(width, height, true, 0xFF0000);
				tile.copyPixels(bitmap, r, p);
				tiles.push(tile);
			}
		}
		
		cache.set(assetName, tiles);
		
		return tiles;
	}
	
}
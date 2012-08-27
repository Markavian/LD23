package net.mkv25.ld23.world.display;

import net.mkv25.ld23.world.data.Star;
import nme.display.Bitmap;
import nme.display.BitmapData;
import net.mkv25.ld23.util.ImageMap;
import nme.display.Sprite;

/**
 * Renders an animates background stars
 * @author John Beech
 */

class StarRenderer {

	public var starCount:Int;
	public var width:Float;
	public var height:Float;

	public var artwork:Sprite;
	public var starTiles:Array<BitmapData>;
	public var stars:Array<Star>;	
	public var starBitmaps:Array<Bitmap>;
	
	public static var ANIMATION_FRAMES:Int = 3;
	
	public function new(starCount:Int = 20, width:Float, height:Float) {
		this.starCount = starCount;
		this.width = width;
		this.height = height;
		
		artwork = new Sprite();
		starTiles = ImageMap.createMap("assets/tw_stars.png", 15, 15);
		starBitmaps = new Array<Bitmap>();
				
		stars = new Array<Star>();
		var star:Star;
		var starBitmap:Bitmap;
		for (i in 0...starCount) {
			star = new Star();
			stars.push(star);
			
			starBitmap = new Bitmap();
			starBitmaps.push(starBitmap);
			starBitmap.bitmapData = starTiles[star.type * ANIMATION_FRAMES + (star.ageSeed % ANIMATION_FRAMES)];
			
			artwork.addChild(starBitmap);
		}
	}
	
	public function update(seed:Int):Void {		
		var n:Int = 0;
		var starBitmap:Bitmap;
		for (star in stars) {
			starBitmap = starBitmaps[n];
			n++;
			
			if (star.twinkleDelay > ANIMATION_FRAMES) {
				// nothing
			}
			else {
				starBitmap.x = star.x * width;
				starBitmap.y = star.y * height;
				starBitmap.bitmapData = starTiles[star.type * ANIMATION_FRAMES + (star.twinkleDelay + star.ageSeed) % ANIMATION_FRAMES];
				starBitmap.alpha = star.brightness;
			}
			
			if (star.twinkleDelay == 0) {
				star.twinkleDelay = star.twinkleSpeed;
			}
			star.twinkleDelay--;
		}
	}
	
}
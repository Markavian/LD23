package net.mkv25.ld23.world.data;
import nme.display.Bitmap;

/**
 * Represents a background star
 * @author John Beech
 */

class Star 
{
	public var x:Float;
	public var y:Float;
	public var ageSeed:Int;
	public var type:Int;
	public var brightness:Float;
	public var twinkleSpeed:Int;
	
	public var twinkleDelay:Int;
	
	public function new() {
		x = Math.random();
		y = Math.random();
		ageSeed = cast (Math.random() * 50);
		type = ageSeed % 3;
		brightness = 0.5 + (0.5 * Math.random());
		twinkleSpeed = 5 + ageSeed;
		twinkleDelay = 0;
	}
}
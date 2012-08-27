package net.mkv25.ld23.world.data;
import nme.Assets;
import nme.media.Sound;
import nme.media.SoundChannel;
import nme.media.SoundTransform;

/**
 * Sound assets.
 * @author John Beech
 */

class Sounds {
	public static var bgmMinatureWorldsOST:String = "assets/minature-worlds-ost.mp3";
	public static var sfxTing:String = "assets/sfx-ting.mp3";
	public static var sfxTink:String = "assets/sfx-tink.mp3";
	public static var sfxMetalDrop:String = "assets/sfx-metal-drop.mp3";
	public static var sfxMinatureWorlds:String = "assets/sfx-minature-worlds.mp3";
	
	
	private static var bgm:Sound;
	private static var sfx:Sound;
	private static var volume:SoundTransform;
	
	private static var bgmChannel:SoundChannel;
	private static var sfxChannel:SoundChannel;
	
	public static function setVolume(vol:Float):Void {
		volume = new SoundTransform();
		volume.volume = vol;
	}
	
	public static function playBGM(soundAsset:String, startTime:Float=0):Void {
		if (bgmChannel != null) {
			bgmChannel.stop();
		}
		
		bgm = Assets.getSound(soundAsset);
		bgmChannel = bgm.play(startTime, 9999, volume);
	}
	
	public static function playSFX(soundAsset:String):Void {
		if (sfxChannel != null) {
			sfxChannel.stop();
		}
		
		sfx = Assets.getSound(soundAsset);
		sfxChannel = sfx.play(0, 1, volume);
	}
	
}
package net.mkv25.ld23;
import net.mkv25.ld23.game.Game;
import net.mkv25.ld23.menu.Menu;
import nme.display.Sprite;
import nme.Lib;

/**
 * Not your average controller. This one is a little specialised.
 * @author John Beech
 */

class Controller {

	private var artwork:Sprite;
	
	private var game:Game;
	private var menu:Menu;
	
	public function new() {
		game = new Game();
		menu = new Menu(game);
		
		artwork = new Sprite();
		Lib.current.addChild(artwork);
		
		artwork.addChild(game.artwork);
		artwork.addChild(menu.artwork);
	}
	
}
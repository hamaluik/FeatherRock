package states;

import luxe.Color;
import luxe.Scene;
import luxe.States;
import luxe.Input;
import luxe.Text;

class Menu extends State {
	var menuScene:Scene;

	public function new() {
		super({ name: 'Menu' });

		menuScene = new Scene('menu');
	}

	override function onenter<T>(_:T) {
		trace("Entered menu");
		var text:Text = new Text({
			pos: Luxe.screen.mid,
			text: "Menu",
			align: TextAlign.center,
			align_vertical: TextAlign.center,
			color: new Color(1, 1, 1, 1),
			scene: menuScene
		});
		

		Luxe.camera.pos.set_xy(0, 0);
	}

	override function onleave<T>(_:T) {
		menuScene.empty();
		trace("Left menu");
	}

	override function onkeyup(e:KeyEvent) {
		if(e.keycode == Key.escape) {
			Main.transition('Play');
		}
	}
}
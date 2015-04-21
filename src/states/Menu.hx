package states;

import luxe.Color;
import luxe.Scene;
import luxe.States;
import luxe.Input;
import luxe.Text;
import phoenix.Texture;
import luxe.Sprite;
import luxe.components.sprite.SpriteAnimation;
import luxe.Vector;

class Menu extends State {
	var menuScene:Scene;

	public function new() {
		super({ name: 'Menu' });

		menuScene = new Scene('menu');
	}

	override function onenter<T>(_:T) {
		Luxe.camera.pos.set_xy(0, 0);
		Luxe.camera.zoom = 1;
		Luxe.renderer.clear_color = new Color().rgb(0x0b1827);

		Main.musicManager.loop("theme");

		var title:Text = new Text({
			pos: Luxe.screen.mid.clone().add_xyz(0, -48),
			text: "FEATHERROCK",
			align: TextAlign.center,
			align_vertical: TextAlign.center,
			color: new Color(1, 1, 1, 1),
			scene: menuScene,
			font: Main.uiFont,
			point_size: 48
		});

		var featherRockTexture:Texture = Luxe.resources.find_texture("assets/sprites/featherrock.png");
		featherRockTexture.filter = FilterType.nearest;
		var rock:Sprite = new Sprite({
			name: 'FeatherRock',
			pos: Luxe.screen.mid.clone(),
			size: new Vector(64, 64),
			texture: featherRockTexture,
			scene: menuScene
		});
		var anim:SpriteAnimation = rock.add(new SpriteAnimation({ name: 'SpriteAnimation' }));
		anim.add_from_json_object(Luxe.resources.find_json('assets/sprites/featherrock.json').json);
		anim.animation = 'flying idle';
		anim.play();

		var clickToPlay:Text = new Text({
			pos: Luxe.screen.mid.clone().add_xyz(0, 48),
			text: "Click to play",
			align: TextAlign.center,
			align_vertical: TextAlign.center,
			color: new Color(1, 1, 1, 1),
			scene: menuScene,
			font: Main.uiFont,
			point_size: 16
		});

		var disclaimer:Text = new Text({
			pos: new Vector(Luxe.screen.w - 8, Luxe.screen.h),
			text: "* A game made from scratch in 48 hours for Ludum Dare 32 by Kenton Hamaluik Apr. 18-19 2015",
			align: TextAlign.right,
			align_vertical: TextAlign.bottom,
			color: new Color(1, 1, 1, 1),
			scene: menuScene,
			font: Main.uiFont,
			point_size: 8
		});

		Luxe.camera.pos.set_xy(0, 0);
	}

	override function onleave<T>(_:T) {
		menuScene.empty();
		trace("Left menu");
	}

	override function onmouseup(e:MouseEvent) {
		Main.transition('Play');
	}
}
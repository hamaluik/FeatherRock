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

class End extends State {
	var endScene:Scene;

	public function new() {
		super({ name: 'End' });

		endScene = new Scene('end');
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
			scene: endScene,
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
			scene: endScene
		});
		var anim:SpriteAnimation = rock.add(new SpriteAnimation({ name: 'SpriteAnimation' }));
		anim.add_from_json_object(Luxe.resources.find_json('assets/sprites/featherrock.json').json);
		anim.animation = 'flying idle';
		anim.play();

		var fin:Text = new Text({
			pos: Luxe.screen.mid.clone().add_xyz(0, 48),
			text: "- fin -",
			align: TextAlign.center,
			align_vertical: TextAlign.center,
			color: new Color(1, 1, 1, 1),
			scene: endScene,
			font: Main.uiFont,
			point_size: 16
		});

		var explanation:Text = new Text({
			pos: Luxe.screen.mid.clone().add_xyz(0, 72),
			text: "(or at least, my time was)\n:(",
			align: TextAlign.center,
			align_vertical: TextAlign.center,
			color: new Color(1, 1, 1, 1),
			scene: endScene,
			font: Main.uiFont,
			point_size: 8
		});

		Luxe.camera.pos.set_xy(0, 0);
	}

	override function onleave<T>(_:T) {
		endScene.empty();
	}

	override function onmouseup(e:MouseEvent) {
		Main.transition('Cinematic');
	}
}
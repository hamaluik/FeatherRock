package states;

import luxe.Color;
import luxe.Rectangle;
import luxe.Scene;
import luxe.Sprite;
import luxe.Visual;
import luxe.States;
import luxe.Input;
import luxe.Text;
import luxe.Vector;
import motion.Actuate;
import phoenix.Texture;

typedef CinematicSlide = {
	var text:String;
	var image:String;
}

class Cinematic extends State {
	var cinematicScene:Scene;

	var slides:Array<CinematicSlide> = new Array<CinematicSlide>();
	var currentSlide:Int = 0;

	var cinematicImage:Texture;
	var picture:Sprite;
	var caption:Text;

	var controlsFrozen:Bool = false;

	public function new() {
		super({ name: 'Cinematic' });
		cinematicScene = new Scene('cinematic');
	}

	override function onenter<T>(_:T) {
		Luxe.camera.pos = new Vector(0, 0);
		Luxe.camera.zoom = 1;
		Luxe.renderer.clear_color = new Color(0, 0, 0, 1);

		Main.musicManager.loop("theme");

		picture = new Sprite({
			name: 'cinematic.image',
			scene: cinematicScene,
			pos: Luxe.screen.mid.clone(),
			color: new Color(1, 1, 1, 1),
			size: new Vector(1024, 1024)
		});

		caption = new Text({
			name: 'cinematic.caption',
			scene: cinematicScene,
			pos: new Vector(0, Luxe.screen.h - 64),
			color: new Color(1, 1, 1, 1),
			text: "",
			font: Main.uiFont,
			point_size: 16,
			align: TextAlign.center,
			align_vertical: TextAlign.center,
			bounds_wrap: true,
			bounds: new Rectangle(0, 0, Luxe.screen.w * 0.99, 64)
		});

		slides = Luxe.resources.find_json("assets/cinematic/cinematic.json").json.slides;
		showSlide(slides[currentSlide]);
	}

	override function onleave<T>(_:T) {
		cinematicScene.empty();
	}

	function showSlide(slide:CinematicSlide) {
		cinematicImage = Luxe.resources.find_texture("assets/cinematic/" + slide.image);
		cinematicImage.filter = FilterType.nearest;
		picture.texture = cinematicImage;
		caption.text = slide.text;
	}

	override function onmouseup(e:MouseEvent) {
		if(controlsFrozen) return;

		currentSlide++;
		if(currentSlide >= slides.length) {
			Main.transition('Menu');
			return;
		}

		controlsFrozen = true;
		Actuate.tween(caption.color, 0.5, { a: 0 });
		Actuate.tween(picture.color, 0.5, { a: 0 }).onComplete(function() {
			showSlide(slides[currentSlide]);
			Actuate.tween(caption.color, 0.5, { a: 1 });
			Actuate.tween(picture.color, 0.5, { a: 1 }).onComplete(function() {
				controlsFrozen = false;
			});
		});
	}
}
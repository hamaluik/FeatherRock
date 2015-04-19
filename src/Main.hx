import components.FeatherRockAnimator;
import components.FeatherRockPhysics;
import components.GroundDetector;
import components.MouseBulletTime;
import effects.CircleTransitionEffect;
import motion.Actuate;
import phoenix.Camera;
import luxe.Color;
import luxe.components.sprite.SpriteAnimation;
import luxe.Entity;
import luxe.importers.tiled.TiledMap;
import luxe.importers.tiled.TiledObjectGroup;
import luxe.Input;
import luxe.Log;
import luxe.physics.nape.DebugDraw;
import luxe.Scene;
import luxe.Sprite;
import luxe.Vector;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.shape.Polygon;
import phoenix.Batcher;
import phoenix.Texture;
import luxe.Parcel;
import luxe.Rectangle;
import luxe.States;
import states.Menu;
import states.Play;
import effects.Effects;
import effects.BloomEffect;

typedef PlayerData = {
	var magic:Float;
}

typedef GameData = {
	var currentLevel:Int;
}

class Main extends luxe.Game {
	public static var fsm:luxe.States;
	public static var drawer:DebugDraw;
	public static var uiFont:phoenix.BitmapFont;

	public static var playerData:PlayerData = {
		magic: 100
	};
	public static var gameData:GameData = {
		currentLevel: 0
	}

	var effects:Effects = new Effects();
	static var transitionEffect:CircleTransitionEffect = new CircleTransitionEffect();

	override function ready() {
		// load the parcel
		Luxe.loadJSON("assets/parcel.json", function(jsonParcel) {
			var parcel = new Parcel();
			parcel.from_json(jsonParcel.json);

			// show a loading bar
			// use a fancy custom loading bar (https://github.com/FuzzyWuzzie/CustomLuxePreloader)
			new DigitalCircleParcelProgress({
				parcel: parcel,
				oncomplete: assetsLoaded
			});
			
			// start loading!
			parcel.load();
		});
	} //ready

	function assetsLoaded(_) {
		TweakConfig.load(Luxe.resources.find_json("assets/tweakconfig.json").json);

		Luxe.renderer.clear_color = new Color().rgb(0x719ecf);
		Luxe.camera.zoom = 2;

		Luxe.input.bind_key('flap', Key.space);
		Luxe.input.bind_key('flap', Key.key_w);
		Luxe.input.bind_key('left', Key.key_a);
		Luxe.input.bind_key('left', Key.left);
		Luxe.input.bind_key('right', Key.key_d);
		Luxe.input.bind_key('right', Key.right);

        uiFont = Luxe.resources.find_font("assets/Minecraftia.fnt");
        for(t in uiFont.pages.iterator()) {
        	t.filter = FilterType.nearest;
        }

        Luxe.renderer.batcher.add_group(5,
            function(b:phoenix.Batcher) {
                Luxe.renderer.blend_mode(BlendMode.src_alpha, BlendMode.one);
            },
            function(b:phoenix.Batcher) {
                Luxe.renderer.blend_mode();
            }
        );

		// physics drawing
		//drawer = new DebugDraw(); Luxe.physics.nape.debugdraw = drawer;

		// load the effects
		effects.onload();
		var bloomEffect:BloomEffect = new BloomEffect();
		effects.addEffect(bloomEffect);
		bloomEffect.threshold = TweakConfig.bloomTheshold;
		effects.addEffect(transitionEffect);

		fsm = new States();
		fsm.add(new Menu());
		fsm.add(new Play());

		fsm.set('Play');
		Actuate.tween(transitionEffect, 2, { transition: 1 });

	} // assetsLoaded

	inline public static function centerCameraAt(_c:Vector) {
		Luxe.camera.center = _c;
		snapCamera();
	}

	inline public static function snapCamera() {
		Luxe.camera.pos.set_xy(Math.fround(Luxe.camera.pos.x), Math.fround(Luxe.camera.pos.y));
	}

	override function update(dt:Float) {
		effects.update(dt);
	}

	override function onprerender() {
		effects.onprerender();
	}

	override function onpostrender() {
		effects.onpostrender();
	}

	public static function transition(newState:String) {
		Luxe.timescale = 0.001;
		Actuate.tween(transitionEffect, 1, { transition: 0 }).ease(motion.easing.Sine.easeIn).onComplete(function() {
			fsm.set(newState);
			Actuate.tween(transitionEffect, 1, { transition: 1 }).ease(motion.easing.Sine.easeIn).onComplete(function() {
				Luxe.timescale = 1;
			});
		});
	}

} //Main

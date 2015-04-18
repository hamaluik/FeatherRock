import components.FeatherRockAnimator;
import components.FeatherRockPhysics;
import components.GroundDetector;
import components.MouseBulletTime;
import luxe.Color;
import luxe.components.sprite.SpriteAnimation;
import luxe.Entity;
import luxe.importers.tiled.TiledMap;
import luxe.importers.tiled.TiledObjectGroup;
import luxe.Input;
import luxe.Log;
import luxe.physics.nape.DebugDraw;
import luxe.Sprite;
import luxe.Vector;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.shape.Polygon;
import phoenix.Texture;
import luxe.Parcel;

class Main extends luxe.Game {
	var tilemap:TiledMap;
	public static var drawer:DebugDraw;

	var featherrock:Sprite;

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
		centerCameraAt(new Vector(128, 128));

		Luxe.input.bind_key('flap', Key.space);
		Luxe.input.bind_key('flap', Key.key_w);
		Luxe.input.bind_key('left', Key.key_a);
		Luxe.input.bind_key('left', Key.left);
		Luxe.input.bind_key('right', Key.key_d);
		Luxe.input.bind_key('right', Key.right);

		tilemap = new TiledMap({
			tiled_file_data: Luxe.resources.find_text("assets/maps/dev.tmx").text,
			asset_path: "assets/maps/"
		});

		tilemap.display({
			filter: FilterType.nearest
		});

		// physics drawing
		//drawer = new DebugDraw();
		//Luxe.physics.nape.debugdraw = drawer;

		// load featherrock

		// load all the objects
		for(group in tilemap.tiledmap_data.object_groups) {
			switch(group.name) {
				case "Collisions": {
					for(object in group.objects) {
						switch(object.object_type) {
							case TiledObjectType.rectangle: {
								var box = new Body(BodyType.STATIC);
								box.shapes.add(new Polygon(Polygon.box(object.width, object.height)));
								box.position.setxy(object.pos.x + object.width / 2, object.pos.y + object.height / 2);
								box.space = Luxe.physics.nape.space;
								box.cbTypes.add(PhysicsTypes.ground);

								if(drawer != null) drawer.add(box);
							}

							default: {}
						}
					}
				}

				case "Spawns": {
					for(object in group.objects) {
						switch(object.name) {
							case "FeatherRock": {
								spawnFeatherRock(object.pos);
							}
						}
					}
				}

				default: {}
			}
		}

	} // assetsLoaded

	function spawnFeatherRock(pos:Vector) {
		var featherRockTexture:Texture = Luxe.resources.find_texture("assets/sprites/featherrock.png");
		featherRockTexture.filter = FilterType.nearest;
		featherrock = new Sprite({
			name: 'FeatherRock',
			pos: pos,
			size: new Vector(16, 16),
			texture: featherRockTexture
		});

		featherrock.add(new FeatherRockPhysics());

		var anim:SpriteAnimation = featherrock.add(new SpriteAnimation({ name: 'SpriteAnimation' }));
		anim.add_from_json_object(Luxe.resources.find_json('assets/sprites/featherrock.json').json);
		anim.animation = 'flying idle';
		anim.play();

		featherrock.add(new GroundDetector());
		featherrock.add(new FeatherRockAnimator());
		featherrock.add(new MouseBulletTime());
		featherrock.add(new components.LazyCameraFollow());
		featherrock.add(new components.ShakeCameraOnLand());
		featherrock.add(new components.FeatherRockDiver());
		featherrock.add(new components.FeatherRockDiveDrawer());

		centerCameraAt(pos);
	}

	inline public static function centerCameraAt(_c:Vector) {
		Luxe.camera.center = _c;
		snapCamera();
	}

	inline public static function snapCamera() {
		Luxe.camera.pos.set_xy(Math.fround(Luxe.camera.pos.x), Math.fround(Luxe.camera.pos.y));
	}

} //Main

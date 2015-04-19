package states;

import components.FeatherRockAnimator;
import components.FeatherRockPhysics;
import components.GroundDetector;
import components.MouseBulletTime;
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

class Play extends State {
	var tilemap:TiledMap;
	var featherrock:Sprite;
	var terrain:Array<Body> = new Array<Body>();
	var hudBatcher:Batcher;

	var playScene:Scene;

	public function new() {
		super({ name: 'Play' });
		playScene = new Scene('play');
	}

	override function onenter<T>(_:T) {
		trace("Entered play");
		tilemap = new TiledMap({
			tiled_file_data: Luxe.resources.find_text("assets/maps/dev.tmx").text,
			asset_path: "assets/maps/"
		});

		tilemap.display({
			filter: FilterType.nearest
		});

		Luxe.camera.pos.set_xy(0, 0);

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
								terrain.push(box);

								if(Main.drawer != null) Main.drawer.add(box);
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

				case "Breakable": {
					for(object in group.objects) {
						spawnBreakableBlock(object.pos);
					}
				}

				case "Elves": {
					for(object in group.objects) {
						spawnElf(object.pos);
					}
				}

				case "Goal": {
					for(object in group.objects) {
						spawnExit(new Rectangle(object.pos.x, object.pos.y, object.width, object.height));
					}
				}

				default: {}
			}
		}

		createUI();
	}

	override function onleave<T>(_:T) {
		for(body in terrain) {
			if(Main.drawer != null) Main.drawer.remove(body);
			Luxe.physics.nape.space.bodies.remove(body);
		}
		terrain.splice(0, terrain.length);
		playScene.empty();
		tilemap.visual.destroy();
		trace("Left play");
	}

	function createUI() {
		hudBatcher = new Batcher(Luxe.renderer, 'hud batcher');
		var hudView:Camera = new Camera();

		hudBatcher.view = hudView;
		hudBatcher.layer = 2;
		Luxe.renderer.add_batch(hudBatcher);
		var magicText = new luxe.Text({
			text: "Magic",
			pos: new Vector(4, 4),
			point_size: 16,
			font: Main.uiFont,
			batcher: hudBatcher,
			scene: playScene
		});
		magicText.add(new components.MagicDisplay(magicText));
	}

	function spawnFeatherRock(pos:Vector) {
		var featherRockTexture:Texture = Luxe.resources.find_texture("assets/sprites/featherrock.png");
		featherRockTexture.filter = FilterType.nearest;
		featherrock = new Sprite({
			name: 'FeatherRock',
			pos: pos,
			size: new Vector(16, 16),
			texture: featherRockTexture,
			scene: playScene
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
		featherrock.add(new components.ShakeCameraOnHit());
		featherrock.add(new components.FeatherRockDiver());
		featherrock.add(new components.FeatherRockDiveDrawer());

		//Main.centerCameraAt(pos);
	}

	function spawnBreakableBlock(pos:Vector) {
		var blockTexture:Texture = Luxe.resources.find_texture("assets/sprites/breakable_block.png");
		blockTexture.filter = FilterType.nearest;

		var block = new Sprite({
			name: 'BreakableBlock',
			name_unique: true,
			pos: pos,
			size: new Vector(16, 16),
			texture: blockTexture,
			scene: playScene
		});
		block.add(new components.Destructible(featherrock));
		block.add(new components.OneShotParticlesOnDestroy(new Color().rgb(0x5d3465)));
	}

	function spawnElf(pos:Vector) {
		var elfTexture:Texture = Luxe.resources.find_texture("assets/sprites/elf.png");
		elfTexture.filter = FilterType.nearest;

		var elf = new Sprite({
			name: 'Elf',
			name_unique: true,
			pos: pos.add_xyz(8, 16),
			size: new Vector(16, 32),
			texture: elfTexture,
			scene: playScene
		});

		var anim:SpriteAnimation = elf.add(new SpriteAnimation({ name: 'SpriteAnimation' }));
		anim.add_from_json_object(Luxe.resources.find_json('assets/sprites/elf.json').json);
		anim.animation = 'walk';
		anim.play();

		elf.add(new components.Destructible(featherrock, BodyType.DYNAMIC));
		elf.add(new components.OneShotParticlesOnDestroy(new Color().rgb(0xcf0000)));
		elf.add(new components.WalkBackAndForth(32));
		elf.add(new components.GiveMagicOnDestroy(50));
	}

	function spawnExit(rect:luxe.Rectangle) {
		var exit = new Entity({
			name: 'Exit',
			name_unique: true,
			scene: playScene
		});
		exit.add(new components.NextLevelOnPlayerTouch(rect));
	}
}
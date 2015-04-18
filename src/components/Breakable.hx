package components;

import luxe.Entity;
import luxe.Component;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.callbacks.OptionType;

class Breakable extends Component {
	var featherRock:Entity;
	public var frPhysics:FeatherRockPhysics;
	public var body:Body;
	var hitListener:InteractionListener;
	var lastVelocity:Float = 0;

	public function new(featherRock:Entity) {
		super({ name: 'Breakable' });
		this.featherRock = featherRock;
	}

	override function init() {
		frPhysics = cast featherRock.get('FeatherRockPhysics');

		body = new Body(BodyType.STATIC);
		var spr:luxe.Sprite = cast entity;
		body.shapes.add(new Polygon(Polygon.box(spr.size.x, spr.size.y)));
		body.position.setxy(entity.pos.x, entity.pos.y);
		body.space = Luxe.physics.nape.space;
		body.cbTypes.add(PhysicsTypes.breakable);

		if(Main.drawer != null) Main.drawer.add(body);

		hitListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, PhysicsTypes.breakable, PhysicsTypes.featherrock, onFeatherRockHit);
		Luxe.physics.nape.space.listeners.add(hitListener);
	}

	function onFeatherRockHit(cb:InteractionCallback) {
		if(lastVelocity >= TweakConfig.blockBreakVelocity && cb.int1.castBody.id == body.id) {
			entity.destroy();
		}
	}

	override function update(dt:Float) {
		lastVelocity = frPhysics.body.velocity.length;
	}

	override function ondestroy() {
		if(Main.drawer != null) Main.drawer.remove(body);
		Luxe.physics.nape.space.bodies.remove(body);
	}
}
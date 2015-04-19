package components;

import luxe.Input;
import luxe.Component;
import nape.callbacks.CbType;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Circle;

class FeatherRockPhysics extends Component {
	public var body:Body;
	public var canMoveLeft:Bool = true;
	public var canMoveRight:Bool = true;
	var type:CbType = PhysicsTypes.featherrock;

	public function new(?type:CbType) {
		super({ name: 'FeatherRockPhysics' });
		if(type != null) this.type = type;
	}

	override function init() {
		body = new Body(BodyType.DYNAMIC);
		var shape:Circle = new Circle(4);
		shape.filter.collisionMask = ~2;
		if(type == PhysicsTypes.deadrock) {
			shape.filter.collisionGroup = 2;
		}
		shape.material = new Material(TweakConfig.rockElasticity, 1.0, 2.0, 1.0, 0.001);
		body.shapes.add(shape);
		body.position.setxy(entity.pos.x, entity.pos.y);
		body.space = Luxe.physics.nape.space;
		body.allowRotation = false;
		body.cbTypes.add(type);


		if(Main.drawer != null) Main.drawer.add(body);
	}

	override function update(dt:Float) {
		entity.pos.set_xy(Math.fround(body.position.x), Math.fround(body.position.y));
	}

	override function ondestroy() {
		if(Main.drawer != null) Main.drawer.remove(body);
		Luxe.physics.nape.space.bodies.remove(body);
	}
}
package components;

import luxe.Input;
import luxe.Component;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Circle;

class FeatherRockPhysics extends Component {
	public var body:Body;
	public var canMoveLeft:Bool = true;
	public var canMoveRight:Bool = true;

	public function new() {
		super({ name: 'FeatherRockPhysics' });
	}

	override function init() {
		body = new Body(BodyType.DYNAMIC);
		body.shapes.add(new Circle(4));
		body.position.setxy(entity.pos.x, entity.pos.y);
		body.space = Luxe.physics.nape.space;
		body.allowRotation = false;
		body.cbTypes.add(PhysicsTypes.featherrock);

		if(Main.drawer != null) Main.drawer.add(body);
	}

	override function update(dt:Float) {
		if(Luxe.input.inputpressed('flap')) {
			body.applyImpulse(Vec2.weak(0, -TweakConfig.flapStrength));
		}

		var lrAxis:Float = 0;
		if(canMoveLeft) {
			if(Luxe.input.inputdown('left')) lrAxis -= 1;
		}
		if(canMoveRight) {
			if(Luxe.input.inputdown('right')) lrAxis += 1;
		}
		if(Math.abs(lrAxis) > 0.1) body.velocity.x = lrAxis * TweakConfig.moveSpeed;

		entity.pos.set_xy(Math.fround(body.position.x), Math.fround(body.position.y));
	}
}
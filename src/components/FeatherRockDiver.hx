package components;

import components.FeatherRockPhysics;
import luxe.Component;
import luxe.Vector;
import luxe.Input;
import nape.geom.Vec2;

class FeatherRockDiver extends Component {
	public var dragging(default, null):Bool = false;
	public var start(default, null):Vector = new Vector();
	public var end(default, null):Vector = new Vector();
	var physics:FeatherRockPhysics;
	var groundDetector:components.GroundDetector;

	public function new() {
		super({ name: 'FeatherRockDiver' });
	}

	override function init() {
		physics = cast entity.get('FeatherRockPhysics');
		groundDetector = cast entity.get('GroundDetector');
	}

	override function onmousedown(e:MouseEvent) {
		dragging = true;
		start = Luxe.camera.screen_point_to_world(e.pos);
	}

	override function onmousemove(e:MouseEvent) {
		if(dragging) end = Luxe.camera.screen_point_to_world(e.pos);
	}

	override function onmouseup(e:MouseEvent) {
		end = Luxe.camera.screen_point_to_world(e.pos);
		if(!groundDetector.onGround && start.y >= end.y) {
			var impulse:Vec2 = Vec2.weak(start.x - end.x, start.y - end.y);
			impulse.length = TweakConfig.diveStrength;
			physics.body.applyImpulse(impulse);	
		}
		dragging = false;
	}
} 
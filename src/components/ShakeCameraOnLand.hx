package components;

import luxe.Component;
import luxe.Vector;

class ShakeCameraOnLand extends Component {
	var physics:components.FeatherRockPhysics;
	var lastVelocity:Float = 0;

	public function new() {
		super({ name: 'ShakeCameraOnLand' });
	}

	override function init() {
		var gd:GroundDetector = cast entity.get('GroundDetector');
		gd.addLandedListener(onLanded);

		physics = cast entity.get('FeatherRockPhysics');
	}

	function onLanded() {
		if(lastVelocity >= 1000) Luxe.camera.shake(4);
	}

	override function update(dt:Float) {
		lastVelocity = physics.body.velocity.length;
	}
}
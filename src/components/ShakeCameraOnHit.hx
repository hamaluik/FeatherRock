package components;

import luxe.Component;
import luxe.Vector;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.callbacks.OptionType;

class ShakeCameraOnHit extends Component {
	var physics:components.FeatherRockPhysics;
	var lastVelocity:Float = 0;
	var hitListener:InteractionListener;

	public function new() {
		super({ name: 'ShakeCameraOnHit' });
	}

	override function init() {
		physics = cast entity.get('FeatherRockPhysics');

		hitListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, [PhysicsTypes.breakable, PhysicsTypes.ground], PhysicsTypes.featherrock, onHit);
		Luxe.physics.nape.space.listeners.add(hitListener);
	}

	function onHit(cb:InteractionCallback) {
		if(lastVelocity >= TweakConfig.screenShakeVelocity) Luxe.camera.shake(4);
		trace("hit");
	}

	override function update(dt:Float) {
		lastVelocity = physics.body.velocity.length;
	}
}
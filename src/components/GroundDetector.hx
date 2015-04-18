package components;

import components.FeatherRockPhysics;
import luxe.Component;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.geom.Vec2;

class GroundDetector extends Component {
	var physics:FeatherRockPhysics;
	var startListener:InteractionListener;
	var endListener:InteractionListener;

	public var onGround:Bool = false;
	var onLandedListeners:Array<Void->Void> = new Array<Void->Void>();
	var onLeaptListeners:Array<Void->Void> = new Array<Void->Void>();

	public function new() {
		super({ name: 'GroundDetector' });
	}

	override function init() {
		physics = cast entity.get('FeatherRockPhysics');

		startListener = new InteractionListener(CbEvent.ONGOING, InteractionType.COLLISION, PhysicsTypes.ground, PhysicsTypes.featherrock, onOngoingTouchingGround);
		Luxe.physics.nape.space.listeners.add(startListener);

		startListener = new InteractionListener(CbEvent.END, InteractionType.COLLISION, PhysicsTypes.ground, PhysicsTypes.featherrock, onEndTouchingGround);
		Luxe.physics.nape.space.listeners.add(startListener);
	}

	function onOngoingTouchingGround(cb:InteractionCallback) {
		for(arbiter in cb.arbiters) {
			if(arbiter.isCollisionArbiter()) {
				var wasOnGround:Bool = onGround;
				var normal:Vec2 = arbiter.collisionArbiter.normal;
				if(normal.x > 0.1) {
					physics.canMoveLeft = false;
				}
				else if(normal.x < -0.1) {
					physics.canMoveRight = false;
				}
				if(normal.y < -0.1) {
					physics.canMoveLeft = false;
					physics.canMoveRight = false;
					onGround = true;
				}

				if(!wasOnGround && onGround) {
					for(listener in onLandedListeners) {
						listener();
					}
				}
			}
		}
	}

	function onEndTouchingGround(cb:InteractionCallback) {
		onGround = false;
		physics.canMoveLeft = true;
		physics.canMoveRight = true;
		for(listener in onLeaptListeners) {
			listener();
		}
	}

	public function addLandedListener(listener:Void->Void) {
		onLandedListeners.push(listener);
	}

	public function addLeaptListener(listener:Void->Void) {
		onLeaptListeners.push(listener);
	}
}
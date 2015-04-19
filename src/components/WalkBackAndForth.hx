package components;

import luxe.Component;
import luxe.Sprite;
import luxe.components.sprite.SpriteAnimation;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.callbacks.OptionType;

class WalkBackAndForth extends Component {
	var sprite:Sprite;
	var body:Body;
	var animator:SpriteAnimation;
	var walkSpeed:Float;
	var direction:Float = 1;
	var hitListener:InteractionListener;

	public function new(walkSpeed:Float) {
		super({ name: 'WalkBackAndForth' });
		this.walkSpeed = walkSpeed;
	}

	override function init() {
		sprite = cast entity;

		if(entity.has('Destructible')) {
			var d:Destructible = cast entity.get('Destructible');
			body = d.body;
		}
		if(body == null) {
			throw "Body in walk back and forth is null!";
		}

		body.allowRotation = false;
		body.cbTypes.add(PhysicsTypes.actor);

		hitListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, [PhysicsTypes.destructible, PhysicsTypes.ground], PhysicsTypes.actor, onHit);
		Luxe.physics.nape.space.listeners.add(hitListener);

		animator = cast entity.get('SpriteAnimation');
	}

	function onHit(cb:InteractionCallback) {
		for(arbiter in cb.arbiters) {
			if(arbiter.isCollisionArbiter()) {
				var normal:Vec2 = arbiter.collisionArbiter.normal;
				if(Math.abs(normal.y) < 0.5) {
					direction *= -1;
					sprite.flipx = direction < 0;
				}
			}
		}
	}

	override function update(dt:Float) {
		body.velocity.x = walkSpeed * direction;
		entity.pos.set_xy(body.position.x, body.position.y);
	}

	override function ondestroy() {
		Luxe.physics.nape.space.listeners.remove(hitListener);
	}
}
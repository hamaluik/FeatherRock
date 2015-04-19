package components;

import luxe.Component;
import luxe.Particles;
import luxe.Vector;
import luxe.Color;
import motion.Actuate;
import phoenix.Batcher;

class GiveMagicOnDestroy extends Component {
	var amount:Float;
	var hudBatcher:Batcher;

	public function new(amount:Float, hudBatcher:Batcher) {
		super({ name: 'GiveMagicOnDestroy' });
		this.amount = amount;
		this.hudBatcher = hudBatcher;
	}

	override function ondestroy() {
		//Main.playerData.magic += amount;
		var particles:ParticleSystem = new ParticleSystem({ name: 'particles', name_unique: true });
		particles.add_emitter({
			name: 'soul emitter',
			emit_time: 0.01,
			emit_count: 5,
			direction_random: 360,
			speed: 3,
			life: 1,
			gravity: new Vector(0, 0),
			pos_offset: new Vector(),
			pos_random: new Vector(),
			start_size: new Vector(2, 2),
			start_size_random: new Vector(0, 0),
			end_size: new Vector(2, 2),
			end_size_random: new Vector(0, 0),
			start_color: new Color(1, 1, 1, 1),
			end_color: new Color(0, 0.5, 0.19196, 0),
			//batcher: hudBatcher,
			depth: 100
		});
		particles.pos = entity.pos;//Luxe.camera.world_point_to_screen(entity.pos);
		Actuate.tween(particles.pos, 2, { x: entity.pos.x, y: entity.pos.y - 256}).ease(motion.easing.Cubic.easeOut).onComplete(function() {
			Main.playerData.magic += amount;
			particles.destroy();
		});
	}
}
package components;

import luxe.Component;
import luxe.Particles;
import luxe.Vector;
import luxe.Color;
import motion.Actuate;
import luxe.Entity;
import luxe.utils.Maths;

class GiveMagicOnDestroy extends Component {
	var amount:Float;
	var featherRock:Entity;
	var particles:ParticleSystem;
	var startPos:Vector;

	public function new(amount:Float, featherRock:Entity) {
		super({ name: 'GiveMagicOnDestroy' });
		this.amount = amount;
		this.featherRock = featherRock;
	}

	override function ondestroy() {
		//Main.playerData.magic += amount;
		particles = new ParticleSystem({ name: 'particles', name_unique: true });
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
			depth: 100
		});
		particles.pos = entity.pos;//Luxe.camera.world_point_to_screen(entity.pos);
		startPos = featherRock.pos.clone();
		/*Actuate.tween(particles.pos, 0.5, { x: featherRock.pos.x, y: featherRock.pos.y }).ease(motion.easing.Cubic.easeOut)*/Actuate.update(followPlayer, 0.5, [0], [1]).ease(motion.easing.Cubic.easeOut).onComplete(function() {
			Main.playerData.magic += amount;
			particles.destroy();
			Main.musicManager.play("soul");
		});
	}

	function followPlayer(_t:Float) {
		particles.pos = new Vector(Maths.lerp(startPos.x, featherRock.pos.x, _t), Maths.lerp(startPos.y, featherRock.pos.y, _t));
	}
}
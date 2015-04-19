package components;

import luxe.Component;
import luxe.Particles;
import luxe.Vector;
import luxe.Color;
import motion.Actuate;
import luxe.Entity;
import luxe.utils.Maths;

import states.Play.CollectibleType;

class GiveOnDestroy extends Component {
	var amount:Float;
	var featherRock:Entity;
	var particles:ParticleSystem;
	var startPos:Vector;

	var type:CollectibleType;

	var startColor:Color;
	var endColor:Color;

	public function new(type:CollectibleType, amount:Float, featherRock:Entity) {
		super({ name: 'GiveOnDestroy' });
		this.amount = amount;
		this.featherRock = featherRock;
		this.type = type;

		switch(type) {
			case magic: endColor = new Color(0.75, 0.15, 0.20, 0);
			case goblins: endColor = new Color(0.27, 0.54, 0.10, 0);
			case gold: endColor = new Color(0.49, 0.15, 0.69, 0);
		}
		startColor = endColor.clone();
		startColor.a = 1;
	}

	override function ondestroy() {
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
			start_color: startColor,
			end_color: endColor,
			depth: 100,
			group: 5,
		});
		particles.pos = entity.pos;
		startPos = featherRock.pos.clone();
		Actuate.update(followPlayer, 0.5, [0], [1]).onComplete(function() {
			switch(type) {
				case magic: Main.playerData.magic += amount;
				case goblins: Main.playerData.goblins += amount;
				case gold: Main.playerData.gold += amount;
			}
			particles.destroy();
			Main.musicManager.play("soul");
		});
	}

	function followPlayer(_t:Float) {
		particles.pos = new Vector(Maths.lerp(startPos.x, featherRock.pos.x, _t), Maths.lerp(startPos.y, featherRock.pos.y, _t));
	}
}
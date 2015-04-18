package components;

import luxe.Component;
import luxe.Vector;
import luxe.Color;
import luxe.Particles;

class OneShotParticlesOnDestroy extends Component {
	var particleColor:Color = new Color().rgb(0xffffff);

	public function new(?color:Color) {
		super({ name: 'OneShotParticlesOnDestroy' });
		if(color != null) particleColor = color;
	}

	override function ondestroy() {
		var particles:ParticleSystem = new ParticleSystem({ name: 'particles', name_unique: true });
		particles.add_emitter({
			name: 'derp',
			emit_time: 10,
			emit_count: 10,
			direction_random: 360,
			speed: 10,
			life: 0.3,
			start_size: new Vector(4, 4),
			start_size_random: new Vector(0, 0),
			end_size: new Vector(4, 4),
			end_size_random: new Vector(0, 0),
			start_color: particleColor,
			end_color: particleColor
		});
		particles.pos = entity.pos;

		Luxe.timer.schedule(1, function() { particles.destroy(); }, false);
	}
} 
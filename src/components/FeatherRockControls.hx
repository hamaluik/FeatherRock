package components;

import components.FeatherRockControls;
import luxe.Component;
import nape.phys.Body;
import nape.geom.Vec2;

class FeatherRockControls extends Component {
	var physics:FeatherRockPhysics;

	public function new() {
		super({ name: 'FeatherRockControls' });
	}

	override function init() {
		physics = cast entity.get('FeatherRockPhysics');
	}

	override function update(dt:Float) {
		if(Luxe.input.inputpressed('flap')) {
			physics.body.applyImpulse(Vec2.weak(0, -TweakConfig.flapStrength));
			Main.musicManager.play("flap");
		}

		var lrAxis:Float = 0;
		if(physics.canMoveLeft) {
			if(Luxe.input.inputdown('left')) lrAxis -= 1;
		}
		if(physics.canMoveRight) {
			if(Luxe.input.inputdown('right')) lrAxis += 1;
		}
		if(Math.abs(lrAxis) > 0.1) physics.body.velocity.x = lrAxis * TweakConfig.moveSpeed;
	}
} 
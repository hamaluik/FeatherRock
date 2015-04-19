package effects;

import luxe.utils.Maths;
import luxe.Visual;
import luxe.Color;
import phoenix.Batcher;
import phoenix.Shader;
import luxe.Vector;
import phoenix.RenderTexture;

import effects.Effect;

class CircleTransitionEffect extends Effect {
	var shader:Shader;

	var transitionTime:Float = 2;

	var distance:Float = 0;
	var maxDistance:Float = 1;

	public var transition(get, set):Float;

	public function get_transition():Float {
		return distance / maxDistance;
	}

	public function set_transition(_t:Float):Float {
		_t = Maths.clamp(_t, 0, 1);
		distance = _t * maxDistance;
		if(shader != null) {
			shader.set_float('circleDistance', distance);
		}
		return _t;
	}

	public function new(?transitionTime:Float) {
		super('CircleTransitionEffect');
	}

	override public function onload() {
		// load the shader
		shader = Luxe.resources.find_shader('assets/shaders/circleout.glsl|default');
		maxDistance = new Vector(Luxe.screen.w / 2, Luxe.screen.h / 2).length;
		distance = maxDistance;
		shader.set_float('circleDistance', 0);
		shader.set_vector2('resolutionCenter', new Vector(Luxe.screen.w / 2, Luxe.screen.h / 2));

		setupVisuals();
		outputVisual.shader = shader;

		transition = 0;
	}
}
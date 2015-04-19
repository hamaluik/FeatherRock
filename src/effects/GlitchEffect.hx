package effects;

import luxe.Visual;
import luxe.Color;
import phoenix.Batcher;
import phoenix.Shader;
import luxe.Vector;
import phoenix.RenderTexture;

import effects.Effect;

typedef GlitchEffectOptions = {
	@:optional var glitchAmount:Float;
	@:optional var glitchLength:Float;
	@:optional var scanlineFrequency:Float;
	@:optional var scanlineSpeed:Float;
	@:optional var minTimeBetweenGlitches:Float;
	@:optional var maxTimeBetweenGlitches:Float;
}

class GlitchEffect extends Effect {
	var scanlineShader:Shader;

	public var glitchAmount:Float = 5;
	public var glitchLength:Float = 0.1;
	public var scanlineFrequency:Float = 1.5;
	public var scanlineSpeed:Float = 2;
	public var minTimeBetweenGlitches:Float = 0.1;
	public var maxTimeBetweenGlitches:Float = 5;

	var glitchTime:Float = 0;
	var nextGlitch:Float = 0;
	var glitching:Bool = false;

	var scanlineTime:Float = 0;

	public function new(?options:GlitchEffectOptions) {
		super('glitch');

		if(options != null) {
			if(options.glitchAmount != null) glitchAmount = options.glitchAmount;
			if(options.glitchLength != null) glitchLength = options.glitchLength;
			if(options.scanlineFrequency != null) scanlineFrequency = options.scanlineFrequency;
			if(options.scanlineSpeed != null) scanlineSpeed = options.scanlineSpeed;
			if(options.minTimeBetweenGlitches != null) minTimeBetweenGlitches = options.minTimeBetweenGlitches;
			if(options.maxTimeBetweenGlitches != null) maxTimeBetweenGlitches = options.maxTimeBetweenGlitches;
		}
	}

	override public function onload() {
		// load the shader
		scanlineShader = Luxe.resources.find_shader('assets/shaders/glitch.glsl|default');
		scanlineShader.set_float('glitchAmount', 0);
		scanlineShader.set_float('frequency', scanlineFrequency);
		scanlineShader.set_float('time', 0);
		scanlineShader.set_vector2('resolution', new Vector(Luxe.screen.w, Luxe.screen.h));
		nextGlitch = Luxe.utils.random.float(minTimeBetweenGlitches, maxTimeBetweenGlitches);

		setupVisuals();
		outputVisual.shader = scanlineShader;
	}

	override public function update(dt:Float) {
		scanlineTime += dt * scanlineSpeed;
		scanlineShader.set_float('time', scanlineTime);

		if(glitching) {
			glitchTime += dt;
			if(glitchTime >= glitchLength) {
				glitching = false;
				nextGlitch = Luxe.utils.random.float(minTimeBetweenGlitches, maxTimeBetweenGlitches);
				scanlineShader.set_float('glitchAmount', 0);
			}
		}
		else {
			nextGlitch -= dt;
			if(nextGlitch <= 0) {
				glitching = true;
				glitchTime = 0;
				scanlineShader.set_float('glitchAmount', glitchAmount);
			}
		}
	}

	/*override public function apply(preTexture:RenderTexture, postTexture:RenderTexture) {
		Luxe.renderer.target = postTexture;
		Luxe.renderer.clear(new Color(0, 0, 0, 0));
		outputVisual.texture = preTexture;
		outputBatcher.draw();
	}*/
}
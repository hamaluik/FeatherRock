package effects;

import luxe.Visual;
import luxe.Color;
import phoenix.Batcher;
import phoenix.Shader;
import luxe.Vector;
import phoenix.RenderTexture;

import effects.Effect;

class BloomEffect extends Effect {
	var bloomBrightShader:Shader;
	var bloomBlurShader:Shader;

	var brightBatcher:Batcher;
	var postBrightTexture:RenderTexture;
	var brightVisual:Visual;

	var horizBlurBatcher:Batcher;
	var postHorizBlurTexture:RenderTexture;
	var horizBlurVisual:Visual;

	var vertBlurBatcher:Batcher;
	var vertBlurVisual:Visual;

	@:isVar public var threshold(default, set):Float;
	@:isVar public var radius(default, set):Float;

	function set_threshold(_t:Float) {
		if(bloomBrightShader != null) {
			bloomBrightShader.set_float('brightPassThreshold', _t);
		}
		return threshold = _t;
	}

	function set_radius(_r:Float) {
		if(bloomBlurShader != null) {
			bloomBlurShader.set_float('blur', _r / Effects.screenTextureSize);
		}
		return radius = _r;
	}

	public function new() {
		super('bloom');
	}

	override public function onload() {
		// BEGIN SHADERS
		bloomBrightShader = Luxe.resources.find_shader('assets/shaders/isolate_bright.glsl|default');
		bloomBrightShader.set_float('brightPassThreshold', 0.5);

		bloomBlurShader = Luxe.resources.find_shader('assets/shaders/blur.glsl|default');
		bloomBlurShader.set_float('blur', 1 / Effects.screenTextureSize);
		bloomBlurShader.set_vector2('dir', new Vector(1, 0));
		// END SHADERS

		// BEGIN BRIGHTNESS CLAMPER
		brightBatcher = Luxe.renderer.create_batcher({
			name: 'batcher.effect.bloom.bright',
			no_add: true
		});
		brightBatcher.view.viewport = Luxe.camera.viewport;

		brightVisual = new Visual({
			pos: new Vector(),
			size: new Vector(Effects.screenTextureSize, Effects.screenTextureSize),
			batcher: brightBatcher,
			shader: bloomBrightShader
		});

		postBrightTexture = new RenderTexture(Luxe.resources, new Vector(Effects.screenTextureSize, Effects.screenTextureSize));
		// END BRIGHTNESS CLAMPER

		// BEGIN HORIZONTAL BLUR
		horizBlurBatcher = Luxe.renderer.create_batcher({
			name: 'batcher.effect.bloom.hblur',
			no_add: true
		});
		horizBlurBatcher.view.viewport = Luxe.camera.viewport;

		horizBlurVisual = new Visual({
			texture: postBrightTexture,
			pos: new Vector(),
			size: new Vector(Effects.screenTextureSize, Effects.screenTextureSize),
			batcher: horizBlurBatcher,
			shader: bloomBlurShader
		});

		postHorizBlurTexture = new RenderTexture(Luxe.resources, new Vector(Effects.screenTextureSize, Effects.screenTextureSize));
		// END HORIZONTAL BLUR

		// BEGIN VERTICAL BLUR
		vertBlurBatcher = Luxe.renderer.create_batcher({
			name: 'batcher.effect.bloom.vblur',
			no_add: true
		});
		vertBlurBatcher.view.viewport = Luxe.camera.viewport;

		vertBlurVisual = new Visual({
			texture: postHorizBlurTexture,
			pos: new Vector(),
			size: new Vector(Effects.screenTextureSize, Effects.screenTextureSize),
			batcher: vertBlurBatcher,
			shader: bloomBlurShader
		});
		// END VERTICAL BLUR

		setupVisuals();

		// set the default uniform values
		radius = 2;
		threshold = 0.5;
	}

	override public function apply(preTexture:RenderTexture, postTexture:RenderTexture) {
		// brightness pass
		Luxe.renderer.target = postBrightTexture;
		Luxe.renderer.clear(clearColour);
		brightVisual.texture = preTexture;
		brightBatcher.draw();

		// hblur pass
		Luxe.renderer.target = postHorizBlurTexture;
		Luxe.renderer.clear(clearColour);
		// set the blur direction for the shader
		bloomBlurShader.set_vector2('dir', new Vector(1, 0));
		horizBlurBatcher.draw();

		// draw the incoming texture normally
		Luxe.renderer.target = postTexture;
		Luxe.renderer.clear(clearColour);
		outputVisual.texture = preTexture;
		outputBatcher.draw();

		// additive blend the final effect
		Luxe.renderer.blend_mode(BlendMode.src_alpha, BlendMode.one);

		// set the blur shader that this is using to blur in the vertical direction
		// so that we get a nice 2D gaussian blur
		bloomBlurShader.set_vector2('dir', new Vector(0, 1));
		vertBlurBatcher.draw();

		// return to default blending
		Luxe.renderer.blend_mode();
	}
}
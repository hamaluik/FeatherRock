package effects;

import luxe.Color;
import luxe.Vector;
import luxe.Visual;

import phoenix.RenderTexture;
import phoenix.Batcher;
import phoenix.geometry.QuadGeometry;

class Effect {
	public var name(default, null):String;
	private var clearColour:Color = new Color(0, 0, 0, 0);
	private var outputBatcher:Batcher;
	private var outputVisual:Visual;

	public function new(name:String) {
		this.name = name;
	}

	public function onload() {
		setupVisuals();
	}

	private function setupVisuals() {
		outputBatcher = Luxe.renderer.create_batcher({
			name: 'batcher.effect.' + name,
			no_add: true
		});
		outputBatcher.view.viewport = Luxe.camera.viewport;

		outputVisual = new Visual({
			pos: new Vector(),
			size: new Vector(Effects.screenTextureSize, Effects.screenTextureSize),
			batcher: outputBatcher,
		});
	}

	public function update(dt:Float) {}

	public function apply(preTexture:RenderTexture, postTexture:RenderTexture) {
		Luxe.renderer.target = postTexture;
		Luxe.renderer.clear(clearColour);
		outputVisual.texture = preTexture;
		outputBatcher.draw();
	}
}
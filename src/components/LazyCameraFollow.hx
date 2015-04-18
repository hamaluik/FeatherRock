package components;

import luxe.Component;
import luxe.utils.Maths;
import luxe.Vector;

class LazyCameraFollow extends Component {
	public var ratio:Float;

	public function new() {
		super({ name: 'LazyCameraFollow' });

		ratio = TweakConfig.cameraFollowRatio;
	}

	override function update(dt:Float) {
		Luxe.camera.center = new Vector(Maths.lerp(Luxe.camera.center.x, entity.pos.x, ratio), Maths.lerp(Luxe.camera.center.y, entity.pos.y, ratio));
		Main.snapCamera();
	}
}
package components;

import luxe.Component;
import luxe.Input;

class MouseBulletTime extends Component {
	public function new() {
		super({ name: 'MouseBulletTime' });
	}

	override function init() {

	}

	override function onmousedown(e:MouseEvent) {
		Luxe.timescale = TweakConfig.bulletTimeRatio;
	}

	override function onmouseup(e:MouseEvent) {
		Luxe.timescale = 1;
	}
}
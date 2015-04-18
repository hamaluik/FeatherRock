package components;

import components.GroundDetector;
import luxe.Component;
import luxe.components.sprite.SpriteAnimation;

class FeatherRockAnimator extends Component {
	var groundDetector:GroundDetector;
	var animator:SpriteAnimation;

	public function new() {
		super({ name: 'FeatherRockAnimator' });
	}

	override function init() {
		groundDetector = entity.get('GroundDetector');
		animator = entity.get('SpriteAnimation');

		groundDetector.addLandedListener(onLanded);
		groundDetector.addLeaptListener(onLeapt);
	}

	function onLanded() {
		animator.animation = "ground idle";
		animator.play();
	}

	function onLeapt() {
		animator.animation = "flying idle";
		animator.play();
	}
}
package components;

import luxe.Component;

class LoseMagicOverTime extends Component {
	public var drainSpeed:Float;
	var onDrained:Void->Void;

	public function new(drainSpeed:Float, onDrained:Void->Void) {
		super({ name: 'LoseMagicOverTime' });
		this.drainSpeed = drainSpeed;
	}

	override function update(dt:Float) {
		Main.playerData.magic -= dt * drainSpeed;
		if(Main.playerData.magic <= 0) {
			Main.playerData.magic = 0;
			onDrained();
		}
	}
} 
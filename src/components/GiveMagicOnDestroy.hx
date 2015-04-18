package components;

import luxe.Component;

class GiveMagicOnDestroy extends Component {
	var amount:Float;

	public function new(amount:Float) {
		super({ name: 'GiveMagicOnDestroy' });
		this.amount = amount;
	}

	override function ondestroy() {
		Main.playerData.magic += amount;
	}
}
package components;

import luxe.Component;
import luxe.Text;

class MagicDisplay extends Component {
	var text:Text;

	public function new(text:Text) {
		super({ name: 'MagicDisplay' });
		this.text = text;
	}

	override function update(dt:Float) {
		text.text = "Magic: " + Main.playerData.magic;
	}
} 
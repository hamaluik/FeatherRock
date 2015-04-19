package components;

import luxe.Component;
import luxe.Text;

import states.Play.CollectibleType;

using NumberFormat;

class PlayerDataTextDisplay extends Component {
	var text:Text;
	var type:CollectibleType;

	public function new(type:CollectibleType, text:Text) {
		super({ name: 'PlayerDataTextDisplay' });
		this.type = type;
		this.text = text;
	}

	override function update(dt:Float) {
		switch(type) {
			case CollectibleType.magic: text.text = "Magic: " + Main.playerData.magic.toFixed(0);
			case CollectibleType.goblins: text.text = "Goblins: " + Main.playerData.goblins.toFixed(0);
			case CollectibleType.gold: text.text = "Gold: " + Main.playerData.gold.toFixed(0);
		}
	}
} 
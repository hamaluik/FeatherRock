package components;

import luxe.Component;
import luxe.utils.Maths;
import luxe.Visual;

import states.Play.CollectibleType;

using NumberFormat;

class PlayerDataBarDisplay extends Component {
	var visual:Visual;
	var type:CollectibleType;

	public function new(type:CollectibleType, visual:Visual) {
		super({ name: 'PlayerDataBarDisplay' });
		this.type = type;
		this.visual = visual;
	}

	override function update(dt:Float) {
		switch(type) {
			case CollectibleType.magic: visual.size.x = Maths.clamp(Main.playerData.magic / TweakConfig.maxMagicBarSize, 0, 1) * 100;
			case CollectibleType.goblins: visual.size.x = Maths.clamp(Main.playerData.goblins / TweakConfig.maxGoblinBarSize, 0, 1) * 100;
			case CollectibleType.gold: visual.size.x = Maths.clamp(Main.playerData.gold / TweakConfig.maxGoldBarSize, 0, 1) * 100;
		}
	}
} 
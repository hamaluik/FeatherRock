package components;

import luxe.Component;

class PlaySoundOnDestroyed extends Component {
	var soundName:String;
	var destructible:Destructible;

	public function new(soundName:String) {
		super({ name: 'PlaySoundOnDestroyed' });
		this.soundName = soundName;
	}

	override function init() {
		destructible = cast entity.get('Destructible');
		destructible.addOnDestructionListener(onDestroyed);
	}

	override function ondestroy() {
		destructible.removeOnDestructionListener(ondestroy);
	}

	function onDestroyed() {
		Main.musicManager.play(soundName);
	}
} 
package components;

import luxe.Component;
import luxe.Vector;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.callbacks.OptionType;

class PlaySoundOnHit extends Component {
	var hitListener:InteractionListener;

	var sound:String;
	var hitTypes:Array<nape.callbacks.CbType>;

	public function new(sound:String, hitTypes:Array<nape.callbacks.CbType>) {
		super({ name: 'PlaySoundOnHit' });
		this.sound = sound;
		this.hitTypes = hitTypes;
	}

	override function init() {
		hitListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, hitTypes, PhysicsTypes.featherrock, onHit);
		Luxe.physics.nape.space.listeners.add(hitListener);
	}

	function onHit(cb:InteractionCallback) {
		Main.musicManager.play(sound);
	}

	override function ondestroy() {
		Luxe.physics.nape.space.listeners.remove(hitListener);
	}
}
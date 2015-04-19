import haxe.ds.StringMap;

typedef Sound = {
	var name:String;
	var id:String;
	var playing:Bool;
	var loaded:Bool;
	var isMusic:Bool;
}

class MusicManager {
	var sounds:StringMap<Sound> = new StringMap<Sound>();

	public function new() {
	}

	public function onload() {
		/*for(id in Luxe.resources.sounds.keys()) {
			var name:String = Luxe.resources.sounds.get(id).name;
			sounds.set(name, {
				name: name,
				id: id,
				playing: false,
				loaded: false,
				isMusic: false
			});
			Luxe.audio.create(id, name).then(
				function(_) {
					sounds.get(name).loaded = true;
					//if(sounds.get(name).playing) play(name);
				},
				function(reason) {
					trace("Failed to load sound '" + name + "'! Reason: " + reason);
				}
			);
		}

		trace("Sounds: ");
		trace(sounds);*/
	}

	public function play(name:String) {
		/*if(!sounds.exists(name)) {
			trace("Sound " + name + " doesn't exist yet!");
			return;
		}

		if(!sounds.get(name).loaded) {
			sounds.get(name).playing = true;
			trace("Sound " + name + " needs to load first!");
			return;
		}

		if(sounds.get(name).isMusic) {
			for(sound in sounds.iterator()) {
				if(sound.name != name && sound.isMusic && sound.playing) {
					Luxe.audio.stop(sound.name);
					sound.playing = false;
					trace("Stopped music " + sound.name);
				}
			}
			Luxe.audio.loop(name);
			sounds.get(name).playing = true;
			trace("Looping music " + name);
		}
		else {
			Luxe.audio.play(name);
			trace("Playing one-shot " + name);
		}*/
	}
}
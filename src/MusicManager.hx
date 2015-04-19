import haxe.ds.StringMap;

typedef Sound = {
	var name:String;
	var playing:Bool;
	var isMusic:Bool;
}

class MusicManager {
	var sounds:StringMap<Sound> = new StringMap<Sound>();

	public function new() {
	}

	public function onload() {
		for(sound in Luxe.resources.sounds.iterator()) {
			sounds.set(sound.name, {
				name: sound.name,
				playing: false,
				isMusic: sound.name == "theme"
			});
		}
	}

	public function loop(name:String) {
		if(sounds.get(name).playing) return;
		Luxe.audio.loop(name);
		sounds.get(name).playing = true;
	}

	public function stop(name:String) {
		if(!sounds.get(name).playing) return;
		Luxe.audio.stop(name);
		sounds.get(name).playing = false;
	}

	public function play(name:String) {
		Luxe.audio.play(name);
	}
}
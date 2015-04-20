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
		Luxe.audio.volume(name, 0.05);
	}

	public function stop(name:String) {
		if(!sounds.get(name).playing) return;
		Luxe.audio.stop(name);
		sounds.get(name).playing = false;
	}

	public function play(name:String) {
		trace("Playing sound: " + name);
		Luxe.audio.play(name);
	}

	public function setMute(mute:Bool) {
		for(sound in sounds.iterator()) {
			if(sound.playing) {
				Luxe.audio.volume(sound.name, mute ? 0 : 0.05);
			}
		}
	}
}
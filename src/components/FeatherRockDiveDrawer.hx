package components;

import luxe.Color;
import luxe.Component;
import luxe.Sprite;
import phoenix.Texture;
import luxe.Vector;
import luxe.Input;

class FeatherRockDiveDrawer extends Component {
	var diver:components.FeatherRockDiver;
	var sprites:Array<Sprite> = new Array<Sprite>();
	var ringPos:Vector = new Vector();
	var length:Vector = new Vector();

	var normalColour:Color = new Color(1, 1, 1, 1);
	var errorColour:Color = new Color(1, 0, 0, 0.5);

	public function new() {
		super({ name: 'FeatherRockDiveDrawer' });
	}

	override function init() {
		diver = cast entity.get('FeatherRockDiver');
		var texture:Texture = Luxe.resources.find_texture("assets/sprites/ring.png");
		texture.filter = FilterType.nearest;

		for(i in 0...4) {
			var sprite:Sprite = new Sprite({
				size: new Vector(i + 5, i + 5),
				texture: texture,
				pos: new Vector()
			});
			sprite.visible = false;

			sprites.push(sprite);
		}
	}

	override function update(dt:Float) {
		if(diver.dragging) {
			ringPos.set_xy(diver.start.x, diver.start.y);
			length.set_xy(diver.end.x - ringPos.x, diver.end.y - ringPos.y);
			for(sprite in sprites) {
				sprite.visible = true;
				sprite.pos.set_xy(ringPos.x, ringPos.y);
				ringPos.add_xyz(length.x / 3, length.y / 3);

				if(diver.start.y < diver.end.y) {
					sprite.color = errorColour;
				}
				else {
					sprite.color = normalColour;
				}
			}
		}
		else {
			for(sprite in sprites) {
				sprite.visible = false;
			}
		}
	}

	override function ondestroy() {
		for(sprite in sprites) {
			sprite.destroy();
		}
	}
} 
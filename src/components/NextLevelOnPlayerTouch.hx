package components;

import luxe.Component;
import luxe.Rectangle;
import nape.phys.Body;

class NextLevelOnPlayerTouch extends Component {
	var rect:Rectangle;
	var body:Body;

	public function new(rect:Rectangle) {
		super({ name: 'NextLevelOnPlayerTouch' });
		this.rect = rect;
	}

	override function init() {
		body = new Body(BodyType);
		var spr:luxe.Sprite = cast entity;
		body.shapes.add(new Polygon(Polygon.box(spr.size.x, spr.size.y)));
		body.position.setxy(entity.pos.x, entity.pos.y);
		body.space = Luxe.physics.nape.space;
		body.cbTypes.add(PhysicsTypes.destructible);

		if(Main.drawer != null) Main.drawer.add(body);
	}
} 
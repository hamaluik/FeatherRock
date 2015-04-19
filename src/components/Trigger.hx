package components;

import luxe.Component;
import luxe.Rectangle;
import nape.phys.Body;
import nape.shape.Polygon;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.callbacks.OptionType;
import nape.phys.BodyType;

class Trigger extends Component {
	var rect:Rectangle;
	var body:Body;
	var hitListener:InteractionListener;
	var onTouched:Void->Void;

	public function new(rect:Rectangle, onTouched:Void->Void) {
		super({ name: 'Trigger' });
		this.rect = rect;
		this.onTouched = onTouched;
	}

	override function init() {
		body = new Body(BodyType.STATIC);
		var shape:Polygon = new Polygon(Polygon.box(rect.w, rect.h));
		shape.sensorEnabled = true;

		body.shapes.add(shape);
		body.position.setxy(rect.x + rect.w / 2, rect.y + rect.h / 2);
		body.space = Luxe.physics.nape.space;
		body.cbTypes.add(PhysicsTypes.trigger);

		if(Main.drawer != null) Main.drawer.add(body);

		hitListener = new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, PhysicsTypes.trigger, PhysicsTypes.featherrock, onFeatherRockTouch);
		Luxe.physics.nape.space.listeners.add(hitListener);
	}

	function onFeatherRockTouch(cb:InteractionCallback) {
		if(cb.int1.castBody.id == body.id) {
			onTouched();
		}
	}

	override function ondestroy() {
		if(Main.drawer != null) Main.drawer.remove(body);
		Luxe.physics.nape.space.bodies.remove(body);
		Luxe.physics.nape.space.listeners.remove(hitListener);
	}
} 
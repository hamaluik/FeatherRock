class TweakConfig {
	public static var flapStrength(default, null):Float = 10;
	public static var moveSpeed(default, null):Float = 100;
	public static var diveStrength(default, null):Float = 100;
	public static var bulletTimeRatio(default, null):Float = 0.05;
	public static var cameraFollowRatio(default, null):Float = 0.1;

	public static function load(json) {
		if(json.flapStrength != null) flapStrength = json.flapStrength;
		if(json.moveSpeed != null) moveSpeed = json.moveSpeed;
		if(json.diveStrength != null) diveStrength = json.diveStrength;
		if(json.bulletTimeRatio != null) bulletTimeRatio = json.bulletTimeRatio;
		if(json.cameraFollowRatio != null) cameraFollowRatio = json.cameraFollowRatio;
	}
}
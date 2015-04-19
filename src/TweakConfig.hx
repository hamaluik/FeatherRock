class TweakConfig {
	public static var flapStrength(default, null):Float = 10;
	public static var moveSpeed(default, null):Float = 100;
	public static var diveStrength(default, null):Float = 100;
	public static var bulletTimeRatio(default, null):Float = 0.05;
	public static var cameraFollowRatio(default, null):Float = 0.1;
	public static var blockBreakVelocity(default, null):Float = 1000;
	public static var screenShakeVelocity(default, null):Float = 1000;
	public static var screenShakeAmount(default, null):Float = 4;
	public static var bloomTheshold(default, null):Float = 0.75;
	public static var rockElasticity(default, null):Float = 0.2;
	public static var startMagic(default, null):Float = 100;
	public static var magicDrainSpeed(default, null):Float = 1;
	public static var destructionFreezeTime(default, null):Float = 0.1;
	public static var elfMagic(default, null):Float = 10;
	public static var elfWalkSpeed(default, null):Float = 32;

	public static function load(json) {
		if(json.flapStrength != null) flapStrength = json.flapStrength;
		if(json.moveSpeed != null) moveSpeed = json.moveSpeed;
		if(json.diveStrength != null) diveStrength = json.diveStrength;
		if(json.bulletTimeRatio != null) bulletTimeRatio = json.bulletTimeRatio;
		if(json.cameraFollowRatio != null) cameraFollowRatio = json.cameraFollowRatio;
		if(json.blockBreakVelocity != null) blockBreakVelocity = json.blockBreakVelocity;
		if(json.screenShakeVelocity != null) screenShakeVelocity = json.screenShakeVelocity;
		if(json.screenShakeAmount != null) screenShakeAmount = json.screenShakeAmount;
		if(json.bloomTheshold != null) bloomTheshold = json.bloomTheshold;
		if(json.rockElasticity != null) rockElasticity = json.rockElasticity;
		if(json.startMagic != null) startMagic = json.startMagic;
		if(json.magicDrainSpeed != null) magicDrainSpeed = json.magicDrainSpeed;
		if(json.destructionFreezeTime != null) destructionFreezeTime = json.destructionFreezeTime;
		if(json.elfMagic != null) elfMagic = json.elfMagic;
		if(json.elfWalkSpeed != null) elfWalkSpeed = json.elfWalkSpeed;
	}
}
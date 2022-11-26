package components;

/**
 * Bees are a basic enemy.
 * They are stationary, have a smaller health pool (2) and fire at pure random (every 2-4 seconds).
 */
class Bee extends BaseEnemy
{
	static final BEE_HEALTH:Float = 2.0;
	static final BEE_SHOOT_MIN:Float = 2.0;
	static final BEE_SHOOT_MAX:Float = 4.0;

	var shootTimer:Float = -1;

	public function new()
	{
		super(AssetPaths.bee__png, false, BEE_HEALTH);

		// So the bees don't shoot immediately
		incrementShootTimer();
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		shootTimer -= elapsed;

		if (shootTimer <= 0)
		{
			fireBullet();
			incrementShootTimer();
		}
	}

	function incrementShootTimer()
	{
		shootTimer = FlxG.random.float(BEE_SHOOT_MIN, BEE_SHOOT_MAX);
	}
}

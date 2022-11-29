package components;

import flixel.math.FlxPoint;
import states.PlayState;

/**
 * Hornets are a more advanced enemy.
 * They fire a projectile angled at the player's current position,
 * and move in an evasive pattern.
 */
class Hornet extends BaseEnemy
{
	static final HORNET_HEALTH:Float = 5.0;

	static final HORNET_WORTH:Int = 300;

	static final HORNET_SHOOT_DELAY:Float = 4.0;

	static final HORNET_MOVE_SIZE:Int = 50;

	var shootTimer:Float = -1;
	var horizontal:Bool;

	public var startingPosition:FlxPoint = new FlxPoint(0, 0);

	public function new(?horizontal:Bool = true)
	{
		super(AssetPaths.hornet__png, false, HORNET_HEALTH, HORNET_WORTH);

		// So the hornets don't shoot immediately
		shootTimer = FlxG.random.float(1.0, 4.0);

		// Start at a random position in the figure eight.
		totalElapsed = FlxG.random.float(0.0, 6.0);

		this.horizontal = horizontal;
	}

	var totalElapsed:Float = 0;

	public override function update(elapsed:Float)
	{
		totalElapsed += elapsed;

		// The hornet will move in a figure 8 pattern centered around the starting position.
		if (horizontal)
		{
			this.x = startingPosition.x + Math.cos(totalElapsed) * HORNET_MOVE_SIZE;
			this.y = startingPosition.y + Math.sin(totalElapsed * 2) / 2 * HORNET_MOVE_SIZE;
		}
		else
		{
			this.x = startingPosition.x + Math.sin(totalElapsed * 2) / 2 * HORNET_MOVE_SIZE;
			this.y = startingPosition.y + Math.cos(totalElapsed) * HORNET_MOVE_SIZE;
		}

		shootTimer -= elapsed;

		if (shootTimer <= 0)
		{
			var bullet:Bullet = fireBullet(false);

			// The bullet defaults to moving straight down.
			var baseVelocityX:Float = bullet.velocity.x;
			var baseVelocityY:Float = bullet.velocity.y;
			var baseVelocity:Float = Math.sqrt(baseVelocityX * baseVelocityX + baseVelocityY * baseVelocityY);

			// We want the hornet to shoot towards the player's current position.
			var playerPosition:FlxPoint = PlayState.instance.player.getPosition();
			playerPosition.x += PlayState.instance.player.width / 2;
			playerPosition.y += PlayState.instance.player.height / 2;
			var bulletPosition:FlxPoint = bullet.getPosition();

			// Change the velocity to have the same magnitude, but point towards the player.
			bullet.velocity = new FlxPoint(playerPosition.x - bulletPosition.x, playerPosition.y - bulletPosition.y);
			bullet.velocity.normalize();
			bullet.velocity.x *= baseVelocity;
			bullet.velocity.y *= baseVelocity;

			incrementShootTimer();
		}

		super.update(elapsed);
	}

	function incrementShootTimer()
	{
		shootTimer = HORNET_SHOOT_DELAY;
	}
}

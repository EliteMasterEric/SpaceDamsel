package components;

import states.PlayState;

class Bullet extends FlxSprite
{
	public var friendly(default, set):Bool;

	public var bulletSpeed(default, set):Float;

	function set_friendly(value:Bool):Bool
	{
		friendly = value;

		playBulletAnim();
		setBulletSpeed();

		return friendly;
	}

	function set_bulletSpeed(value:Float):Float
	{
		bulletSpeed = value;

		setBulletSpeed();

		return bulletSpeed;
	}

	public function new()
	{
		super(0, 0);
	}

	function playBulletAnim():Void
	{
		// Make the bullet display the correct sprite
		if (friendly)
		{
			loadGraphic(AssetPaths.bullet__png);
			this.angle = 0;
		}
		else
		{
			loadGraphic(AssetPaths.bullet__png);
			this.angle = 180;
		}
	}

	function setBulletSpeed():Void
	{
		// Make the bullet move in the correct direction.
		if (friendly)
		{
			velocity.y = -bulletSpeed;
			velocity.x = 0;
		}
		else
		{
			velocity.y = bulletSpeed;
			velocity.x = 0;
		}
	}

	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Kill the bullet if off-screen.
		if (x < 0 || x > FlxG.width)
		{
			kill();
		}

		if (maxVelocity.x <= 0 && velocity.x != 0)
		{
			// Fix the bullet's speed if it's moving the wrong way.
			setBulletSpeed();
		}

		if (maxVelocity.y <= 0 && velocity.y != 0)
		{
			// Fix the bullet's speed if it's moving the wrong way.
			setBulletSpeed();
		}
	}
}

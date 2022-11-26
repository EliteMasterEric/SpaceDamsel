package components;

import states.PlayState;

class Bullet extends FlxSprite
{
	static final BULLET_VELOCITY:Float = 600;

	public var friendly(default, set):Bool;

	function set_friendly(value:Bool):Bool
	{
		friendly = value;

		playBulletAnim();
		setBulletSpeed();

		return friendly;
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
			velocity.y = -BULLET_VELOCITY;
		}
		else
		{
			velocity.y = BULLET_VELOCITY;
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
	}
}

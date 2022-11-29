package components;

import states.DefeatState;
import states.PlayState;

class Player extends BaseEnemy
{
	static final PLAYER_HEALTH:Float = 5.0;

	static final PLAYER_HORIZONTAL_VELOCITY:Float = 300.0;
	static final PLAYER_VERTICAL_VELOCITY:Float = 200.0;

	static final PLAYER_FIRE_RATE:Float = 0.2;

	var fireTimer:Float = 0.0;

	public function new()
	{
		super(AssetPaths.player_base__png, true, PLAYER_HEALTH);
	}

	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		handleMovementControls();
		handleShootControls();

		#if debug
		FlxG.watch.addQuick("Player posX", this.x);
		FlxG.watch.addQuick("Player posY", this.y);
		// FlxG.watch.addQuick("Player velX", velocity.x);
		// FlxG.watch.addQuick("Player velY", velocity.y);
		// FlxG.watch.addQuick("Player fireTimer", fireTimer);
		FlxG.watch.addQuick("Player health", health);

		// FlxG.watch.addQuick("Button left", FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A);
		// FlxG.watch.addQuick("Button right", FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D);
		// FlxG.watch.addQuick("Button up", FlxG.keys.pressed.UP || FlxG.keys.pressed.W);
		// FlxG.watch.addQuick("Button down", FlxG.keys.pressed.DOWN || FlxG.keys.pressed.S);
		#end
	}

	/**
	 * Move the player with the arrow keys or WASD.
	 */
	function handleMovementControls():Void
	{
		if (FlxG.keys.justPressed.A || FlxG.keys.justPressed.LEFT)
		{
			this.velocity.x = -PLAYER_HORIZONTAL_VELOCITY;
		}
		else if (FlxG.keys.justPressed.D || FlxG.keys.justPressed.RIGHT)
		{
			this.velocity.x = PLAYER_HORIZONTAL_VELOCITY;
		}
		else if (FlxG.keys.justReleased.A || FlxG.keys.justReleased.LEFT)
		{
			// Fix null movement.
			if (FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT)
			{
				this.velocity.x = PLAYER_HORIZONTAL_VELOCITY;
			}
			else
			{
				this.velocity.x = 0;
			}
		}
		else if (FlxG.keys.justReleased.D || FlxG.keys.justReleased.RIGHT)
		{
			// Fix null movement.
			if (FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT)
			{
				this.velocity.x = -PLAYER_HORIZONTAL_VELOCITY;
			}
			else
			{
				this.velocity.x = 0;
			}
		}

		if (FlxG.keys.justPressed.W || FlxG.keys.justPressed.UP)
		{
			this.velocity.y = -PLAYER_VERTICAL_VELOCITY;
		}
		else if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.DOWN)
		{
			this.velocity.y = PLAYER_VERTICAL_VELOCITY;
		}
		else if (FlxG.keys.justReleased.W || FlxG.keys.justReleased.UP)
		{
			// Fix null movement.
			if (FlxG.keys.pressed.S || FlxG.keys.pressed.DOWN)
			{
				this.velocity.y = PLAYER_VERTICAL_VELOCITY;
			}
			else
			{
				this.velocity.y = 0;
			}
		}
		else if (FlxG.keys.justReleased.S || FlxG.keys.justReleased.DOWN)
		{
			// Fix null movement.
			if (FlxG.keys.pressed.W || FlxG.keys.pressed.UP)
			{
				this.velocity.y = -PLAYER_VERTICAL_VELOCITY;
			}
			else
			{
				this.velocity.y = 0;
			}
		}
	}

	function handleShootControls():Void
	{
		// Automatic firing that doesn't improve when spammed.
		if (FlxG.keys.pressed.SPACE && fireTimer <= 0)
		{
			fireTimer = PLAYER_FIRE_RATE;
			fireBullet();
		}

		if (fireTimer > 0)
		{
			fireTimer -= FlxG.elapsed;
		}
	}

	public override function kill():Void
	{
		super.kill();

		doExplosion(() ->
		{
			trace('You lost!');
			FlxG.switchState(new DefeatState());
		});
	}
}

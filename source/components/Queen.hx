package components;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxFilterFrames;
import io.newgrounds.utils.ExternalAppList;
import openfl.filters.GlowFilter;
import states.PlayState;

/**
 * The Queen has several unique behaviors.
 * While other enemies are on screen, she will not move or fire, but she will be
 * invulnerable to damage.
 * When the last enemy is killed, the Queen will begin to move randomly and fire when the player is in range,
 * and the music will change.
 */
class Queen extends BaseEnemy
{
	static final QUEEN_HEALTH:Float = 15.0;

	static final QUEEN_WORTH:Int = 1000;

	static final QUEEN_SPEED:Float = 150.0;

	static final QUEEN_FIRE_RATE:Float = 0.25;

	/**
	 * If true, shield is off and other behaviors are on.
	 */
	public var activated(default, set):Bool;

	var filteredFrames:FlxFilterFrames;
	var _glow:GlowFilter;

	public function new()
	{
		super(AssetPaths.queen__png, false, QUEEN_HEALTH, QUEEN_WORTH);

		this.filteredFrames = FlxFilterFrames.fromFrames(this.frames, 16, 16);
		_glow = new GlowFilter(0xFF6666DD, 1, 50, 50, 1.5, 1);

		this.frames = filteredFrames;

		this.activated = false;
	}

	var elapsedSinceCheck:Float = 0;
	var elapsedSinceShot:Float = 0;

	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Manage activation. Activate when only the queen is left.
		var hasEnemies:Bool = false;
		for (enemy in PlayState.instance.enemies.members)
		{
			if (!enemy.alive)
				continue;

			if (Std.isOfType(enemy, Queen))
				continue;

			trace('Queen is not activated');
			hasEnemies = true;
		}
		this.activated = !hasEnemies;

		if (!activated)
		{
			// Indicate damage prevention.
			this.color = 0xFF6666DD;

			// Don't move.
			this.velocity.x = 0;
			this.velocity.y = 0;
		}
		else
		{
			// Indicate damage vulnerability.
			this.color = 0xFFFFFFFF;

			// Randomized movement.
			elapsedSinceCheck += elapsed;

			if (elapsedSinceCheck >= 0.75)
			{
				this.velocity.x = FlxG.random.bool() ? 0 : this.velocity.x;
				this.velocity.y = FlxG.random.bool() ? 0 : this.velocity.y;
			}

			if (this.velocity.x == 0)
			{
				this.velocity.x = FlxG.random.float(-QUEEN_SPEED, QUEEN_SPEED);
			}
			if (this.velocity.y == 0)
			{
				this.velocity.y = FlxG.random.float(-QUEEN_SPEED, QUEEN_SPEED);
			}

			// Fire rapidly at the player.
			var playerXDistance = Math.abs(this.x + this.width / 2 - PlayState.instance.player.x - PlayState.instance.player.width / 2);
			FlxG.watch.addQuick("playerDistance", playerXDistance);
			if (playerXDistance < (this.width))
			{
				elapsedSinceShot += elapsed;

				if (elapsedSinceShot >= QUEEN_FIRE_RATE)
				{
					elapsedSinceShot = 0;
					this.fireBullet(true);
				}
			}
			else
			{
				elapsedSinceShot = 0;
			}
		}
	}

	function set_activated(value:Bool):Bool
	{
		// Don't reapply the glow filter.
		if (activated == value)
			return activated;

		this.activated = value;

		// Enable or disable the glow filter.
		if (!this.activated)
		{
			this.filteredFrames.addFilter(_glow);
		}
		else
		{
			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();
			FlxG.sound.playMusic(AssetPaths.raving_energy_intense__ogg, 0.7);
			this.filteredFrames.removeFilter(_glow);
		}

		return this.activated;
	}

	override function onCollideBullet(objA:FlxObject, objB:FlxObject)
	{
		if (activated)
		{
			super.onCollideBullet(objA, objB);
		}
		else
		{
			// Remove bullet but ignore damage.
			objB.kill();
			// invincibleTimer = invincibleDuration;
		}
	}
}

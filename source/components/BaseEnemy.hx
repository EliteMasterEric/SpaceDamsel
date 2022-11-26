package components;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import states.PlayState;

abstract class BaseEnemy extends FlxSprite
{
	var invincibleDuration:Float = 0.5;

	var invincibleTimer:Float = 0;

	var worth:Int;

	var friendly:Bool = false;

	public function new(graphic:FlxGraphicAsset, friendly:Bool, hp:Float, ?worth:Int = 100)
	{
		super(0, 0, graphic);

		this.health = hp;
		this.friendly = friendly;
		this.worth = worth;

		// Characters can't push each other around
		this.immovable = true;
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (friendly)
		{
			// Handle friendly collision logic.
			FlxG.collide(this, PlayState.instance.enemies, onCollideEnemy);
			FlxG.collide(this, PlayState.instance.enemyBulletPool, onCollideBullet);
		}
		else
		{
			// Handle enemy collision logic.
			// Enemies simply collide without hurting each other.
			FlxG.collide(this, PlayState.instance.friendlyBulletPool, onCollideBullet);
		}

		constrainMovement();
		handleInvincibility(elapsed);
	}

	function handleInvincibility(elapsed:Float)
	{
		if (invincibleTimer > 0)
		{
			invincibleTimer -= elapsed;
			// Flicker the sprite.
			this.alpha = (invincibleTimer % 0.1) > 0.05 ? 1 : 0.5;
		}
		else
		{
			this.invincibleTimer = 0;
			this.alpha = 1;
		}
	}

	public override function hurt(damage:Float)
	{
		if (invincibleTimer <= 0)
		{
			super.hurt(damage);
			invincibleTimer = invincibleDuration;
		}
	}

	public function forceHurt(damage:Int)
	{
		super.hurt(damage);
	}

	function onCollideEnemy(objA:FlxObject, objB:FlxObject)
	{
		// The player bumped into an enemy.
		// Hurt the player and knock them downwards.
		objA.hurt(1);
		objA.velocity.y = -100;
	}

	function onCollideBullet(objA:FlxObject, objB:FlxObject)
	{
		// The player bumped into an enemy bullet.
		// Hurt the player, and destroy the bullet.
		objA.hurt(1);
		objB.kill();
	}

	public override function kill()
	{
		super.kill();
		if (friendly)
		{
			FlxG.log.notice('You lost!');
			FlxG.resetState();
		}
		else
		{
			FlxG.log.notice('You beat an enemy!');
			PlayState.instance.score += this.worth;
		}
	}

	/**
	 * Keep the player within the bounds of the screen.
	 */
	function constrainMovement():Void
	{
		if (this.x < 0)
		{
			this.x = 0;
		}
		else if (this.x + this.width > FlxG.width)
		{
			this.x = FlxG.width - this.width;
		}

		if (this.y < 0)
		{
			this.y = 0;
		}
		else if (this.y + this.height > FlxG.height)
		{
			this.y = FlxG.height - this.height;
		}
	}

	function fireBullet():Void
	{
		// Bullet spawn location is top center of player.
		// Bullet is friendly.
		var bulletX = this.x + this.width / 2;
		var bulletY = this.friendly ? this.y : this.y + this.height;
		PlayState.instance.spawnBullet(bulletX, bulletY, this.friendly);

		// Play the sound effect.
		FlxG.sound.play("assets/sounds/laser-small.mp3", 0.5);
	}
}

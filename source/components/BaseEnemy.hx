package components;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxSound;
import states.MenuState;
import states.PlayState;

abstract class BaseEnemy extends FlxSprite
{
	var invincibleDuration:Float = 0.5;

	var invincibleTimer:Float = 0;

	var worth:Int;

	var bulletSpeed:Float = 300;

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
			FlxG.overlap(this, PlayState.instance.enemies, onCollideEnemy);
			FlxG.overlap(this, PlayState.instance.enemyBulletPool, onCollideBullet);
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

		if (!friendly)
		{
			PlayState.instance.score += worth;
			doExplosion(() ->
			{
				trace('You beat an enemy!');
			});
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

	function fireBullet(?forceStraight:Bool = true, ?bigSound:Bool = false):Bullet
	{
		// Play the sound effect.
		FlxG.sound.play(bigSound ? AssetPaths.laser_big__ogg : AssetPaths.laser_small__ogg, 1.0);

		// Bullet spawn location is top center of player.
		// Bullet is friendly.
		var bulletX = this.x + this.width / 2;
		var bulletY = this.friendly ? this.y - 8 : this.y + this.height + 8;
		var bullet = PlayState.instance.spawnBullet(bulletX, bulletY, this.friendly, bulletSpeed);

		if (forceStraight)
			bullet.maxVelocity.x = 0;

		return bullet;
	}

	function doExplosion(onComplete:Void->Void)
	{
		var explosion:FlxSprite = new FlxSprite(0, 0).loadGraphic(AssetPaths.explosion__png);
		explosion.setGraphicSize(Std.int(this.width), Std.int(this.height));
		explosion.updateHitbox();
		// set position AFTER setting graphic size.
		explosion.x = this.x;
		explosion.y = this.y;

		PlayState.instance.add(explosion);

		// Play the sound
		var sound:FlxSound = FlxG.sound.play(AssetPaths.boom__ogg, 1.0);
		sound.onComplete = () ->
		{
			explosion.kill();
			onComplete();
		};
	}
}

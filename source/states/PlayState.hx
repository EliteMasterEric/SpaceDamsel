package states;

import components.BaseEnemy;
import components.Bee;
import components.Bullet;
import components.Hornet;
import components.Player;
import components.Queen;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	public static var instance:PlayState;

	static final SPACE_BASE_SPEED:Float = 75.0;
	static final SCORE_LERP_SPEED:Float = 2.0;

	// Gameplay state
	public var score:Int = 0;

	public var timer:Float = 300.0;

	var scoreLerp:Int = 0;

	public var player:Player;

	public var enemies:FlxTypedGroup<BaseEnemy>;

	public var friendlyBulletPool:FlxTypedGroup<Bullet>;
	public var enemyBulletPool:FlxTypedGroup<Bullet>;

	// Graphics
	var spaceBG:FlxBackdrop;
	var scoreText:FlxText;
	var healthText:FlxText;
	var timerText:FlxText;

	public function new()
	{
		super();
		instance = this;
	}

	public override function create()
	{
		super.create();

		// Play the music
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		switch (Persistent.currentLevel)
		{
			case 3:
				FlxG.sound.playMusic(AssetPaths.raving_energy__ogg, 0.7);
			default:
				FlxG.sound.playMusic(AssetPaths.voxel_revolution__ogg, 0.7);
		}

		// Create the background
		spaceBG = new FlxBackdrop(AssetPaths.space__png);
		spaceBG.velocity.y = SPACE_BASE_SPEED;
		add(spaceBG);

		// Build the player
		player = new Player();
		add(player);

		spawnEnemies();

		// Prepare the bullet groups
		friendlyBulletPool = new FlxTypedGroup<Bullet>();
		add(friendlyBulletPool);

		enemyBulletPool = new FlxTypedGroup<Bullet>();
		add(enemyBulletPool);

		// Start the player at the bottom center of the screen
		player.x = FlxG.width / 2 - player.width / 2;
		player.y = FlxG.height - player.height;

		// Build the score text
		scoreText = new FlxText(0, 0, FlxG.width, "SCORE: 0");
		scoreText.setFormat(null, 16, 0xFFFFFFFF, "left");
		// Move the text to the bottom left of the screen
		scoreText.y = FlxG.height - scoreText.height;
		add(scoreText);

		// Build the health text
		healthText = new FlxText(0, 0, FlxG.width, "HEALTH: 5");
		healthText.setFormat(null, 16, 0xFFFFFFFF, "right");
		// Move the text to the bottom right of the screen
		healthText.y = FlxG.height - healthText.height;
		add(healthText);

		// Build the timer text
		timerText = new FlxText(0, 0, FlxG.width, "TIME: 300");
		timerText.setFormat(null, 16, 0xFFFFFFFF, "center");
		// Move the text to the bottom center of the screen
		timerText.y = FlxG.height - timerText.height;
		add(timerText);
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		timer -= elapsed;

		handleKeybinds();
		handleStatus(elapsed);
		handleProgress();
	}

	function handleStatus(elapsed:Float)
	{
		// Update the score text
		scoreLerp = Math.ceil(FlxMath.lerp(scoreLerp, score, elapsed * SCORE_LERP_SPEED));
		scoreText.text = 'SCORE: $scoreLerp';

		// Update the health text
		healthText.text = 'HEALTH: ${player.health}';
		// Sneaky way to flash the health text when the player is hit
		healthText.alpha = player.alpha;

		// Update the timer text
		timerText.text = 'TIME: ${Math.ceil(timer)}';
	}

	function handleKeybinds()
	{
		if (FlxG.keys.justPressed.R)
		{
			FlxG.resetState();
		}
		if (FlxG.keys.justPressed.P)
		{
			openSubState(new PauseSubState());
		}

		// Player keybinds are handled in the Player class.
	}

	var finishTimer:Float = 0.0;

	function handleProgress()
	{
		if (score > 0 && enemies.countLiving() == 0)
		{
			// We've killed all the enemies, so the level is over.
			finishTimer += FlxG.elapsed;
		}

		if (finishTimer > 2.0)
		{
			// The level is over, so go to the results screen
			FlxG.switchState(new ResultsState(score, Math.ceil(timer)));
		}
	}

	/**
	 * Spawn enemies in the level based on the level data array.
	 */
	function spawnEnemies()
	{
		enemies = new FlxTypedGroup<BaseEnemy>();
		add(enemies);

		var enemyData = Persistent.LEVEL_DATA[Persistent.currentLevel];

		for (enemyDataItem in enemyData)
		{
			var enemy:BaseEnemy;
			switch (enemyDataItem.type)
			{
				case 'Bee':
					enemy = new Bee();
					enemy.x = enemyDataItem.x;
					enemy.y = enemyDataItem.y;
				case 'Hornet':
					var hornetEnemy = new Hornet();
					hornetEnemy.startingPosition.x = enemyDataItem.x;
					hornetEnemy.startingPosition.y = enemyDataItem.y;
					enemy = hornetEnemy;
					enemy.x = enemyDataItem.x;
					enemy.y = enemyDataItem.y;
				case 'Queen':
					enemy = new Queen();
					enemy.x = enemyDataItem.x;
					enemy.y = enemyDataItem.y;
				default:
					throw 'Unknown enemy type: ${enemyDataItem.type}';
			}

			enemy.x -= enemy.width / 2;
			// enemy.y -= enemy.height / 2;

			enemies.add(enemy);
		}
	}

	public function spawnBullet(xPos:Float, yPos:Float, friendly:Bool, bulletSpeed:Float)
	{
		if (friendly)
		{
			var bullet:Bullet = friendlyBulletPool.recycle(Bullet.new);
			bullet.friendly = friendly;
			bullet.x = xPos;
			bullet.y = yPos;
			bullet.bulletSpeed = bulletSpeed;
			friendlyBulletPool.add(bullet);
			return bullet;
		}
		else
		{
			var bullet:Bullet = enemyBulletPool.recycle(Bullet.new);
			bullet.friendly = friendly;
			bullet.x = xPos;
			bullet.y = yPos;
			bullet.bulletSpeed = bulletSpeed;
			enemyBulletPool.add(bullet);
			return bullet;
		}
	}

	public function clearBullets()
	{
		friendlyBulletPool.forEachAlive(function(bullet:Bullet)
		{
			bullet.kill();
		});

		enemyBulletPool.forEachAlive(function(bullet:Bullet)
		{
			bullet.kill();
		});
	}
}

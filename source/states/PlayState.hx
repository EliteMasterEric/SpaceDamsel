package states;

import components.BaseEnemy;
import components.Bee;
import components.Bullet;
import components.Player;
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

	var scoreLerp:Int = 0;

	public var player:Player;

	public var enemies:FlxTypedGroup<BaseEnemy>;

	public var friendlyBulletPool:FlxTypedGroup<Bullet>;
	public var enemyBulletPool:FlxTypedGroup<Bullet>;

	// Graphics
	var spaceBG:FlxBackdrop;
	var scoreText:FlxText;
	var healthText:FlxText;

	public function new()
	{
		super();
		instance = this;
	}

	public override function create()
	{
		super.create();

		// Play the music
		FlxG.sound.playMusic(AssetPaths.voxel_revolution__mp3, 1.0);

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
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.R)
		{
			FlxG.resetState();
		}

		// Update the score text
		scoreLerp = Math.ceil(FlxMath.lerp(scoreLerp, score, elapsed * SCORE_LERP_SPEED));
		scoreText.text = 'SCORE: $scoreLerp';

		// Update the health text
		healthText.text = 'HEALTH: ${player.health}';
		// Sneaky way to flash the health text when the player is hit
		healthText.alpha = player.alpha;
	}

	function spawnEnemies()
	{
		enemies = new FlxTypedGroup<BaseEnemy>();
		add(enemies);

		var enemy:BaseEnemy;
		var enemyCount:Int = 5;
		var enemySpacing:Float = FlxG.width / enemyCount;
		var enemyX:Float = enemySpacing / 2;
		var enemyY:Float = 0;

		for (i in 0...enemyCount)
		{
			enemy = new Bee();
			enemy.x = enemyX;
			enemy.y = enemyY;
			enemies.add(enemy);

			enemyX += enemySpacing;
		}
	}

	public function spawnBullet(xPos:Float, yPos:Float, friendly:Bool)
	{
		if (friendly)
		{
			var bullet:Bullet = friendlyBulletPool.recycle(Bullet.new);
			bullet.friendly = friendly;
			bullet.x = xPos;
			bullet.y = yPos;
			friendlyBulletPool.add(bullet);
		}
		else
		{
			var bullet:Bullet = enemyBulletPool.recycle(Bullet.new);
			bullet.friendly = friendly;
			bullet.x = xPos;
			bullet.y = yPos;
			enemyBulletPool.add(bullet);
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

package states;

import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;

class MenuState extends FlxState
{
	var logoText:FlxText;
	var subtitleText:FlxText;

	var totalElapsed:Float = 0;

	static final WOBBLE_SPEED:Float = 10;
	static final WOBBLE_AMPLITUDE:Float = 4.0;
	static final CREDIT_DURATION:Float = 4.0;

	public override function create():Void
	{
		super.create();

		Persistent.traceScores();

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		FlxG.sound.playMusic(AssetPaths.new_friendly__ogg, 0.7);

		// Create the background
		var spaceBG = new FlxBackdrop(AssetPaths.space__png);
		spaceBG.velocity.y = 75.0;
		add(spaceBG);

		// Create the logo
		logoText = new FlxText(0, 0, 0, "Space\nDamsel");
		logoText.setFormat(null, 32, 0xFFFFFFFF, "center");
		logoText.x = (FlxG.width - logoText.width) / 2;
		logoText.y = (FlxG.height - logoText.height) / 2;
		add(logoText);

		// Display subtitle
		subtitleText = new FlxText(0, 0, 0, "Created by: \nEliteMasterEric");
		subtitleText.setFormat(null, 16, 0xFFFFFFFF, "center");
		subtitleText.x = (FlxG.width - subtitleText.width) / 2;
		subtitleText.y = (FlxG.height - subtitleText.height) / 2 + 100;
		add(subtitleText);

		// Create the instructions
		var instructionsText = new FlxText(0, 0, 0, "Press [SPACE] to start");
		instructionsText.setFormat(null, 16, 0xFFFFFFFF, "center");
		instructionsText.x = (FlxG.width - instructionsText.width) / 2;
		instructionsText.y = FlxG.height - instructionsText.height - 10;
		add(instructionsText);

		// Create the highscore text in the top right
		var highscore = new FlxText(0, 0, 0, Persistent.getHighScoreData());
		highscore.setFormat(null, 16, 0xFFFFFFFF, "left");
		highscore.x = FlxG.width - highscore.width - 10;
		highscore.y = 10;
		add(highscore);

		Newgrounds.onLogin(() ->
		{
			var ngText = new FlxText(0, 0, 0, "Logged in as " + Newgrounds.username);
			ngText.setFormat(null, 16, 0xFFFFFFFF, "left");
			ngText.x = 10;
			ngText.y = 10;
			add(ngText);
		});
	}

	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		totalElapsed += elapsed;

		logoText.angle = Math.sin(totalElapsed * WOBBLE_SPEED) * WOBBLE_AMPLITUDE;

		// Cycle through credits text
		switch (Math.floor((totalElapsed / CREDIT_DURATION) % 8))
		{
			case 0:
				subtitleText.text = "Created by: \nEliteMasterEric";
			case 1:
				subtitleText.text = "Programming by: \nEliteMasterEric";
			case 2:
				subtitleText.text = "Art by: \nEliteMasterEric";
			case 3:
				subtitleText.text = "Music by: \nKevin MacLeod";
			case 4:
				subtitleText.text = "Sound effects by: \nFreesound.org";
			case 5:
				subtitleText.text = "Special thanks to: \nNewgrounds";
			case 6:
				subtitleText.text = "Special thanks to: \nHaxeFlixel";
			case 7:
				subtitleText.text = "Special thanks to: \nYou ;)";
			default:
				subtitleText.text = "Created by: \nEliteMasterEric";
		}
		// Keep the text centered.
		subtitleText.x = (FlxG.width - subtitleText.width) / 2;

		// Start the game when the player presses space
		if (FlxG.keys.justPressed.SPACE)
		{
			if (Persistent.hasSeenIntro)
			{
				FlxG.switchState(new PlayState());
			}
			else
			{
				FlxG.switchState(new IntroScrollState());
			}
		}
	}
}

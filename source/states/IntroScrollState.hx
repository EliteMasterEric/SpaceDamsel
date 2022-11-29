package states;

import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;

class IntroScrollState extends FlxState
{
	static final INTRO_DURATION:Float = 7.5;
	static final PAD:Int = 10;

	var instructionText:FlxText;
	var scrollingText:FlxText;

	public override function create()
	{
		super.create();

		Persistent.hasSeenIntro = true;

		// Play the music
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		FlxG.sound.playMusic(AssetPaths.voxel_revolution__ogg, 0.7);

		// Create the background
		var spaceBG = new FlxBackdrop(AssetPaths.space__png);
		spaceBG.velocity.y = 75.0;
		add(spaceBG);

		scrollingText = new FlxText(0, 0, FlxG.width,
			"Oh no!\nThe evil Space Pirate Queen\nhas kidnapped your girlfriend!\nGo, Space Damsel,\nand engage her fleet to rescue her!");
		scrollingText.setFormat(null, 24, 0xFFFFFFFF, "center");
		scrollingText.moves = true; // Velocity is disabled on text by default.
		scrollingText.velocity.y = -50;
		scrollingText.y = FlxG.height; // Start offscreen
		add(scrollingText);

		instructionText = new FlxText(0, 0, FlxG.width, "WASD/Arrows to Move, SPACE to Fire, P to Pause\nPress [SPACE] to continue");
		instructionText.setFormat(null, 16, 0xFFFFFFFF, "center");
		instructionText.y = FlxG.height - instructionText.height - PAD;
	}

	var scrollingDone:Bool = false;

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (scrollingText.y < PAD)
		{
			scrollingDone = true;
			scrollingText.velocity.y = 0;
			scrollingText.y = PAD;
			add(instructionText);
		}

		if (scrollingDone && FlxG.keys.justPressed.SPACE)
		{
			FlxG.switchState(new PlayState());
		}
	}
}

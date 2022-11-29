package states;

import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;

class DefeatState extends FlxState
{
	public override function create()
	{
		super.create();

		// Create the background
		var spaceBG = new FlxBackdrop(AssetPaths.space__png);
		spaceBG.velocity.y = 75.0;
		add(spaceBG);

		// Create the logo
		var defeatText = new FlxText(0, 0, 0, "You were defeated!");
		defeatText.setFormat(null, 32, 0xFFFFFFFF, "center");
		defeatText.x = (FlxG.width - defeatText.width) / 2;
		defeatText.y = (FlxG.height - defeatText.height) / 2;
		add(defeatText);

		// Create the instructions
		var instructionsText = new FlxText(0, 0, 0, "Press [SPACE] to replay level\nPress [ESC] to return to main menu");
		instructionsText.setFormat(null, 16, 0xFFFFFFFF, "center");
		instructionsText.x = (FlxG.width - instructionsText.width) / 2;
		instructionsText.y = FlxG.height - instructionsText.height - 10;
		add(instructionsText);

		// Play the music
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		FlxG.sound.playMusic(AssetPaths.half_mystery__ogg, 0.7);
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check for input
		if (FlxG.keys.justPressed.SPACE)
		{
			// Replay the same level
			FlxG.switchState(new PlayState());
		}
		else if (FlxG.keys.justPressed.ESCAPE)
		{
			// Reset progress and return to menu
			Persistent.resetProgress();
			FlxG.switchState(new MenuState());
		}
	}
}

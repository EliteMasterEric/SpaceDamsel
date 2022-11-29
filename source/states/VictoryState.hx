package states;

import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;

class VictoryState extends FlxState
{
	public override function create()
	{
		super.create();

		// Create the background
		var spaceBG = new FlxBackdrop(AssetPaths.space__png);
		spaceBG.velocity.y = 75.0;
		add(spaceBG);

		// Create the logo
		var victoryText = new FlxText(0, 0, 0, "Congratulations, Space Damsel!");
		victoryText.setFormat(null, 32, 0xFFFFFFFF, "center");
		victoryText.x = (FlxG.width - victoryText.width) / 2;
		victoryText.y = (FlxG.height - victoryText.height) / 2;
		add(victoryText);

		// Create the flavor text
		var flavorText = new FlxText(0, 0, 0, "You have saved your girlfriend\nfrom the Space Pirate Queen!\nThe galaxy is now a safer place.");
		flavorText.setFormat(null, 16, 0xFFFFFFFF, "center");
		flavorText.x = (FlxG.width - flavorText.width) / 2;
		flavorText.y = victoryText.y + victoryText.height + 10;
		add(flavorText);

		// Create the instructions
		var instructionsText = new FlxText(0, 0, 0, "Press [SPACE] to return to main menu");
		instructionsText.setFormat(null, 16, 0xFFFFFFFF, "center");
		instructionsText.x = (FlxG.width - instructionsText.width) / 2;
		instructionsText.y = FlxG.height - instructionsText.height - 10;
		add(instructionsText);

		// Play the music
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		FlxG.sound.playMusic(AssetPaths.bit_shift__ogg, 0.7);
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check for input
		if (FlxG.keys.justPressed.SPACE)
		{
			// Reset progress and return to menu
			Persistent.resetProgress();
			FlxG.switchState(new MenuState());
		}
	}
}

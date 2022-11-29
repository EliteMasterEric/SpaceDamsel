package states;

import components.Player;
import flixel.FlxG;
import flixel.FlxState;

class InitState extends FlxState
{
	public override function create():Void
	{
		var destinationState:FlxState;

		// Load game data and saved scores.
		Persistent.init();
		Newgrounds.init();

		// Edit this to go straight to the state that is work-in-progress

		destinationState = new MenuState();
		// destinationState = new IntroScrollState();
		// Persistent.currentLevel = 1;
		// Persistent.currentLevel = 2;
		// Persistent.currentLevel = 3;
		// destinationState = new PlayState();
		// destinationState = new VictoryState();

		FlxG.switchState(destinationState);
	}
}

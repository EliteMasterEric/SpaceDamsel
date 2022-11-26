package states;

import flixel.FlxG;
import flixel.FlxState;

class InitState extends FlxState
{
	public override function create():Void
	{
		var destinationState:FlxState;

		destinationState = new PlayState();

		FlxG.switchState(destinationState);
	}
}

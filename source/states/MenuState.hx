package states;

import flixel.FlxState;

class MenuState extends FlxState
{
	public override function create():Void
	{
		super.create();

		FlxG.sound.playMusic(AssetPaths.New_Friendly__mp3);
	}
}

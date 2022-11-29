package states;

import flixel.FlxSubState;
import flixel.text.FlxText;

class PauseSubState extends FlxSubState
{
	public override function create()
	{
		super.create();

		// Transparent dark background
		this.bgColor = 0x88111111;

		// Pause text
		var text:FlxText = new FlxText(0, FlxG.height / 2 - 10, FlxG.width, "PAUSED\nPress P to resume");
		text.setFormat(null, 16, 0xFFFFFFFF, "center");
		add(text);
	}

	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.P)
		{
			this.close();
		}
	}
}

package states;

import flixel.addons.display.FlxBackdrop;
import flixel.math.FlxMath;
import flixel.text.FlxText;

class ResultsState extends FlxState
{
	static final TIMER_SCORE_MULTIPLIERS = [0, 1, 3, 5];

	static final FLAVOR_TEXT = [
		"Placeholder",
		"Good work! There's more to come!",
		"Get ready! The Queen approaches!",
		"Congratulations, Space Damsel!"
	];

	var destroyScore:Int = 0;
	var timer:Int = 0;
	var timerMultiplier:Int = 0;
	var timerScore:Int = 0;
	var totalScore:Int = 0;

	var destroyText:FlxText;
	var timerText:FlxText;
	var totalText:FlxText;
	var instructionsText:FlxText;

	public function new(destroyScore:Int, timer:Int)
	{
		super();

		this.destroyScore = destroyScore;
		this.timer = timer;
		this.timerMultiplier = TIMER_SCORE_MULTIPLIERS[Persistent.currentLevel];
		this.timerScore = timer * timerMultiplier;
		this.totalScore = destroyScore + timerScore;
	}

	public override function create()
	{
		super.create();

		// Play the music
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		FlxG.sound.playMusic(AssetPaths.bit_shift__ogg, 0.7);

		// Create the background
		var spaceBG = new FlxBackdrop(AssetPaths.space__png);
		spaceBG.velocity.y = 75.0;
		add(spaceBG);

		var flavorText = new FlxText(0, 0, FlxG.width, FLAVOR_TEXT[Persistent.currentLevel]);
		flavorText.setFormat(null, 24, 0xFFFFFFFF, "center");
		flavorText.y = 20;
		add(flavorText);

		var resultsText = new FlxText(0, 0, FlxG.width, "Results");
		resultsText.setFormat(null, 32, 0xFFFFFFFF, "center");
		resultsText.y = 60;
		add(resultsText);

		destroyText = new FlxText(0, 0, FlxG.width, "");
		destroyText.setFormat(null, 16, 0xFFFFFFFF, "center");
		destroyText.y = resultsText.y + resultsText.height + 10;
		add(destroyText);

		timerText = new FlxText(0, 0, FlxG.width, '');
		timerText.setFormat(null, 16, 0xFFFFFFFF, "center");
		timerText.y = destroyText.y + destroyText.height + 10;
		add(timerText);

		totalText = new FlxText(0, 0, FlxG.width, "");
		totalText.setFormat(null, 16, 0xFFFFFFFF, "center");
		totalText.y = timerText.y + timerText.height + 10;
		add(totalText);

		instructionsText = new FlxText(0, 0, FlxG.width, "Press [SPACE] to continue");
		instructionsText.setFormat(null, 16, 0xFFFFFFFF, "center");
		instructionsText.y = FlxG.height - instructionsText.height - 10;
	}

	static final LERP_TIME = 2.0;

	var currentState:Int = 0;

	var destroyScoreLerp:Int = 0;
	var timerScoreLerp:Int = 0;
	var totalScoreLerp:Int = 0;

	public override function update(elapsed:Float)
	{
		super.update(elapsed);

		switch (currentState)
		{
			case 0:
				destroyScoreLerp = Math.ceil(FlxMath.lerp(destroyScoreLerp, destroyScore, elapsed * LERP_TIME));
				if (destroyScoreLerp >= destroyScore)
				{
					currentState = 1;
					destroyScoreLerp = destroyScore;
				}
				destroyText.text = 'Destroy: $destroyScoreLerp';
			case 1:
				timerScoreLerp = Math.ceil(FlxMath.lerp(timerScoreLerp, timerScore, elapsed * LERP_TIME));
				if (timerScoreLerp >= timerScore)
				{
					currentState = 2;
					timerScoreLerp = timerScore;
				}
				timerText.text = 'Time:   $timerScoreLerp x $timerMultiplier = $timerScore';
			case 2:
				totalScoreLerp = Math.ceil(FlxMath.lerp(totalScoreLerp, totalScore, elapsed * LERP_TIME));
				if (totalScoreLerp >= totalScore)
				{
					currentState = 3;
					totalScoreLerp = totalScore;
				}
				totalText.text = 'Total: $totalScoreLerp';
			case 3:
				add(instructionsText);
				currentState = 4;
		}

		if (FlxG.keys.justPressed.SPACE)
		{
			saveAndContinue();
		}
	}

	function saveAndContinue()
	{
		Persistent.recordScore(totalScore, Persistent.currentLevel);
		Newgrounds.awardMedal(Newgrounds.MEDALS[Persistent.currentLevel]);
		if (Persistent.currentLevel >= Persistent.LEVEL_COUNT)
		{
			FlxG.switchState(new VictoryState());
		}
		else
		{
			Persistent.currentLevel++;
			FlxG.switchState(new PlayState());
		}
	}
}

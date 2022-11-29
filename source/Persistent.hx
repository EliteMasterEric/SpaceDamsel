package;

import flixel.util.FlxSave;

class Persistent
{
	/**
	 * Keeps track of what level we're on.
	 */
	public static var currentLevel:Int = 1;

	public static final LEVEL_COUNT:Int = 3;

	public static var hasSeenIntro:Bool = false;

	public static var LEVEL_DATA = [];

	/**
	 * Keeps track of the player's level scores.
	 * The 0th entry is the total and the 1st/2nd/3rd entries are the scores for the three levels.
	 */
	static var currentScores:Array<Int>;

	/**
	 * Access to the player's game save.
	 */
	static var gameSave:FlxSave;

	static final SAVE_SLOT:String = "SpaceDamselDemo";

	/**
	 * Call this to initialize or reset the persistent data,
	 * such as what level we're on and the player's scores.
	 */
	public static function init()
	{
		// Create a new save object and load the data
		createSaveData();

		buildLevelData();

		resetProgress();
		saveHighScores();
	}

	public static function resetProgress():Void
	{
		currentLevel = 1;
		currentScores = [0, 0, 0, 0];
	}

	static function buildLevelData():Void
	{
		// This needs to be done once FlxG.width is set
		LEVEL_DATA = [
			null,
			[
				{type: "Bee", x: (FlxG.width / 10 * 1), y: 10},
				{type: "Bee", x: (FlxG.width / 10 * 3), y: 10},
				{type: "Bee", x: (FlxG.width / 10 * 5), y: 10},
				{type: "Bee", x: (FlxG.width / 10 * 7), y: 10},
				{type: "Bee", x: (FlxG.width / 10 * 9), y: 10},
				{type: "Bee", x: (FlxG.width / 10 * 2), y: 100},
				{type: "Bee", x: (FlxG.width / 10 * 4), y: 100},
				{type: "Bee", x: (FlxG.width / 10 * 6), y: 100},
				{type: "Bee", x: (FlxG.width / 10 * 8), y: 100}
			],
			[
				{type: "Hornet", x: (FlxG.width / 10 * 3), y: 50},
				{type: "Hornet", x: (FlxG.width / 10 * 5), y: 50},
				{type: "Hornet", x: (FlxG.width / 10 * 7), y: 50},
				{type: "Bee", x: (FlxG.width / 10 * 2), y: 100},
				{type: "Bee", x: (FlxG.width / 10 * 4), y: 100},
				{type: "Bee", x: (FlxG.width / 10 * 6), y: 100},
				{type: "Bee", x: (FlxG.width / 10 * 8), y: 100}
			],
			[
				{type: "Queen", x: (FlxG.width / 10 * 5), y: 10},
				{type: "Hornet", x: (FlxG.width / 10 * 3), y: 50},
				{type: "Hornet", x: (FlxG.width / 10 * 7), y: 50},
				{type: "Bee", x: (FlxG.width / 10 * 1), y: 75},
				{type: "Bee", x: (FlxG.width / 10 * 2), y: 125},
				{type: "Bee", x: (FlxG.width / 10 * 3), y: 75},
				{type: "Bee", x: (FlxG.width / 10 * 4), y: 125},
				{type: "Bee", x: (FlxG.width / 10 * 6), y: 125},
				{type: "Bee", x: (FlxG.width / 10 * 7), y: 75},
				{type: "Bee", x: (FlxG.width / 10 * 8), y: 125},
				{type: "Bee", x: (FlxG.width / 10 * 9), y: 75}
			]
		];
	}

	static function createSaveData():Void
	{
		if (gameSave == null)
		{
			gameSave = new FlxSave();
			// This will create a new save if one doesn't exist,
			// or load the existing save if it's found
			gameSave.bind(SAVE_SLOT);
		}
	}

	/**
	 * Store the score for a given level internally.
	 * @param score 
	 * @param level 
	 */
	public static function recordScore(score:Int, level:Int)
	{
		currentScores[level] = score;
		currentScores[0] = currentScores[1] + currentScores[2] + currentScores[3];

		saveHighScores();
		Newgrounds.postHighscores();
	}

	/**
	 * Save the high scores for all levels in local storage.
	 */
	public static function saveHighScores():Void
	{
		if (gameSave.data.demoHighScores == null || gameSave.data.demoHighScores.length < 4)
		{
			gameSave.data.demoHighScores = [0, 0, 0, 0];
		}

		for (i in 0...currentScores.length)
		{
			if (currentScores[i] > gameSave.data.demoHighScores[i])
			{
				gameSave.data.demoHighScores[i] = currentScores[i];
			}
		}

		trace(gameSave.data);

		gameSave.flush();
	}

	/**
	 * Get the highscore data to display on the title screen.
	 */
	public static function getHighScoreData():String
	{
		createSaveData();

		var result:String = "HIGHSCORES\n";

		if (gameSave.data.demoHighScores[0] != null)
		{
			result += "TOTAL: " + gameSave.data.demoHighScores[0] + "\n";
		}

		if (gameSave.data.demoHighScores[1] != null)
		{
			result += "LEVEL 1: " + gameSave.data.demoHighScores[1] + "\n";
		}

		if (gameSave.data.demoHighScores[2] != null)
		{
			result += "LEVEL 2: " + gameSave.data.demoHighScores[2] + "\n";
		}

		if (gameSave.data.demoHighScores[3] != null)
		{
			result += "LEVEL 3: " + gameSave.data.demoHighScores[3] + "\n";
		}

		return result;
	}

	public static function getCurrentScores():Array<Int>
	{
		return currentScores;
	}

	public static function traceScores():Void
	{
		trace("Current scores: " + currentScores);
		trace("High scores: " + gameSave.data.demoHighScores);
	}
}

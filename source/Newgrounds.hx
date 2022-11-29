package;

import flixel.util.FlxSignal;
import io.newgrounds.NG;
import io.newgrounds.NGLite.LoginOutcome;

class Newgrounds
{
	public static final SCOREBOARDS = [12364, 12365, 12366, 12367];

	public static final MEDALS = [0, 71846, 71847, 71848];

	public static var isLoggedIn(get, never):Bool;

	inline static function get_isLoggedIn()
	{
		return NG.core != null && NG.core.loggedIn;
	}

	public static var isAttemptingLogin(get, never):Bool;

	inline static function get_isAttemptingLogin()
	{
		return NG.core != null && NG.core.attemptingLogin;
	}

	public static var username(get, never):String;

	inline static function get_username()
	{
		if (NG.core != null && NG.core.user != null)
			return NG.core.user.name;
		else
			return null;
	}

	static var _onLogin:FlxSignal = new FlxSignal();

	public static function onLogin(callback:Void->Void):Void
	{
		if (isLoggedIn)
		{
			// Run the callback immediately.
			callback();
		}
		else
		{
			// Postpone the callback for later.
			_onLogin.addOnce(callback);
		}
	}

	public static function init():Void
	{
		trace('Initializing Newgrounds...');

		var debug = #if debug true #else false #end;
		NG.createAndCheckSession(API.NEWGROUNDS_APP_ID, debug, "backupid", onLoginAttempt.bind(_, true));

		// Here, core is initialized, but we don't know if the user is logged in yet.
		NG.core.verbose = true;
	}

	public static function postHighscores()
	{
		onLogin(() ->
		{
			trace('Fetching highscores...');

			var localHighScores = Persistent.getCurrentScores();

			for (index in 0...SCOREBOARDS.length)
			{
				var scoreboardId = SCOREBOARDS[index];
				var localScore = localHighScores[index];

				if (localScore > 0)
					NG.core.scoreBoards.getById(scoreboardId).postScore(localScore);
			}
		});
	}

	public static function awardMedal(medalId:Int)
	{
		onLogin(() ->
		{
			trace('Awarding medal...');

			var medal = NG.core.medals.get(medalId);
			if (!medal.unlocked)
				medal.sendUnlock();
		});
	}

	/**
	 * @param outcome The outcome of the login attempt.
	 * @param initial Whether the attempt is the initial attempt.
	 */
	static function onLoginAttempt(outcome:LoginOutcome, initial:Bool):Void
	{
		switch (outcome)
		{
			case SUCCESS:
				if (initial)
				{
					trace("Logged in without prompting");
				}
				else
				{
					trace("Logged in after prompting");
				}
				onLoginSuccess();
			case FAIL(loginErr):
				switch (loginErr)
				{
					case CANCELLED(type):
						trace('Newgrounds login cancelled: ' + type);
					case ERROR(callErr):
						switch (callErr)
						{
							/** There was an error sending the request or receiving the result. */
							case HTTP(error):
								trace('Newgrounds login HTTP error: ' + error);
							case RESPONSE(error):
								trace('Newgrounds login response error: ' + error);
							case RESULT(error):
								switch (error.code)
								{
									case 104:
										trace('Newground error: Session ID expired');
										if (initial)
										{
											trace('Attempting to log in again...');
											NG.core.requestLogin(onLoginAttempt.bind(_, false));
										}
								}
							default:
								trace('Newgrounds login result error: ' + callErr);
						}
				}
		}
	}

	static function onLoginSuccess()
	{
		trace('Newgrounds login success, setting up...');

		NG.core.setupEncryption(API.NEWGROUNDS_ENCRYPTION_KEY);

		NG.core.medals.loadList();
		NG.core.scoreBoards.loadList();

		trace(NG.core.medals);
		trace(NG.core.scoreBoards);

		_onLogin.dispatch();
	}
}
/*
	trace('Initializing Newgrounds...');

	if (NG.core.loggedIn == false)
	{
		NG.core.requestLogin(function(outcome:LoginOutcome):Void
		{
			if (outcome.match(SUCCESS))
				trace("Logged in after prompting");
			else
				trace('Failed to log in: ' + outcome);
		});
	}

	NG.core.setupEncryption("encryption key", AES_128, BASE_64);


 */

package;

import debug.FPSCounter;
import flixel.FlxGame;
import flixel.FlxG;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.display.StageScaleMode;
import lime.system.System;
import haxe.io.Path;
#if sys
import sys.FileSystem;
#end
import states.TitleState;
import backend.ClientPrefs;
import backend.Highscore;

class Main extends Sprite
{
	public static final game = {
		width: 1280,
		height: 720,
		initialState: TitleState,
		framerate: 60,
		skipSplash: true,
		startFullscreen: false
	};

	public static var fpsVar:FPSCounter;

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		#if mobile
		try
		{
			var storage:String = System.applicationStorageDirectory;
			if (storage != null && storage.length > 0)
			{
				if (!FileSystem.exists(storage))
					FileSystem.createDirectory(storage);
				Sys.setCwd(Path.addTrailingSlash(storage));
			}
		}
		catch (e:Dynamic)
		{
			trace('Storage initialization warning: ' + e);
		}
		#end

		// Загрузка настроек пользователя
		ClientPrefs.loadPrefs();
		Highscore.load();

		addChild(new FlxGame(game.width, game.height, game.initialState, game.framerate, game.framerate, game.skipSplash, game.startFullscreen));

		fpsVar = new FPSCounter(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end
	}
}
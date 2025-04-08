package funkin.ui.title;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import funkin.ui.MusicBeatState;
import lime.app.Application;

#if newgrounds
class OutdatedSubState extends MusicBeatState
{
  public static var leftState:Bool = false;

  override function create()
  {
    super.create();
    var bg:FunkinSprite = new FunkinSprite().makeSolidColor(FlxG.width, FlxG.height, FlxColor.BLACK);
    add(bg);
    var ver = "v" + Application.current.meta.get('version');
    var txt:FlxText = new FlxText(0, 0, FlxG.width,
      "Ay bro, you are using an outdated version of the Guest4242 Engine! "
      + "You are using version "
      + ver
      + " while the most recent version is "
      + NGio.GAME_VER
      + "! Press Space to go to our GitHub, or ESCAPE to ignore this!!",
      32);
    txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
    txt.screenCenter();
    add(txt);
    openfl.Lib.application.window.title = "Friday Night Funkin': Guest4242 Engine (OUTDATED!!)";
  }

  override function update(elapsed:Float)
  {
    if (controls.ACCEPT)
    {
      FlxG.openURL("https://github.com/Guest4242-Inc/FNF-Guest4242Engine/releases");
    }
    if (controls.BACK)
    {
      leftState = true;
      FlxG.switchState(() -> new MainMenuState());
    }
    super.update(elapsed);
  }
}
#end

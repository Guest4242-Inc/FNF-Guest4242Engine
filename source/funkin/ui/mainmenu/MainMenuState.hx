package funkin.ui.mainmenu;

import funkin.graphics.FunkinSprite;
import flixel.addons.transition.FlxTransitionableState;
import funkin.ui.debug.DebugMenuSubState;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.typeLimit.NextState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.touch.FlxTouch;
import flixel.text.FlxText;
import funkin.data.song.SongData.SongMusicData;
import flixel.tweens.FlxEase;
import funkin.graphics.FunkinCamera;
import funkin.audio.FunkinSound;
import flixel.tweens.FlxTween;
import funkin.ui.MusicBeatState;
import flixel.util.FlxTimer;
import funkin.ui.AtlasMenuList;
import funkin.ui.freeplay.FreeplayState;
import funkin.ui.MenuList;
import funkin.ui.title.TitleState;
import funkin.ui.story.StoryMenuState;
import funkin.ui.Prompt;
import funkin.util.WindowUtil;
#if FEATURE_DISCORD_RPC
import funkin.api.discord.DiscordClient;
#end
#if newgrounds
import funkin.ui.NgPrompt;
import io.newgrounds.NG;
#end

class MainMenuState extends MusicBeatState
{
  var menuItems:MenuTypedList<AtlasMenuItem>;

  var magenta:FlxSprite;
  var camFollow:FlxObject;

  var overrideMusic:Bool = false;

  static var rememberedSelectedIndex:Int = 0;

  public function new(?_overrideMusic:Bool = false)
  {
    super();
    overrideMusic = _overrideMusic;
  }

  override function create():Void
  {
    #if FEATURE_DISCORD_RPC
    DiscordClient.instance.setPresence({state: "In the Main Menu", details: null});
    #end

    FlxG.cameras.reset(new FunkinCamera('mainMenu'));

    transIn = FlxTransitionableState.defaultTransIn;
    transOut = FlxTransitionableState.defaultTransOut;

    if (!overrideMusic) playMenuMusic();

    // We want the state to always be able to begin with being able to accept inputs and show the anims of the menu items.
    persistentUpdate = true;
    persistentDraw = true;

    var bg:FlxSprite = new FlxSprite(Paths.image('menuBG'));
    bg.scrollFactor.x = 0;
    bg.scrollFactor.y = 0.17;
    bg.setGraphicSize(Std.int(bg.width * 1.2));
    bg.updateHitbox();
    bg.screenCenter();
    add(bg);

    camFollow = new FlxObject(0, 0, 1, 1);
    add(camFollow);

    magenta = new FlxSprite(Paths.image('menuBGMagenta'));
    magenta.scrollFactor.x = bg.scrollFactor.x;
    magenta.scrollFactor.y = bg.scrollFactor.y;
    magenta.setGraphicSize(Std.int(bg.width));
    magenta.updateHitbox();
    magenta.x = bg.x;
    magenta.y = bg.y;
    magenta.visible = false;

    if (Preferences.flashingLights) add(magenta);

    menuItems = new MenuTypedList<AtlasMenuItem>();
    add(menuItems);
    menuItems.onChange.add(onMenuItemChange);
    menuItems.onAcceptPress.add(function(_) {
      FlxFlicker.flicker(magenta, 1.1, 0.15, false, true);
    });

    menuItems.enabled = true; // can move on intro
    createMenuItem('storymode', 'mainmenu/storymode', function() startExitState(() -> new StoryMenuState()));
    createMenuItem('freeplay', 'mainmenu/freeplay', function() {
      persistentDraw = true;
      persistentUpdate = false;
      // Freeplay has its own custom transition
      FlxTransitionableState.skipNextTransIn = true;
      FlxTransitionableState.skipNextTransOut = true;

      #if FEATURE_DEBUG_FUNCTIONS
      // Debug function: Hold SHIFT when selecting Freeplay to swap character without the char select menu
      var targetCharacter:Null<String> = (FlxG.keys.pressed.SHIFT) ? (FreeplayState.rememberedCharacterId == "pico" ? "bf" : "pico") : null;
      #else
      var targetCharacter:Null<String> = null;
      #end

      openSubState(new FreeplayState(
        {
          character: targetCharacter
        }));
    });

    #if FEATURE_OPEN_URL
    // In order to prevent popup blockers from triggering,
    // we need to open the link as an immediate result of a keypress event,
    // so we can't wait for the flicker animation to complete.
    var hasPopupBlocker = #if web true #else false #end;
    createMenuItem('merch', 'mainmenu/merch', selectMerch, hasPopupBlocker);
    #end

    createMenuItem('options', 'mainmenu/options', function() {
      startExitState(() -> new funkin.ui.options.OptionsState());
    });

    createMenuItem('credits', 'mainmenu/credits', function() {
      startExitState(() -> new funkin.ui.credits.CreditsState());
    });

    // Reset position of menu items.
    var spacing = 160;
    var top = (FlxG.height - (spacing * (menuItems.length - 1))) / 2;
    for (i in 0...menuItems.length)
    {
      var menuItem = menuItems.members[i];
      menuItem.x = FlxG.width / 2;
      menuItem.y = top + spacing * i;
      menuItem.scrollFactor.x = 0.0;
      // This one affects how much the menu items move when you scroll between them.
      menuItem.scrollFactor.y = 0.4;
    }

    menuItems.selectItem(rememberedSelectedIndex);

    resetCamStuff();

    // reset camera when debug menu is closed
    // bc why not?
    subStateClosed.add(_ -> resetCamStuff(false));

    subStateOpened.add(sub -> {
      if (Type.getClass(sub) == FreeplayState)
      {
        new FlxTimer().start(0.5, _ -> {
          magenta.visible = false;
        });
      }
    });

    super.create();

    // This has to come AFTER!
    #if FEATURE_DEBUG_FUNCTIONS
    this.leftWatermarkText.text = 'Guest4242 Engine v0.0.3 Beta 1 [SOME SILLY DEBUG FUNCTIONS ENABLED LOL]';
    #else
    this.leftWatermarkText.text = 'Guest4242 Engine v0.0.3 Beta 1';
    #end
    // ge stands for guest4242 engine
    // b stands for beta
    // a stands for alpha
    this.rightWatermarkText.text = 'Friday Night Funkin\' v0.5.3';
  }

  function playMenuMusic():Void
  {
    FunkinSound.playMusic('freakyMenu',
      {
        overrideExisting: true,
        restartTrack: false,
        // Continue playing this music between states, until a different music track gets played.
        persist: true
      });
  }

  function resetCamStuff(?snap:Bool = true):Void
  {
    FlxG.camera.follow(camFollow, null, 0.06);

    if (snap) FlxG.camera.snapToTarget();
  }

  function createMenuItem(name:String, atlas:String, callback:Void->Void, fireInstantly:Bool = false):Void
  {
    var item = new AtlasMenuItem(name, Paths.getSparrowAtlas(atlas), callback);
    item.fireInstantly = fireInstantly;
    item.ID = menuItems.length;

    item.scrollFactor.set();

    // Set the offset of the item so the sprite is centered on the origin.
    item.centered = true;
    item.changeAnim('idle');

    menuItems.addItem(name, item);
  }

  override function closeSubState():Void
  {
    magenta.visible = false;

    super.closeSubState();
  }

  override function finishTransIn():Void
  {
    super.finishTransIn();
  }

  function onMenuItemChange(selected:MenuListItem)
  {
    camFollow.setPosition(selected.getGraphicMidpoint().x, selected.getGraphicMidpoint().y);
  }

  #if FEATURE_OPEN_URL
  function selectDonate()
  {
    WindowUtil.openURL(Constants.URL_ITCH);
  }

  function selectMerch()
  {
    WindowUtil.openURL(Constants.URL_MERCH);
  }
  #end

  #if newgrounds
  function selectLogin()
  {
    openNgPrompt(NgPrompt.showLogin());
  }

  function selectLogout()
  {
    openNgPrompt(NgPrompt.showLogout());
  }

  function showSavedSessionFailed()
  {
    openNgPrompt(NgPrompt.showSavedSessionFailed());
  }

  public function openNgPrompt(prompt:Prompt, ?onClose:Void->Void)
  {
    var onPromptClose = checkLoginStatus;
    if (onClose != null)
    {
      onPromptClose = function() {
        checkLoginStatus();
        onClose();
      }
    }

    openPrompt(prompt, onPromptClose);
  }

  function checkLoginStatus()
  {
    var prevLoggedIn = menuItems.has("logout");
    if (prevLoggedIn && !NGio.isLoggedIn) menuItems.resetItem("login", "logout", selectLogout);
    else if (!prevLoggedIn && NGio.isLoggedIn) menuItems.resetItem("logout", "login", selectLogin);
  }
  #end

  public function openPrompt(prompt:Prompt, onClose:Void->Void):Void
  {
    menuItems.enabled = false;
    persistentUpdate = false;

    prompt.closeCallback = function() {
      menuItems.enabled = true;
      if (onClose != null) onClose();
    }

    openSubState(prompt);
  }

  function startExitState(state:NextState):Void
  {
    menuItems.enabled = false; // disable for exit
    rememberedSelectedIndex = menuItems.selectedIndex;

    var duration = 0.4;
    menuItems.forEach(function(item) {
      if (menuItems.selectedIndex != item.ID)
      {
        FlxTween.tween(item, {alpha: 0}, duration, {ease: FlxEase.quadOut});
      }
      else
      {
        item.visible = false;
      }
    });

    new FlxTimer().start(duration, function(_) FlxG.switchState(state));
  }

  override function update(elapsed:Float):Void
  {
    super.update(elapsed);

    if (FlxG.onMobile)
    {
      var touch:FlxTouch = FlxG.touches.getFirst();

      if (touch != null)
      {
        for (item in menuItems)
        {
          if (touch.overlaps(item))
          {
            if (menuItems.selectedIndex == item.ID && touch.justPressed) menuItems.accept();
            else
              menuItems.selectItem(item.ID);
          }
        }
      }
    }

    Conductor.instance.update();

    if (controls.DEBUG_MENU)
    {
      persistentUpdate = false;
      FlxG.state.openSubState(new DebugMenuSubState());
    }

    #if FEATURE_DEBUG_FUNCTIONS
    if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.ALT && FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.P)
    {
      FlxG.switchState(() -> new funkin.ui.charSelect.CharacterUnlockState('pico'));
    }

    if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.ALT && FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.W)
    {
      FunkinSound.playOnce(Paths.sound('confirmMenu'));
      funkin.save.Save.instance.setLevelScore('weekend1', 'easy',
        {
          score: 1,
          tallies:
            {
              sick: 0,
              good: 0,
              bad: 0,
              shit: 0,
              missed: 0,
              combo: 0,
              maxCombo: 0,
              totalNotesHit: 0,
              totalNotes: 0,
            }
        });
    }

    if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.ALT && FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.M)
    {
      FunkinSound.playOnce(Paths.sound('confirmMenu'));
      for (diff in ['easy', 'normal', 'hard'])
      {
        funkin.save.Save.instance.setLevelScore('weekend1', diff,
          {
            score: 0,
            tallies:
              {
                sick: 0,
                good: 0,
                bad: 0,
                shit: 0,
                missed: 0,
                combo: 0,
                maxCombo: 0,
                totalNotesHit: 0,
                totalNotes: 0,
              }
          });
      }
    }

    if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.ALT && FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.R)
    {
      funkin.save.Save.instance.setSongScore('tutorial', 'easy',
        {
          score: 1234567,
          tallies:
            {
              sick: 0,
              good: 0,
              bad: 0,
              shit: 1,
              missed: 0,
              combo: 0,
              maxCombo: 0,
              totalNotesHit: 1,
              totalNotes: 10,
            }
        });
    }

    if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.ALT && FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.N)
    {
      @:privateAccess
      {
        funkin.save.Save.instance.data.unlocks.charactersSeen = ["bf"];
        funkin.save.Save.instance.data.unlocks.oldChar = false;
      }
    }

    if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.ALT && FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.E)
    {
      funkin.save.Save.instance.debug_dumpSave();
    }
    #end

    if (FlxG.sound.music != null && FlxG.sound.music.volume < 0.8)
    {
      FlxG.sound.music.volume += 0.5 * elapsed;
    }

    if (_exiting) menuItems.enabled = false;

    if (controls.BACK && menuItems.enabled && !menuItems.busy)
    {
      FlxG.switchState(() -> new TitleState());
      FunkinSound.playOnce(Paths.sound('cancelMenu'));
    }
  }
}

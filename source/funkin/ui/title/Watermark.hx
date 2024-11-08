package funkin.ui.title;

import flixel.FlxG;
import flixel.text.FlxText;

class Watermark extends FlxText {
  public function new(x:Float = 0, y:Float = 0, text:String = "Guest4242 Engine v0.0.1", size:Int = 16) {
    super(x, y, 0, text, size);
    setPosition(x, y);
    alpha = 0.4;
    scrollFactor.set();
  }

  override function draw() {
    if (cameras == null)
      cameras = FlxG.cameras.list;
    super.draw();
  }
}

 package backend;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class MobileControls extends FlxSpriteGroup
{
	public static var instance:MobileControls;

	public static var pressedLeft:Bool = false;
	public static var pressedDown:Bool = false;
	public static var pressedUp:Bool = false;
	public static var pressedRight:Bool = false;

	public static var justPressedA:Bool = false;
	public static var justPressedB:Bool = false;
	public static var justPressedPause:Bool = false;

	// Кнопки по центру (V-Slice Centered Hitbox)
	private var btnLeft:FlxSprite;
	private var btnDown:FlxSprite;
	private var btnUp:FlxSprite;
	private var btnRight:FlxSprite;
	private var btnPause:FlxSprite;

	public function new()
	{
		super();
		instance = this;

		#if mobile
		scrollFactor.set(0, 0);

		// Ширина 4 кнопок ровно по центру экрана под нотами
		var btnWidth:Int = 160; 
		var totalWidth:Int = btnWidth * 4;
		var startX:Float = (FlxG.width - totalWidth) / 2;
		var btnHeight:Int = FlxG.height;

		var colors:Array<FlxColor> = [
			FlxColor.fromRGB(194, 75, 153), // Purple
			FlxColor.fromRGB(0, 255, 255),   // Blue
			FlxColor.fromRGB(18, 250, 5),    // Green
			FlxColor.fromRGB(249, 57, 63)    // Red
		];

		btnLeft  = makeButton(startX, 0, btnWidth, btnHeight, colors[0]);
		btnDown  = makeButton(startX + btnWidth, 0, btnWidth, btnHeight, colors[1]);
		btnUp    = makeButton(startX + btnWidth * 2, 0, btnWidth, btnHeight, colors[2]);
		btnRight = makeButton(startX + btnWidth * 3, 0, btnWidth, btnHeight, colors[3]);

		// Кнопка паузы в верхнем правом углу
		btnPause = new FlxSprite(FlxG.width - 85, 15);
		btnPause.makeGraphic(70, 70, FlxColor.fromRGB(50, 50, 50));
		btnPause.alpha = 0.5;
		add(btnPause);
		#end
	}

	private function makeButton(x:Float, y:Float, w:Int, h:Int, color:FlxColor):FlxSprite
	{
		var btn = new FlxSprite(x, y);
		btn.makeGraphic(w, h, color);
		btn.alpha = 0.12;
		add(btn);
		return btn;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		#if mobile
		pressedLeft = false;
		pressedDown = false;
		pressedUp = false;
		pressedRight = false;
		justPressedPause = false;

		for (touch in FlxG.touches.list)
		{
			if (touch.overlaps(btnLeft))  pressedLeft = true;
			if (touch.overlaps(btnDown))  pressedDown = true;
			if (touch.overlaps(btnUp))    pressedUp = true;
			if (touch.overlaps(btnRight)) pressedRight = true;
			if (touch.justPressed && touch.overlaps(btnPause)) justPressedPause = true;
		}

		btnLeft.alpha  = pressedLeft  ? 0.4 : 0.12;
		btnDown.alpha  = pressedDown  ? 0.4 : 0.12;
		btnUp.alpha    = pressedUp    ? 0.4 : 0.12;
		btnRight.alpha = pressedRight ? 0.4 : 0.12;
		#end
	}
}
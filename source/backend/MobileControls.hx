package backend;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

enum MobileMode
{
	HITBOX;
	DPAD;
}

class MobileControls extends FlxSpriteGroup
{
	public static var pressedLeft:Bool = false;
	public static var pressedDown:Bool = false;
	public static var pressedUp:Bool = false;
	public static var pressedRight:Bool = false;

	public static var justPressedA:Bool = false;
	public static var justPressedB:Bool = false;
	public static var justPressedPause:Bool = false;

	private var currentMode:MobileMode;

	// Кнопки по центру (V-Slice Centered Hitbox)
	private var btnLeft:FlxSprite;
	private var btnDown:FlxSprite;
	private var btnUp:FlxSprite;
	private var btnRight:FlxSprite;
	private var btnPause:FlxSprite;

	// Меню
	private var padUp:FlxSprite;
	private var padDown:FlxSprite;
	private var padLeft:FlxSprite;
	private var padRight:FlxSprite;
	private var btnA:FlxSprite;
	private var btnB:FlxSprite;

	public function new(mode:MobileMode = HITBOX)
	{
		super();
		this.currentMode = mode;

		#if mobile
		scrollFactor.set(0, 0);

		if (mode == HITBOX)
			createCenteredHitbox();
		else
			createDPad();
		#end
	}

	/**
	 * Центрированные кнопки V-Slice прямо под нотами
	 */
	private function createCenteredHitbox():Void
	{
		// Ширина одной кнопки и общая зона по центру экрана
		var btnWidth:Int = 160; 
		var totalWidth:Int = btnWidth * 4; // 640px ровно по центру 1280px экрана
		var startX:Float = (FlxG.width - totalWidth) / 2;
		var btnHeight:Int = FlxG.height;

		// Цвета V-Slice нот
		var colors:Array<FlxColor> = [
			FlxColor.fromRGB(194, 75, 153), // Purple
			FlxColor.fromRGB(0, 255, 255),   // Blue
			FlxColor.fromRGB(18, 250, 5),    // Green
			FlxColor.fromRGB(249, 57, 63)    // Red
		];

		// Создаем 4 вертикальные полосы ровно по центру
		btnLeft  = makeCenteredButton(startX, 0, btnWidth, btnHeight, colors[0]);
		btnDown  = makeCenteredButton(startX + btnWidth, 0, btnWidth, btnHeight, colors[1]);
		btnUp    = makeCenteredButton(startX + btnWidth * 2, 0, btnWidth, btnHeight, colors[2]);
		btnRight = makeCenteredButton(startX + btnWidth * 3, 0, btnWidth, btnHeight, colors[3]);

		// Кнопка паузы в углу экрана
		btnPause = new FlxSprite(FlxG.width - 85, 15);
		btnPause.makeGraphic(70, 70, FlxColor.fromRGB(50, 50, 50));
		btnPause.alpha = 0.5;
		add(btnPause);
	}

	private function makeCenteredButton(x:Float, y:Float, w:Int, h:Int, color:FlxColor):FlxSprite
	{
		var btn = new FlxSprite(x, y);
		btn.makeGraphic(w, h, color);
		btn.alpha = 0.12; // Легкая полупрозрачность в спокойном состоянии
		add(btn);
		return btn;
	}

	private function createDPad():Void
	{
		padLeft  = createVirtualBtn(20, FlxG.height - 160, 80, 80, FlxColor.WHITE);
		padDown  = createVirtualBtn(110, FlxG.height - 160, 80, 80, FlxColor.WHITE);
		padUp    = createVirtualBtn(110, FlxG.height - 250, 80, 80, FlxColor.WHITE);
		padRight = createVirtualBtn(200, FlxG.height - 160, 80, 80, FlxColor.WHITE);

		btnB = createVirtualBtn(FlxG.width - 200, FlxG.height - 160, 85, 85, FlxColor.RED);
		btnA = createVirtualBtn(FlxG.width - 100, FlxG.height - 160, 85, 85, FlxColor.GREEN);
	}

	private function createVirtualBtn(x:Float, y:Float, w:Int, h:Int, color:FlxColor):FlxSprite
	{
		var btn = new FlxSprite(x, y);
		btn.makeGraphic(w, h, color);
		btn.alpha = 0.35;
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
		justPressedA = false;
		justPressedB = false;
		justPressedPause = false;

		for (touch in FlxG.touches.list)
		{
			if (currentMode == HITBOX)
			{
				if (touch.overlaps(btnLeft))  pressedLeft = true;
				if (touch.overlaps(btnDown))  pressedDown = true;
				if (touch.overlaps(btnUp))    pressedUp = true;
				if (touch.overlaps(btnRight)) pressedRight = true;
				if (touch.justPressed && touch.overlaps(btnPause)) justPressedPause = true;
			}
			else
			{
				if (touch.overlaps(padLeft))  pressedLeft = true;
				if (touch.overlaps(padDown))  pressedDown = true;
				if (touch.overlaps(padUp))    pressedUp = true;
				if (touch.overlaps(padRight)) pressedRight = true;
				if (touch.justPressed && touch.overlaps(btnA)) justPressedA = true;
				if (touch.justPressed && touch.overlaps(btnB)) justPressedB = true;
			}
		}

		// Подсветка при нажатии по центру
		if (currentMode == HITBOX)
		{
			btnLeft.alpha  = pressedLeft  ? 0.4 : 0.12;
			btnDown.alpha  = pressedDown  ? 0.4 : 0.12;
			btnUp.alpha    = pressedUp    ? 0.4 : 0.12;
			btnRight.alpha = pressedRight ? 0.4 : 0.12;
		}
		#end
	}
}
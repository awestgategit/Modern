package;

import entities.CenterSquare;
import entities.DisplayedRecentSquares;
import entities.PlayerSquare;
import entities.ShapeObjectSquare;
import entities.SquareRing;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.scaleModes.FillScaleMode;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import Reg;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var scoreText:FlxText;
	private var scoreSquare:FlxSprite; //Square next to score for decorative purposes.
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		bgColor = 0xFFFFFFFF;
		
		FlxG.scaleMode = new FillScaleMode();
		
		#if windows
		FlxG.sound.playMusic("assets/music/Avaren - Depths.ogg", 0.8, true);
		#else
		FlxG.sound.playMusic("assets/music/Avaren - Depths.mp3", 0.8, true);
		#end
		
		FlxG.mouse.useSystemCursor = true;
		
		Reg.score = 0;
		
		Reg.outerRing = new SquareRing(384, 96);
		Reg.outerRing.loadGraphic("assets/images/OuterSquare.png", false, 512, 512);
		
		Reg.midRing = new SquareRing(Reg.outerRing.x + 64, Reg.outerRing.y + 64);
		Reg.midRing.loadGraphic("assets/images/MidSquare.png", false, 384, 384);
		
		Reg.innerRing = new SquareRing(Reg.midRing.x + 64, Reg.midRing.y + 64);
		Reg.innerRing.loadGraphic("assets/images/InnerSquare.png", false, 256, 256);
		
		Reg.centerSquare = new CenterSquare(Reg.innerRing.x + 64, Reg.innerRing.y + 64);
		
		Reg.pSquare1 = new PlayerSquare(Reg.outerRing.x - 32, Reg.outerRing.y + Reg.outerRing.height/2 - 32);
		Reg.pSquare2 = new PlayerSquare(Reg.outerRing.width - 32 + Reg.outerRing.x, Reg.outerRing.y + Reg.outerRing.height / 2 - 32);
		
		Reg.recentSquares = new DisplayedRecentSquares();
		
		scoreText = new FlxText(200, 200, 0, "", 32);
		scoreText.color = 0xFF555555;
		scoreText.font = Reg.theFont;
		
		scoreSquare = new FlxSprite(scoreText.x - 40, scoreText.y - 4);
		scoreSquare.loadGraphic("assets/images/CollectableSquare.png", false, 32, 32);
		scoreSquare.color = 0xFFAEC6CF;
		
		add(Reg.outerRing);
		add(Reg.midRing);
		add(Reg.innerRing);
		add(Reg.centerSquare);
		
		add(Reg.pSquare1);
		add(Reg.pSquare2);
		
		add(scoreText);
		add(scoreSquare);
		
		add(Reg.recentSquares);
		
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		scoreSquare.color = Reg.centerSquare.color;
		scoreText.text = "" + Reg.score;
	}	
}
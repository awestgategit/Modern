package entities;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.util.FlxTimer;

/**
 * Collectible square! Get points!
 * @author SaturnO
 */
class ShapeObjectSquare extends FlxSprite
{
	private var tween:FlxTween;
	private var killTimer:FlxTimer;
	private var killSeconds:Int = 12; //How long it takes for this object to vanish

	//Pos is where it'll be sent to on one of the rings after spawning. Start Color will most likely be equivalent to that of the middle square's color
	public function new(startX:Float,startY:Float,startColor:Int,pos:FlxPoint) 
	{
		super(startX, startY);
		loadGraphic("assets/images/CollectableSquare.png", false, 32, 32);
		this.color = startColor;
		tween = FlxTween.tween(this, { x: pos.x, y:pos.y }, 0.5);
		
		killTimer = new FlxTimer();
		killTimer.start(killSeconds, onKillTimerExpire, 1);
		
		Reg.collectibleSquares.push(this);
		
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		checkTriangleOverlap();
		
		if (FlxG.collide(Reg.pSquare1, this) || FlxG.collide(Reg.pSquare2, this))
		{
			Reg.recentSquares.addRecentSquare(this.color);
			this.kill();
			Reg.score += 1;
		}
	}
	
	private function onKillTimerExpire(timer:FlxTimer):Void
	{
		this.kill();
	}
	
	//function to check if this overlaps with triangles
	private function checkTriangleOverlap():Void
	{
		for (i in 0 ... Reg.triangles.length)
		{
			if (FlxG.overlap(this, Reg.triangles[i]))
			{
				this.kill();
			}
		}
	}
}
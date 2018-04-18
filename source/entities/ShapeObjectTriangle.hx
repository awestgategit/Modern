package entities;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.util.FlxTimer;

/**
 * Dangerous triangle. Beware.
 */
class ShapeObjectTriangle extends FlxSprite
{
	private var tween:FlxTween;
	private var killTimer:FlxTimer;
	private var killSeconds:Int = 12; //How long it takes for this object to vanish
	private var playerKillEnable:Bool = false; //When this is true it mean the player will die upon collision. Used to prevent the player dying when the triangle is still launching out.

	//Pos is where it'll be sent to on one of the rings after spawning. Start Color will most likely be equivalent to that of the middle square's color
	public function new(startX:Float,startY:Float,startColor:Int,pos:FlxPoint) 
	{
		super(startX, startY);
		loadGraphic("assets/images/Triangle.png", false, 32, 32);
		this.color = startColor;
		tween = FlxTween.tween(this, { x: pos.x, y:pos.y }, 0.5, { onComplete: onFinishMoving } );
		
		this.solid = true;
		
		killTimer = new FlxTimer();
		killTimer.start(killSeconds, onKillTimerExpire, 1);
		
		Reg.triangles.push(this);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		//death behavior
		if (FlxG.collide(Reg.pSquare1, this) || FlxG.collide(Reg.pSquare2, this) && playerKillEnable)
		{
			Reg.onDeath();
		}
	}
	
	private function onKillTimerExpire(timer:FlxTimer):Void
	{
		this.kill();
	}
	
	private function onFinishMoving(tween:FlxTween):Void
	{
		this.playerKillEnable = true;
	}
}

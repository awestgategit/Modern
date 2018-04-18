package entities;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * Square displayed on the right that symbolizes a recently collected square.
 */
class RecentSquare extends FlxSprite
{
	private var hidden:Bool = true;

	public function new(startX:Float,startY:Float,startColor:Int)  
	{
		super(startX, startY);
		loadGraphic("assets/images/CollectableSquare.png", false, 32, 32);
		this.color = startColor;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (this.hidden)
		{
			this.alpha = 0;
		}
		else
		{
			this.alpha = 1;
		}
	}
	
	public function toggleHidden():Void
	{
		if (this.hidden)
		{
			this.hidden = false;
		}
		else
		{
			this.hidden = true;
		}
	}
}

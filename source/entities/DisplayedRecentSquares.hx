package entities;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;

/**
 * 16 Squares displayed next to the rings. They represent recently collected squares. When 16 are collected an effect will happen based on majority color.
 */
class DisplayedRecentSquares extends FlxTypedGroup<RecentSquare>
{
	private var current:Int = 0;
	
	private var redCount:Int = 0; //Counts for the four square types. Each will have an individual gameplay effect.
	private var blueCount:Int = 0;
	private var greenCount:Int = 0;
	private var yellowCount:Int = 0;

	public function new() 
	{
		super();
		
		for (i in 0 ... 4)
		{
			for (j in 0 ... 4)
			{
				this.add(new RecentSquare(1000 + j * 32, 256 + i * 32,Reg.BLUE));
			}
		}
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	//Used for 'adding' a displayed recent square when a new square is picked up. squareColor is the color to set the displayed RecentSquare
	public function addRecentSquare(squareColor:Int):Void
	{
		if (squareColor == Reg.BLUE)
		{
			blueCount += 1;
		}
		else if (squareColor == Reg.RED)
		{
			redCount += 1;
		}
		else if (squareColor == Reg.YELLOW)
		{
			yellowCount += 1;
		}
		else if (squareColor == Reg.GREEN)
		{
			greenCount += 1;
		}
		
		this.members[current].toggleHidden();
		this.members[current].color = squareColor;
		current += 1;
		
		if (current > 15)
		{
			this.activateSquareEffect();
		}
	}
	
	//Effects that occur when 16 squares are grabbed.
	private function activateSquareEffect():Void
	{
		this.current = 0;
		
		var colorMax:Float = Math.max(Math.max(redCount, blueCount), Math.max(yellowCount, greenCount));
		var setColor:Int = 0;
		
		if (colorMax == redCount)
		{
			setColor = Reg.RED;
		}
		else if (colorMax == blueCount)
		{
			setColor = Reg.BLUE;
		}
		else if (colorMax == greenCount)
		{
			setColor = Reg.GREEN;
		}
		else if (colorMax == yellowCount)
		{
			setColor = Reg.YELLOW;
		}
		
		Reg.pSquare1.color = Reg.pSquare2.color = setColor;
		for (x in this.members)
		{
			FlxTween.color(x, 1, x.color, setColor);
		}
		/*for (x in this.members)
		{
			x.toggleHidden();
		}*/
		
		redCount = blueCount = yellowCount = greenCount = 0;
	}
	
}

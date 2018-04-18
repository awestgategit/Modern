package entities;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.FlxG;
import flixel.util.FlxTimer;

/**
 * ...
 * @author SaturnO
 */
class CenterSquare extends FlxSprite
{
	private var tween:FlxTween;
	private var spawnTimer:FlxTimer;
	private var objectSpawnBaseTime:Int = 4; //Initial spawn time
	private var objectSpawnTime:Float = 4; //Amount of time for the square to rotate, change color and spawn new objects.
	private var timeSpeedMod:Float = 0.0; //Modifier to adjust spawn time based on game score. See: SpeedBehavior()
	
	private var squareCounter:Int = 0; //Variables for counting which shape spawns occur. These limit how many can be spawned in a row.
	private var triangleCounter:Int = 0;

	public function new(x:Float,y:Float) 
	{
		super(x, y);
		loadGraphic("assets/images/CenterSquare.png", false, 128, 128);
		this.color = Reg.BLUE;
		
		//Rotation animation thingy
		tween = FlxTween.angle(this, 0, 180, 1, { type:FlxTween.PINGPONG, ease:FlxEase.quadInOut, onComplete:onRotate } );
		tween.startDelay = tween.loopDelay = objectSpawnTime;
		
		//Pastels: Gray: CFCFC4 Green: 77DD77 Blue: AEC6CF Pink/Red: DEA5A4 Yellow: FDFD96 Purple: B39EB5 ... http://colors.findthedata.com/saved_search/Pastel-Colors
		
		spawnTimer = new FlxTimer();
		spawnTimer.start(objectSpawnTime, spawnInterval, 0);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		//Thing for spawning squares as like a debug type thing
		/*if (FlxG.mouse.justPressed)
		{
			spawnShapeObject("square");
		}*/
		
		speedBehavior();
	}
	
	private function onRotate(tween:FlxTween):Void
	{
		this.angle = 0;
		var randomColor:Int = 0;
		randomColor = FlxG.random.int(1, 4);
		
		switch (randomColor)
		{
			case 1:
				this.color = Reg.BLUE;
			case 2:
				this.color = Reg.RED;
			case 3:
				this.color = Reg.YELLOW;
			case 4:
				this.color = Reg.GREEN;
		}
		
	}
	
	//Creates the coordinates of a spawned object
	private function makeSpawnObjectCoords():FlxPoint
	{
		var ring:Int = 0; //0 = outer, 1 = middle, 2 = inner ... assuming theres 3 rings, note the variables ringmin and ringmax
		var side:Int = 0; //0 = right, 1 = top, 2 = left, 3 = bottom
		
		//Pick a ring and side to place a new object on
		ring = FlxG.random.int(Reg.ringMin, Reg.ringMax);
		side = FlxG.random.int(0, 3);
		
		var spawnPos:FlxPoint = new FlxPoint(0, 0);
		
		//Make random coordinates to spawn the object at
		switch(side)
		{
			//right
			case 0:
				spawnPos.x = Reg.outerRing.width + Reg.outerRing.x - 16 - (ring * 64);
				spawnPos.y = Reg.outerRing.y + FlxG.random.int(Math.round((64 * ring)) , Math.round(Reg.outerRing.height - (64 * ring)));
			//top
			case 1:
				spawnPos.x = Reg.outerRing.x + FlxG.random.int(Math.round((64 * ring)) , Math.round(Reg.outerRing.width - (64 * ring)));
				spawnPos.y = Reg.outerRing.y + (ring * 64) - 16;
			//left
			case 2:
				spawnPos.x = Reg.outerRing.x + (64 * ring) - 16;
				spawnPos.y = Reg.outerRing.y + FlxG.random.int(Math.round((64 * ring)), Math.round(Reg.outerRing.height - (64 * ring)));
			//bottom
			case 3:
				spawnPos.x = Reg.outerRing.x + FlxG.random.int(Math.round((64 * ring)) , Math.round(Reg.outerRing.width - (64 * ring)));
				spawnPos.y = Reg.outerRing.y + Reg.outerRing.height - (ring * 64) - 16;
		}
		return spawnPos;
	}
	
	//Function that handles the spawning of an individual shape
	private function spawnShapeObject(shape:String)
	{
		if (shape == "square")
		{
			FlxG.state.add(new ShapeObjectSquare(this.x + this.width / 2, this.y + this.height / 2, this.color, makeSpawnObjectCoords()));
		}
		else if(shape == "triangle")
		{
			FlxG.state.add(new ShapeObjectTriangle(this.x + this.width / 2, this.y + this.height / 2, this.color, makeSpawnObjectCoords()));
		}
	}
	
	//Function that spawns a bunch of objects en masse when the timer expires.
	private function spawnInterval(timer:FlxTimer)
	{
		var range:Int = 0;
		
		range = FlxG.random.int(1, 4);
		
		//These counter if statements are just so there aren't too many of one shape on a board. Prevents too many being spawned in order.
		if (triangleCounter >= 3)
		{
			spawnShapeObject("square");
			triangleCounter = 0;
			return;
		}
		else if (squareCounter >= 4)
		{
			spawnShapeObject("triangle");
			squareCounter = 0;
			return;
		}
		
		if (FlxG.random.bool(70))
		{
			for (i in 0 ... range)
			{
				spawnShapeObject("square");
			}
			squareCounter += 1;
			triangleCounter = 0;
		}
		else
		{
			for (i in 0 ... range)
			{
				spawnShapeObject("triangle");
			}
			squareCounter = 0;
			triangleCounter += 1;
		}
		
		spawnTimer.reset(objectSpawnTime);

	}
	
		//handles the speed of the game as the score increases
		private function speedBehavior():Void
		{
			if (Reg.score % 16 == 0)
			{
				timeSpeedMod = (Reg.score / 16) / 4;  //Time decreases by .25 per 16 squares
			}
			
			if (objectSpawnTime <= 2)
			{
				objectSpawnTime = 2;
			}
			else
			{
				objectSpawnTime = objectSpawnBaseTime - timeSpeedMod;
			}
		}
		
		public function resetSpawnTime():Void
		{
			objectSpawnTime = objectSpawnBaseTime;
		}
	
}
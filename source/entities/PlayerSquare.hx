package entities;
import flixel.FlxSprite;
import flixel.FlxG;

/**
 * ...
 * @author SaturnO
 */
class PlayerSquare extends FlxSprite
{
	private var direction:String = "forward";
	private var side:String = "right"; //Side of the square the player-square is on
	
	private var baseSpeed:Int = 192;//Base Speed
	public var speed:Float = 192;//Active speed
	private var speedMod:Float = 0; //Modifies the speed as the game goes on.
	private var speedMax:Int = 384; //Speed can't exceed this.
	
	public var ring:Int = 0; //0 for outer, 1 for mid, 2 for inner

	public function new(x:Float,y:Float) 
	{
		super(x, y);
		loadGraphic("assets/images/PlayerSquare.png", false, 64, 64);
		
		this.immovable = true;
		
		this.color = Reg.BLUE;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		this.velocity.y = 0;
		this.velocity.x = 0;
		
		//ring limits
		if (ring >= Reg.ringMax)
		{
			ring = Reg.ringMax;
		}
		if (ring <= Reg.ringMin)
		{
			ring = Reg.ringMin;
		}
		
		if (FlxG.keys.anyJustPressed(["DOWN","LEFT", "UP", "RIGHT"]))
		{
			
			if (this.direction == "backward")
			{
				this.direction = "forward";
			}
			else
			{
				this.direction = "backward";
			}
		}
		
		if (FlxG.keys.anyJustPressed(["W", "D"]) && ring != Reg.ringMin)
		{
			ring -= 1;
			
			if (ring >= Reg.ringMin)
			{
				ringMoveUp();
			}
		}
		
		if (FlxG.keys.anyJustPressed(["S", "A"]) && ring != Reg.ringMax )
		{
			ring += 1;
			
			if (ring <= Reg.ringMax)
			{
				ringMoveDown();	
			}
		}
		
		speedBehavior();
		
		movementBehavior();

		}
		///////////////////////////////////////////////////////////////////////////////////
		
		//Movement when A/S is pressed.
		private function ringMoveDown():Void
		{
			
			if (side == "right")
			{
				this.x -= 64;
			}
			else if (side == "left")
			{
				this.x += 64;
			}
			else if (side == "top")
			{
				this.y += 64;
			}
			else if (side == "bottom")
			{
				this.y -= 64;
			}
			
		}
		
		//Movement when W/D is pressed
		private function ringMoveUp():Void
		{
			if (side == "right")
			{
				this.x += 64;
			}
			else if (side == "left")
			{
				this.x -= 64;
			}
			else if (side == "top")
			{
				this.y -= 64;
			}
			else if (side == "bottom")
			{
				this.y += 64;
			}
		}
		
		//Does what it says
		private function movementBehavior():Void
		{
		//movement boundary/turn settings
		if (this.direction == "forward")
		{
			//Movement on the right side, upward
			if (this.x >= Reg.outerRing.x + Reg.outerRing.width - 32 - (64 * ring) && this.y > Reg.outerRing.y - 32 + (64 * ring) && this.velocity.x == 0)
			{
				this.velocity.y = -1 * speed;
				side = "right";
			}
			//Movement on the top, leftward
			if (this.y <= Reg.outerRing.y - 32 + (64 * ring) && this.x > Reg.outerRing.x - 32 + (64 * ring) && this.velocity.y == 0)
			{
				this.velocity.x = -1 * speed;
				side = "top";
			}
			//Movement on the bottom, rightward
			if (this.y >= Reg.outerRing.y + Reg.outerRing.height - 32 - (64 * ring) && this.x < Reg.outerRing.x + Reg.outerRing.width - 32 - (64 * ring) && this.velocity.y == 0)
			{
				this.velocity.x = 1 * speed;
				side = "bottom";
			}
			//Movement on the left, downward
			if (this.x <= Reg.outerRing.x - 32 + (64 * ring) && this.y < Reg.outerRing.y + Reg.outerRing.height - (64 * ring) && this.velocity.x == 0)
			{
				this.velocity.y = 1 * speed;
				side = "left";
			}
		}
		else if (this.direction == "backward")
		{
			//Movement on the right side, downward
			if (this.x >= Reg.outerRing.x + Reg.outerRing.width - 32 - (64 * ring) && this.y < Reg.outerRing.y + Reg.outerRing.height - 32 - (64 * ring) && this.velocity.x == 0)
			{
				this.velocity.y = 1 * speed;
				side = "right";
			}
			//Movement on the bottom, leftward
			if (this.y >= Reg.outerRing.y + Reg.outerRing.height - 32 - (64 * ring) && this.x > Reg.outerRing.x - 32 + (64 * ring) && this.velocity.y == 0)
			{
				this.velocity.x = -1 * speed;
				side = "bottom";
			}
			//Movement on the top, rightward
			if (this.y <= Reg.outerRing.y - 32 + (64 * ring) && this.x < Reg.outerRing.x + Reg.outerRing.width - 32 - (64 * ring) && this.velocity.y == 0)
			{
				this.velocity.x = 1 * speed;
				side = "top";
			}
			//Movement on the left, upward
			if (this.x <= Reg.outerRing.x - 32 + (64 * ring) && this.y > Reg.outerRing.y - 32 + (64 * ring) && this.velocity.x == 0)
			{
				this.velocity.y = -1 * speed;
				side = "left";
			}
		}
		}
		
		//Speed increases by 12.5% for every 16 points
		private function speedBehavior():Void
		{
			if (Reg.score % 16 == 0)
			{
				speedMod = (Reg.score / 16) / 8;
			}
			
			if (speed >= speedMax)
			{
				speed = speedMax;
			}
			else
			{
				speed = Math.round(baseSpeed * (1 + speedMod));
			}
		}
		
		//Used to reset or otherwise change speed. Be SURE to keep this consistent with the other speed variables if playing around with this.
		public function resetSpeed():Void
		{
			speed = baseSpeed;
		}


	}
	
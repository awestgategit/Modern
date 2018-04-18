package;

import entities.CenterSquare;
import entities.DisplayedRecentSquares;
import entities.PlayerSquare;
import entities.SquareRing;
import flixel.util.FlxSave;
import flixel.FlxG;
import entities.ShapeObjectSquare;
import entities.ShapeObjectTriangle;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	
	//The rings!
	public static var outerRing:SquareRing;
	public static var midRing:SquareRing;
	public static var innerRing:SquareRing;
	
	//Square in the center
	public static var centerSquare:CenterSquare;
	
	//Player controlled squares
	public static var pSquare1:PlayerSquare;
	public static var pSquare2:PlayerSquare;
	
	//Score, how many squares the player collected
	public static var score:Int = 0;
	
	//Arrays to store squares and triangles on the board. This is to prevent things like overlap.
	public static var collectibleSquares:Array<ShapeObjectSquare> = [];
	public static var triangles:Array<ShapeObjectTriangle> = [];
	
	//Color constants
	
	public static var BLUE:Int = 0xFFAEC6CF;
	public static var RED:Int = 0xFFDEA5A4;
	public static var YELLOW:Int = 0xFFFDFD96;
	public static var GREEN:Int = 0xFF77DD77;
	
	//Array of 16 squares recently collected. Used for effects that occur when 16 have been grabbed.
	public static var recentSquares:DisplayedRecentSquares;
	
	public static var ringMax:Int = 2; //Max/Min number of rings. In case I wanna add more later... maybe. Note: this'll take reworking of the movementBehavior function
	public static var ringMin:Int = 0;
	
	public static var theFont:String = "assets/data/Squared Display.ttf";
	
	//Function that activates when the player dies
	public static function onDeath():Void
	{
		FlxG.resetState();
		
		pSquare1.resetSpeed();
		pSquare2.resetSpeed();
		
		centerSquare.resetSpawnTime();
	}
}
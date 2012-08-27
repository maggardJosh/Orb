package com.lionsteel.LD24.BodyTypes 
{
	import com.lionsteel.LD24.GFX;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Josh Maggard
	 */

	
	public class TailType
	{
		public static const NONE:int = -1;
		public static const SCORPION:int = 0;
		public static const MONKEY:int = 1;
		
		public static const NUM_TAILS:int = 2;
		
		public static var KILL_COUNT:Array = new Array();		//Number of kills needed to get this
		public static var KILL_IMAGES:Array = new Array();
		public static var KILL_COLOR_IMAGES:Array = new Array();
		public static var IMAGE:Array = new Array();
		
		public static function init():void
		{
			KILL_IMAGES[SCORPION] = new Image(GFX.TAIL_SCORPION_COUNT);
			KILL_IMAGES[SCORPION].alpha = .2;
			KILL_COUNT[SCORPION] = 4;
			KILL_COLOR_IMAGES[SCORPION] = GFX.TAIL_SCORPION_COUNT_COLOR;
			IMAGE[SCORPION] = new Image(GFX.TAIL_SCORPION_COUNT_COLOR);
			
				KILL_IMAGES[MONKEY] = new Image(GFX.TAIL_MONKEY_COUNT);
			KILL_IMAGES[MONKEY].alpha = .2;
			KILL_COUNT[MONKEY] = 4;
			KILL_COLOR_IMAGES[MONKEY] = GFX.TAIL_MONKEY_COUNT_COLOR;
			IMAGE[MONKEY] = new Image(GFX.TAIL_MONKEY_COUNT_COLOR);
		}
	}
	

}
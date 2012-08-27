package com.lionsteel.LD24.BodyTypes 
{
	import com.lionsteel.LD24.GFX;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Josh Maggard
	 */
	public class HornType
	{
		public static const NONE:int = -1;
		public static const SPIKE:int = 0;
		public static const PLANT:int = 1;
		
		public static const NUM_HORNS:int = 2;
		
		public static var KILL_COUNT:Array = new Array();		//Number of kills needed to get this
		public static var KILL_IMAGES:Array = new Array();
		public static var KILL_COLOR_IMAGES:Array = new Array();
		public static var IMAGE:Array = new Array();
		
		public static function init():void
		{
			KILL_IMAGES[SPIKE] = new Image(GFX.HORN_SPIKE_COUNT);
			KILL_IMAGES[SPIKE].alpha = .2;
			KILL_COUNT[SPIKE] = 5;
			KILL_COLOR_IMAGES[SPIKE] = GFX.HORN_SPIKE_COUNT_COLOR;
			IMAGE[SPIKE] = new Image(GFX.HORN_SPIKE_COUNT_COLOR);
			
			KILL_IMAGES[PLANT] = new Image(GFX.HORN_PLANT_COUNT);
			KILL_IMAGES[PLANT].alpha = .2;
			KILL_COUNT[PLANT] = 5;
			KILL_COLOR_IMAGES[PLANT] = GFX.HORN_PLANT_COUNT_COLOR;
			IMAGE[PLANT] = new Image(GFX.HORN_PLANT_COUNT_COLOR);
		}
	}
}
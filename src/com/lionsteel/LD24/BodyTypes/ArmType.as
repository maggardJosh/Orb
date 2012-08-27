package com.lionsteel.LD24.BodyTypes 
{
	import com.lionsteel.LD24.GFX;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Josh Maggard
	 */
	public class ArmType
	{
		public static const NONE:int = -1;
		public static const BASE:int = 0;
		public static const CLAW:int = 1;
		
		public static const NUM_ARMS:int = 2;
		
		public static var KILL_COUNT:Array = new Array();		//Number of kills needed to get this
		public static var KILL_IMAGES:Array = new Array();
		public static var KILL_COLOR_IMAGES:Array = new Array();
		public static var IMAGE:Array = new Array();
		
		public static function init():void
		{
			KILL_IMAGES[BASE] = new Image(GFX.ARM_BASE_COUNT);
			KILL_IMAGES[BASE].alpha = .4;
			KILL_COUNT[BASE] = 4;
			KILL_COLOR_IMAGES[BASE] = GFX.ARM_BASE_COUNT_COLOR;
			IMAGE[BASE] = new Image(GFX.ARM_BASE_COUNT_COLOR);
			
			KILL_IMAGES[CLAW] = new Image(GFX.ARM_CLAW_COUNT);
			KILL_IMAGES[CLAW].alpha = .4;
			KILL_COUNT[CLAW] = 3;
			KILL_COLOR_IMAGES[CLAW] = GFX.ARM_CLAW_COUNT_COLOR;
			IMAGE[CLAW] = new Image(GFX.ARM_CLAW_COUNT_COLOR);
		}
	}

}
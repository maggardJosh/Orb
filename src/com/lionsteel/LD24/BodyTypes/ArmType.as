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
		
		public static var KILL_COUNT:Array = new Array();		//Number of kills needed to get this
		public static var KILL_IMAGES:Array = new Array();
		public static var KILL_COLOR_IMAGES:Array = new Array();
		
		public static var IMAGE:Array = new Array();
		public static function init():void
		{
			KILL_IMAGES[BASE] = new Image(GFX.ARM_BASE_COUNT);
			KILL_IMAGES[BASE].alpha = .4;
			KILL_COUNT[BASE] = 8;
			KILL_COLOR_IMAGES[BASE] = GFX.ARM_BASE_COUNT_COLOR;
			IMAGE[BASE] = new Image(GFX.ARM_BASE_COUNT_COLOR);
		}
	}

}
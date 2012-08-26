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
		
		
		public static var KILL_COUNT:Array = new Array();		//Number of kills needed to get this
		public static var KILL_IMAGES:Array = new Array();
		public static var KILL_COLOR_IMAGES:Array = new Array();
		
		public static function init():void
		{
			KILL_IMAGES[SPIKE] = new Image(GFX.HORN_SPIKE_COUNT);
			KILL_IMAGES[SPIKE].alpha = .2;
			KILL_COUNT[SPIKE] = 3;
			KILL_COLOR_IMAGES[SPIKE] = GFX.HORN_SPIKE_COUNT_COLOR;
		}
	}
}
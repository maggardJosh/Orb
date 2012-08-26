package com.lionsteel.LD24.BodyTypes 
{
	import com.lionsteel.LD24.C;
	import com.lionsteel.LD24.GFX;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Josh Maggard
	 */
	public class WingType
	{
		public static const NONE:int = -1;
		public static const BAT:int = 0;
		
		public static var KILL_COUNT:Array = new Array();		//Number of kills needed to get this
		public static var KILL_IMAGES:Array = new Array();
		public static var KILL_COLOR_IMAGES:Array = new Array();
		
		public static var IMAGE:Array = new Array();
		public static function init():void
		{
			KILL_IMAGES[BAT] = new Image(GFX.WING_BAT_COUNT);
			KILL_IMAGES[BAT].alpha = .2;
			KILL_COUNT[BAT] = 3;
			KILL_COLOR_IMAGES[BAT] = GFX.WING_BAT_COUNT_COLOR;
			IMAGE[BAT] = new Image(GFX.WING_BAT_COUNT_COLOR);
		}
		
		//Return the height the player should be off the ground
		// with the passed type of wing
		public static function wingHeight(typeOfWing:int):int
		{
			switch(typeOfWing)
			{
				case WingType.BAT:
					return 40;
				default:
					trace("Wing type " + typeOfWing + " not found");
					return C.TILE_SIZE;
			}
		}
	}


}
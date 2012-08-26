package com.lionsteel.LD24.BodyTypes 
{
	import com.lionsteel.LD24.C;
	import com.lionsteel.LD24.GFX;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Josh Maggard
	 */
	public class LegType
	{
		public static const NONE:int = -1;
		public static const BASE:int = 0;
		public static const SPIDER:int = 1;
		
		
		public static var KILL_COUNT:Array = new Array();		//Number of kills needed to get this
		public static var KILL_IMAGES:Array = new Array();
		public static var KILL_COLOR_IMAGES:Array = new Array();
		
		public static var IMAGE:Array = new Array();
		
		public static function init():void
		{
			KILL_IMAGES[SPIDER] = new Image(GFX.LEG_SPIDER_COUNT);
			KILL_IMAGES[SPIDER].alpha = .2;
			KILL_COUNT[SPIDER] = 3;
			KILL_COLOR_IMAGES[SPIDER] = GFX.LEG_SPIDER_COUNT_COLOR;
			IMAGE[SPIDER] = new Image(GFX.LEG_SPIDER_COUNT_COLOR);
		}
		
		//Returns the height the player should be off the ground
		// Given the type of leg
		public static function legHeight(typeOfLeg:int):int
		{
			switch(typeOfLeg)
			{
				case LegType.BASE:
					return 50;
				case LegType.SPIDER:
					return 50;
				default:
					trace("Leg type " + typeOfLeg + " not found");
					return C.TILE_SIZE;
			}
			
		}
	}

}
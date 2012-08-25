package com.lionsteel.LD24.BodyTypes 
{
	import com.lionsteel.LD24.C;
	/**
	 * ...
	 * @author Josh Maggard
	 */
	public class LegType
	{
		public static const NONE:int = -1;
		public static const BASE:int = 0;
		public static const SPIDER:int = 1;
		
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
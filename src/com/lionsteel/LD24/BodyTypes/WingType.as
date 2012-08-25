package com.lionsteel.LD24.BodyTypes 
{
	import com.lionsteel.LD24.C;
	/**
	 * ...
	 * @author Josh Maggard
	 */
	public class WingType
	{
		public static const NONE:int = -1;
		public static const BASE:int = 0;
		
		//Return the height the player should be off the ground
		// with the passed type of wing
		public static function wingHeight(typeOfWing:int):int
		{
			switch(typeOfWing)
			{
				case WingType.BASE:
					return 40;
				default:
					trace("Wing type " + typeOfWing + " not found");
					return C.TILE_SIZE;
			}
		}
	}


}
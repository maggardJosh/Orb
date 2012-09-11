package com.lionsteel.LD24 
{
	import flash.geom.Point;
	/**
	 * Constants
	 * @author Josh Maggard
	 */
	public class C 
	{
		public static const TILE_SIZE:int = 32;
		public static const FRAMES_PER_SECOND:int = 60;									//Frames per second NOTE: IF YOU CHANGE THIS YOU HAVE TO CHANGE THE META DATA IN MAIN!!!!!!
		public static const MILLI_PER_FRAME:int = 1000 / FRAMES_PER_SECOND;				//Milliseconds per frame (Used for counters)
		
		public static const GRAVITY:Number = .8;
		public static const START_MAX_Y_VEL:Number = 10;
		public static const START_PLAYER_SPEED:Number = .8;
		public static const START_ENEMY_SPEED:Number = .1;
		public static const INVULNERABLE_COUNT:int = 1000;
		
		public static const ARM_MELEE_COOLDOWN:int = 800;
		public static const TAIL_MELEE_COOLDOWN:int = 800;
		
		public static const START_HEALTH:int = 3;		//Number of hearts the player starts out with
		
		public static const MAX_VEL_X:Number = 4;
		public static const MAX_VEL_Y:Number = 17;
		
		
	}

}
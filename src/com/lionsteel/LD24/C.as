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
		public static const GRAVITY:Number = .8;
		public static const START_MAX_Y_VEL:Number = 10;
		public static const START_PLAYER_SPEED:Number = .8;
		public static const START_ENEMY_SPEED:Number = .1;
		public static const INVULNERABLE_COUNT:int = 1000;
		
		public static const ARM_MELEE_COOLDOWN:int = 800;
		public static const TAIL_MELEE_COOLDOWN:int = 800;
		
		public static const MAX_VEL_X:Number = 4;
		public static const MAX_VEL_Y:Number = 17;
		
		public static const ATTACK_COUNT:int = 100;
		
		public static const KILL_COUNT_START_X:int = 30 * 6;
		public static const KILL_X_SPACING:int = 60;
		
		public static const TRAIT_HOLDER_POS:Point = new Point( -12, 90);
		
		public static const LEG_POWERUP_POS:Point = new Point(10, 10).add(TRAIT_HOLDER_POS);
		public static const ARM_POWERUP_POS:Point = new Point(0, 60).add(LEG_POWERUP_POS);
		public static const HORN_POWERUP_POS:Point = new Point(0, 60).add(ARM_POWERUP_POS);
		public static const TAIL_POWERUP_POS:Point = new Point(0, 60).add(HORN_POWERUP_POS);
		
		public static const WING_POWERUP_POS:Point = new Point(0, 60).add(TAIL_POWERUP_POS);
		
		
	}

}
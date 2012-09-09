package com.lionsteel.LD24.BodyTypes 
{
	import com.lionsteel.LD24.GFX;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Josh Maggard
	 */
	public class ArmType
	{
		public static const NONE:int = -1;
		public static const BASE:int = 0;
		public static const CLAW:int = 1;
		
		public static const NUM_PARTS:int = 2;
		
		public static var TRAIT_POINT_COUNT:Array = new Array();				//Number of trait points needed to get this
		public static var GREYSCALE_IMAGE:Array = new Array();		//Black and white image of this
		public static var IMAGE:Array = new Array();							//Image of this part (no animation)
		
		public static var DAMAGE:Array = new Array();						//Damage this part does
		public static var SPEED_VAR:Array = new Array();					//Speed variables for each arm type
		public static var JUMP_FORCE_VAR:Array = new Array();		//Monster's jump force is multiplied by this before jumping.
		
		public static function getFrontAnim(type:int):Spritemap
		{
			var animSheet:Spritemap;
			switch(type)
			{
				case NONE:
					animSheet = new Spritemap(GFX.BLANK_IMAGE);
				break;
				case BASE:
					animSheet = new Spritemap(GFX.ARM_BASE_FRONT_ANIM, 100, 80);
					with (animSheet)
					{
						add("idle",[0] ,.1, true);
						add("walk", [4,5,6,7], .1, true);
						add("jump", [8], .1, true);
						add("fall", [12], .1, true);
						add("meleeStart", [16], .7, false);
						add("melee", [16,17,18,19,19,19],.3, false);
						add("range", [20], .1, true);
						add("crouch", [24], .1, true);
						add("birth", [28], .1, true);
					}
				break;
				case CLAW:
						animSheet = new Spritemap(GFX.ARM_CLAW_FRONT_ANIM, 100, 80);
						with (animSheet)
						{
							add("idle",[0] ,.1, true);
							add("walk", [4,5,6,7], .1, true);
							add("jump", [8], .1, true);
							add("fall", [12], .1, true);
							add("meleeStart", [16], .7, false);
							add("melee", [16,17,18,19,19,19],.3, false);
							add("range", [0], .1, true);
							add("crouch", [0], .1, true);
							add("birth", [0], .1, true);
						}
				break;		
			}
			return animSheet;
		}
		
		public static function getBackAnim(type:int):Spritemap
		{
			var animSheet:Spritemap;
			switch(type)
			{
				case NONE:
					animSheet = new Spritemap(GFX.BLANK_IMAGE);
					break;
				case BASE:
					animSheet = new Spritemap(GFX.ARM_BASE_BACK_ANIM, 100, 80);
					break;
				case CLAW:
					animSheet = new Spritemap(GFX.ARM_CLAW_BACK_ANIM, 100, 80);
					break;
			}
			return animSheet;
		}
		
		private static function noneSetup():void
		{
			GREYSCALE_IMAGE[NONE] = new Image(GFX.BLANK_IMAGE);
			GREYSCALE_IMAGE[NONE].alpha = .4;
			TRAIT_POINT_COUNT[NONE] = 10;
			IMAGE[NONE] = new Image(GFX.BLANK_IMAGE);
			
			DAMAGE[NONE] = 1;
			JUMP_FORCE_VAR[NONE] = 1.0;
			SPEED_VAR[NONE] = 1.0;
			
		}
		private static function baseSetup():void
		{
			GREYSCALE_IMAGE[BASE] = new Image(GFX.ARM_BASE_COUNT);
			GREYSCALE_IMAGE[BASE].alpha = .4;
			TRAIT_POINT_COUNT[BASE] = 10;
			IMAGE[BASE] = new Image(GFX.ARM_BASE_COUNT_COLOR);
			
			DAMAGE[BASE] = 1;
			JUMP_FORCE_VAR[BASE] = 1.0;
			SPEED_VAR[BASE] = 1.0;
			
			
			
		}
		
		private static function clawSetup():void
		{
			
			GREYSCALE_IMAGE[CLAW] = new Image(GFX.ARM_CLAW_COUNT);
			GREYSCALE_IMAGE[CLAW].alpha = .4;
			TRAIT_POINT_COUNT[CLAW] = 3;
			IMAGE[CLAW] = new Image(GFX.ARM_CLAW_COUNT_COLOR);
			
			DAMAGE[CLAW] = 1;
			JUMP_FORCE_VAR[CLAW] = 1.0;
			SPEED_VAR[CLAW] = 1.0;
			
			
		}
		public static function init():void
		{
			noneSetup();
			baseSetup();
			clawSetup();
		}
	}

}
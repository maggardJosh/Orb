package com.lionsteel.LD24.BodyTypes 
{
	import com.lionsteel.LD24.ElementTypes.ElementTypes;
	import com.lionsteel.LD24.GFX;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Class containing static methods for dealing
	 * with different arm type stats and GFX
	 * @author Josh Maggard
	 */
	public class ArmType
	{
		
		//{region Arm Types
		
		public static const NONE:int = 0;		
		public static const BASE:int = 1;		
		public static const CLAW:int = 2;		
		
		public static const NUM_PARTS:int = 3;				//total number of parts (+1 for none)
		
		//} endregion
		
		//{region Part Stats
		
		public static var TRAIT_POINT_COUNT:Vector.<uint> = new Vector.<uint>(NUM_PARTS, true);					//Number of trait points needed
		public static var GREYSCALE_IMAGE:Vector.<Image> = new Vector.<Image>(NUM_PARTS, true);					//Black and white image of this
		public static var IMAGE:Vector.<Image> = new Vector.<Image>(NUM_PARTS, true);							//Image of this part (no animation)
		
		public static var PART_DAMAGE:Vector.<uint> = new Vector.<uint>(NUM_PARTS, true);						//Damage this part does
		
		public static var SPEED_VAR:Vector.<Number> = new Vector.<Number>(NUM_PARTS, true);						//Speed variables for each arm type
		public static var JUMP_FORCE_VAR:Vector.<Number> = new Vector.<Number>(NUM_PARTS, true);				//Monster's jump force is multiplied by this before jumping.		
		public static var JUMPS_ADDED:Vector.<int> = new Vector.<int>(NUM_PARTS, true);							//Number of jumps this part adds
		public static var HEARTS_ADDED:Vector.<int> = new Vector.<int>(NUM_PARTS, true);						//Number of hearts this part adds
		public static var DEFENSE_VAR:Vector.<Number> = new Vector.<Number>(NUM_PARTS, true);					//Defense variable for each part
		public static var TOTAL_DAMAGE_VAR:Vector.<Number> = new Vector.<Number>(NUM_PARTS, true);				//Effects damage dealt by everything
		public static var ELEMENT_DEFENSE:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>(NUM_PARTS, true);
		
		//}endregion
		
		//{region Init Function
		/**
		 * Call this function in main's init to initialize all parts GFX and stats
		 */
		public static function init():void
		{
			// Create each part's element defense array
			// Each part contains an array that contains each element's defense value
			// And each part is in an array... soooo it's an array within an array! :D
			// (Basically float[NUM_PARTS][NUM_ELEMENTS])
			for (var x:int = 0; x < NUM_PARTS; x++ )
				ELEMENT_DEFENSE[x] = new Vector.<Number>(ElementTypes.NUM_ELEMENTS, true);			//Side note: These all initialize to 0 automatically... Yataa! That's what we want!
			
			noneSetup();
			baseSetup();
			clawSetup();
		}
		
		//}endregion
		
		//{region Front & Back Anim Functions
		
		/**
		 * Returns a copy of front arm anim sheet 
		 * @param type of part
		 * @return Spritemap with animations for the part indicated by param type
		 */
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
		
		/**
		 * Returns a copy of back arm anim sheet 
		 * @param type of part
		 * @return Spritemap with animations for the part indicated by param type
		 */
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
		
		//} endregion
		
		//{region Setup Functions for Part images & stats
		private static function noneSetup():void
		{
			GREYSCALE_IMAGE[NONE] = new Image(GFX.BLANK_IMAGE);
			GREYSCALE_IMAGE[NONE].alpha = .4;
			TRAIT_POINT_COUNT[NONE] = 10;
			IMAGE[NONE] = new Image(GFX.BLANK_IMAGE);
			
			PART_DAMAGE[NONE] = 1;
			JUMP_FORCE_VAR[NONE] = 1.0;
			SPEED_VAR[NONE] = 1.0;
			
		}
		private static function baseSetup():void
		{
			GREYSCALE_IMAGE[BASE] = new Image(GFX.ARM_BASE_COUNT);
			GREYSCALE_IMAGE[BASE].alpha = .4;
			TRAIT_POINT_COUNT[BASE] = 10;
			IMAGE[BASE] = new Image(GFX.ARM_BASE_COUNT_COLOR);
			
			PART_DAMAGE[BASE] = 1;
			JUMP_FORCE_VAR[BASE] = 1.0;
			SPEED_VAR[BASE] = 1.0;
			
			
			
		}
		private static function clawSetup():void
		{
			
			GREYSCALE_IMAGE[CLAW] = new Image(GFX.ARM_CLAW_COUNT);
			GREYSCALE_IMAGE[CLAW].alpha = .4;
			TRAIT_POINT_COUNT[CLAW] = 3;
			IMAGE[CLAW] = new Image(GFX.ARM_CLAW_COUNT_COLOR);
			
			PART_DAMAGE[CLAW] = 1;
			JUMP_FORCE_VAR[CLAW] = 1.0;
			SPEED_VAR[CLAW] = 1.0;
			
			
		}
		//} endregion
		
	}

}
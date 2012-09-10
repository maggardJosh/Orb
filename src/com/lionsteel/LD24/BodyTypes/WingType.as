package com.lionsteel.LD24.BodyTypes 
{
	import com.lionsteel.LD24.C;
	import com.lionsteel.LD24.ElementTypes.ElementTypes;
	import com.lionsteel.LD24.GFX;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Class containing static methods for dealing
	 * with different wing type stats and GFX
	 * @author Josh Maggard
	 */
	public class WingType
	{
		
		//{region Wing Types
		
		public static const NONE:int = 0;		
		public static const BAT:int = 1;		
		public static const TINY:int = 2;		
		
		public static const NUM_PARTS:int = 3;				//total number of parts (+1 for none)
		
		//} endregion
		
		//{region Part Stats
		
		public static var TRAIT_POINT_COUNT:Vector.<uint> = new Vector.<uint>(NUM_PARTS, true);					//Number of trait points needed
		public static var GREYSCALE_IMAGE:Vector.<Image> = new Vector.<Image>(NUM_PARTS, true);					//Black and white image of this
		public static var IMAGE:Vector.<Image> = new Vector.<Image>(NUM_PARTS, true);							//Image of this part (no animation)
		
		public static var PART_DAMAGE:Vector.<uint> = new Vector.<uint>(NUM_PARTS, true);						//Damage this part does
		
		public static var SPEED_VAR:Vector.<Number> = new Vector.<Number>(NUM_PARTS, true);						//Speed variables for each arm type
		public static var JUMP_FORCE_VAR:Vector.<Number> = new Vector.<Number>(NUM_PARTS, true);				//Monster's jump force is multiplied by this before jumping.		
		public static var HEARTS_ADDED:Vector.<int> = new Vector.<int>(NUM_PARTS, true);						//Number of hearts this part adds
		public static var JUMPS_ADDED:Vector.<int> = new Vector.<int>(NUM_PARTS, true);							//Number of jumps this part adds
		public static var DEFENSE_VAR:Vector.<Number> = new Vector.<Number>(NUM_PARTS, true);					//Defense variable for each part
		public static var TOTAL_DAMAGE_VAR:Vector.<Number> = new Vector.<Number>(NUM_PARTS, true);				//Effects damage dealt by everything
		public static var ELEMENT_DEFENSE:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>(NUM_PARTS, true);
		
		//Wing specific stats
		public static var FLOAT_VAR:Vector.<Number> = new Vector.<Number>(NUM_PARTS, true);						//Multiplies C.START_MAX_Y_VEL with this to get the new maximum y velocity while floating (1=normal, 0=absolutely no falling while floating)
		
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
			batSetup();
			tinySetup();
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
				case BAT:
					animSheet = new Spritemap(GFX.WING_BAT_FRONT_ANIM, 100, 80);
					with (animSheet)
					{
						add("idle", [0,1,2,3], .1, true);
						add("walk", [4, 5, 6, 7], .1, true);
						add("jump", [8,9,10,11], .07, false);
						add("fall", [12, 13, 14, 15], .1, false);
					}
				break;
				case TINY:
						animSheet= new Spritemap(GFX.WING_TINY_FRONT_ANIM, 100, 80);
						with (animSheet)
						{
							add("idle", [0], .1, true);
							add("walk", [4, 5, 6, 7], .1, true);
							add("jump", [8,9,10,11], .07, false);
							add("fall", [12], .1, false);
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
				case BAT:
					animSheet = new Spritemap(GFX.WING_BAT_BACK_ANIM, 100, 80);
					break;
				case TINY:
					animSheet = new Spritemap(GFX.WING_TINY_BACK_ANIM, 100, 80);
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
			
			FLOAT_VAR[NONE] = 1.0;
			
			PART_DAMAGE[NONE] = 1;
			JUMP_FORCE_VAR[NONE] = 1.0;
			SPEED_VAR[NONE] = 1.0;
		}
		

		private static function batSetup():void
		{
			GREYSCALE_IMAGE[BAT] = new Image(GFX.WING_BAT_COUNT);
			GREYSCALE_IMAGE[BAT].alpha = .2;
			TRAIT_POINT_COUNT[BAT] = 4;			
			IMAGE[BAT] = new Image(GFX.WING_BAT_COUNT_COLOR);
			
			FLOAT_VAR[BAT] = .3;
			
			PART_DAMAGE[BAT] = 1;
			JUMP_FORCE_VAR[BAT] = 1.0;
			SPEED_VAR[BAT] = 1.0;
			JUMPS_ADDED[BAT] = 2;
		}
		
		private static function tinySetup():void
		{
			GREYSCALE_IMAGE[TINY] = new Image(GFX.WING_TINY_COUNT);
			GREYSCALE_IMAGE[TINY].alpha = .2;
			TRAIT_POINT_COUNT[TINY] = 3;
			IMAGE[TINY] = new Image(GFX.WING_TINY_COUNT_COLOR);
			
			FLOAT_VAR[TINY] = .7;
			
			PART_DAMAGE[TINY] = 1;
			JUMP_FORCE_VAR[TINY] = 1.0;
			SPEED_VAR[TINY] = 1.0;
			JUMPS_ADDED[TINY] = 1;
		}
		
		
		//} endregion
		
	}

}
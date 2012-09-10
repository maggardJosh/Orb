package com.lionsteel.LD24.BodyTypes 
{
	import com.lionsteel.LD24.C;
	import com.lionsteel.LD24.ElementTypes.ElementTypes;
	import com.lionsteel.LD24.GFX;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Class containing static methods for dealing
	 * with different leg type stats and GFX
	 * @author Josh Maggard
	 */
	public class LegType
	{
		
		//{region Leg Types
		
		public static const NONE:int = 0;
		public static const JABA:int = 1;
		public static const SPIDER:int = 2;
		
		public static const NUM_PARTS:int = 3;				//total number of parts (+1 for none)
		
		//} endregion
		
		//{region Part Stats
		
		public static var TRAIT_POINT_COUNT:Vector.<uint> = new Vector.<uint>(NUM_PARTS, true);					//Number of trait points needed
		public static var GREYSCALE_IMAGE:Vector.<Image> = new Vector.<Image>(NUM_PARTS, true);					//Black and white image of this
		public static var IMAGE:Vector.<Image> = new Vector.<Image>(NUM_PARTS, true);							//Image of this part (no animation)
		
		public static var PART_DAMAGE:Vector.<uint> = new Vector.<uint>(NUM_PARTS, true);						//Damage this part does
		
		public static var SPEED_VAR:Vector.<Number> = new Vector.<Number>(NUM_PARTS, true);						//Speed variables for each arm type
		public static var JUMP_FORCE_VAR:Vector.<Number> = new Vector.<Number>(NUM_PARTS, true);				//Monster's jump force is multiplied by this before jumping.		
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
			jabaSetup();
			spiderSetup();
		}
		
		//}endregion
		
		//{region Front & Back Anim Functions 
		
		/**
		 * Returns a copy of front leg anim sheet 
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
				case JABA:
					animSheet = new Spritemap(GFX.LEG_JABA_FRONT_ANIM, 100, 54);
					with (animSheet)
					{
						add("idle", [0], .3, true);
						add("walk", [4, 5, 6, 7], .06, true);
						add("jump", [8], .3, true);
						add("fall", [12], .3, true);
						add("attack", [0], .3, true);
						add("range", [0], .3, true);
						add("crouch", [0], .3, true);
						add("birth", [0], .3, true);
						play("idle");
						
					}
				break;
				case SPIDER:						
						animSheet = new Spritemap(GFX.LEG_SPIDER_FRONT_ANIM, 100, 80);
						with (animSheet)
						{
							
					
							add("idle", [0], .3, true);
							add("walk", [4, 5, 6, 7], .25, true);
							add("jump", [8], .3, true);
							add("fall", [12], .3, true);
							add("attack", [16], .3, true);
							add("range", [16], .3, true);
							add("crouch", [16], .3, true);
							add("birth", [16], .3, true);
							play("idle");
							
						}
				break;		
			}
			return animSheet;
		}
		
		/**
		 * Returns a copy of back leg anim sheet 
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
				case JABA:
					animSheet = new Spritemap(GFX.BLANK_IMAGE);
					break;
				case SPIDER:
					animSheet = new Spritemap(GFX.LEG_SPIDER_BACK_ANIM, 100,80);
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
		private static function jabaSetup():void
		{
			GREYSCALE_IMAGE[JABA] = new Image(GFX.LEG_JABA_COUNT);
			GREYSCALE_IMAGE[JABA].alpha = .2;
			TRAIT_POINT_COUNT[JABA] = 5;
			IMAGE[JABA] = new Image(GFX.LEG_JABA_COUNT_COLOR);
			
			PART_DAMAGE[JABA] = 1;
			JUMP_FORCE_VAR[JABA] = 1.0;
			SPEED_VAR[JABA] = 1.0;
			
		}
		private static function spiderSetup():void
		{
			GREYSCALE_IMAGE[SPIDER] = new Image(GFX.LEG_SPIDER_COUNT);
			GREYSCALE_IMAGE[SPIDER].alpha = .2;
			TRAIT_POINT_COUNT[SPIDER] = 3;
			IMAGE[SPIDER] = new Image(GFX.LEG_SPIDER_COUNT_COLOR);
			
			PART_DAMAGE[SPIDER] = 1;
			JUMP_FORCE_VAR[SPIDER] = 1.0;
			SPEED_VAR[SPIDER] = 1.0;
			
			
		}
		//} endregion
	
		//{region Leg Height function
		/**
		 * Returns the height the player should be off the ground
		 * with the given leg type
		 * @param	typeOfLeg Type of leg to get the height for
		 * @return	Height of the player with the given type of leg
		 */
		public static function legHeight(typeOfLeg:int):int
		{
			switch(typeOfLeg)
			{
				case LegType.NONE:
					return 32;
				case LegType.SPIDER:
					return 50;
				case LegType.JABA:
					return 40;
				default:
					trace("Leg type " + typeOfLeg + " not found");
					return C.TILE_SIZE;
			}
			
		}
		//}endregion
	}

}
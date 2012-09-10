package com.lionsteel.LD24.BodyTypes 
{
	import com.lionsteel.LD24.ElementTypes.ElementTypes;
	import com.lionsteel.LD24.GFX;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Class containing static methods for dealing
	 * with different tail type stats and GFX
	 * @author Josh Maggard
	 */
	public class TailType
	{
		
		//{region Tail Types
		
		public static const NONE:int = 0;
		public static const SCORPION:int = 1;
		public static const MONKEY:int = 2;
		
		public static const NUM_PARTS:int = 3;				//total number of parts (+1 for none)
		
		//} endregion
		
		//{region Part Stats
		
		public static var TRAIT_POINT_COUNT:Vector.<uint> = new Vector.<uint>(NUM_PARTS, true);					//Number of trait points needed
		public static var GREYSCALE_IMAGE:Vector.<Image> = new Vector.<Image>(NUM_PARTS, true);					//Greyscale image of this
		public static var IMAGE:Vector.<Image> = new Vector.<Image>(NUM_PARTS, true);							//Image of this part (no animation)
		
		public static var PART_DAMAGE:Vector.<uint> = new Vector.<uint>(NUM_PARTS, true);						//Damage this part does
		
		public static var SPEED_VAR:Vector.<Number> = new Vector.<Number>(NUM_PARTS, true);						//Speed variables for each arm type
		public static var JUMP_FORCE_VAR:Vector.<Number> = new Vector.<Number>(NUM_PARTS, true);				//Monster's jump force is multiplied by this before jumping.		
		public static var HEARTS_ADDED:Vector.<int> = new Vector.<int>(NUM_PARTS, true);						//Number of hearts this part adds
		public static var JUMPS_ADDED:Vector.<int> = new Vector.<int>(NUM_PARTS, true);							//Number of jumps this part adds
		public static var DEFENSE_VAR:Vector.<Number> = new Vector.<Number>(NUM_PARTS, true);					//Defense variable for each part
		public static var TOTAL_DAMAGE_VAR:Vector.<Number> = new Vector.<Number>(NUM_PARTS, true);				//Effects damage dealt by everything
		public static var ELEMENT_DEFENSE:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>(NUM_PARTS, true);			//Elemental defense values (Multi-dimensional vector)
		
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
			scorpionSetup();
			monkeySetup();
		}
		
		//}endregion
		
		//{region Anim Function
		
		/**
		 * Returns a copy of front arm anim sheet 
		 * @param type of part
		 * @return Spritemap with animations for the part indicated by param type
		 */
		public static function getAnim(type:int):Spritemap
		{
			var animSheet:Spritemap;
			switch(type)
			{
				case NONE:
					animSheet = new Spritemap(GFX.BLANK_IMAGE);
				break;
				case SCORPION:
					animSheet = new Spritemap(GFX.TAIL_SCORPION_ANIM, 120, 100);
					with (animSheet)
					{
						add("idle",[0] ,.1, true);
						add("walk", [4,5,6,7], .1, true);
						add("jump", [8], .1, true);
						add("fall", [12], .1, true);
						add("meleeStart", [16], .7, false);
						add("melee", [16,17,18,19,19,19,19],.3, false);
						add("range", [20], .1, true);
						add("crouch", [24], .1, true);
						add("birth", [28], .1, true);
						
					}
				break;
				case MONKEY:
					animSheet = new Spritemap(GFX.TAIL_MONKEY_ANIM, 120, 100);
					with (animSheet)
					{
						
						add("idle",[0] ,.1, true);
						add("walk", [4,5,6,7], .1, true);
						add("jump", [8], .1, true);
						add("fall", [12], .1, true);
						add("meleeStart", [16], .7, false);
						add("melee", [16,17,18,19,19,19,19],.3, false);
						add("range", [0], .1, true);
						add("crouch", [0], .1, true);
						add("birth", [0], .1, true);
					}
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
		
		private static function scorpionSetup():void
		{
			GREYSCALE_IMAGE[SCORPION] = new Image(GFX.TAIL_SCORPION_COUNT);
			GREYSCALE_IMAGE[SCORPION].alpha = .2;
			TRAIT_POINT_COUNT[SCORPION] = 4;			
			IMAGE[SCORPION] = new Image(GFX.TAIL_SCORPION_COUNT_COLOR);
			
			PART_DAMAGE[SCORPION] = 1;
			JUMP_FORCE_VAR[SCORPION] = 1.0;
			SPEED_VAR[SCORPION] = 1.0;
			
		}
		
		private static function monkeySetup():void
		{
			GREYSCALE_IMAGE[MONKEY] = new Image(GFX.TAIL_MONKEY_COUNT);
			GREYSCALE_IMAGE[MONKEY].alpha = .2;
			TRAIT_POINT_COUNT[MONKEY] = 4;
			IMAGE[MONKEY] = new Image(GFX.TAIL_MONKEY_COUNT_COLOR);
			
			PART_DAMAGE[MONKEY] = 0;
			JUMP_FORCE_VAR[MONKEY] = 1.0;
			SPEED_VAR[MONKEY] = 1.0;
			
			
		}
		
		//} endregion
		
	}

}
package com.lionsteel.LD24.BodyTypes 
{
	import com.lionsteel.LD24.ElementTypes.ElementTypes;
	import com.lionsteel.LD24.GFX;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Class containing static methods for dealing
	 * with different body type stats and GFX
	 * @author Josh Maggard
	 */
	public class BodyType
	{
		
		//{region Body Types
		
		public static const BASE:int = 0;
		
		public static const NUM_PARTS:int = 1;				//total number of parts (don't add +1 because we can never have 'no' body)
		
		//} endregion
		
		//{region Part Stats
		
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
			
			baseSetup();
		}
		
		//}endregion
		
		//{region Anim Function
		
		/**
		 * Returns a copy of anim sheet 
		 * @param type of part
		 * @return Spritemap with animations for the part indicated by param type
		 */
		public static function getAnim(type:int):Spritemap
		{
			var animSheet:Spritemap;
			switch(type)
			{
				case BASE:					
					animSheet = new Spritemap(GFX.BASE_BODY_ANIM,32, 32);
					with (animSheet)
					{
						add("idle", [ 0], .1, true);
						add("walk", [1], .1, true);
						add("jump", [2], .1, true);
						add("fall", [3], .1, true);
						add("melee", [4], .1, true);
						add("range", [5], .1, true);
						add("crouch", [6], .1, true);
						add("birth", [7,7,7], .03, false);
						play("idle");
						
					}
				break;
			}
			return animSheet;
		}
		
		//} endregion
		
		//{region Setup Functions for Part images & stats
		
		private static function baseSetup():void
		{
			
			PART_DAMAGE[BASE] = 0;
			JUMP_FORCE_VAR[BASE] = 1.0;
			SPEED_VAR[BASE] = 1.0;
			
			
		}
		
		//} endregion
		
	}

}
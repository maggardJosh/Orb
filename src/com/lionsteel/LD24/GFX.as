package com.lionsteel.LD24 
{
	/**
	 * Graphical Assets
	 * @author Josh Maggard
	 */
	public class GFX 
	{
		
		//Player
		[Embed(source = "assets/Player/body/base.png")] public static const BASE_BODY_ANIM:Class;
		[Embed(source = "assets/Player/horns/horn1.png")] public static const HORN_ONE_ANIM:Class;
		
		[Embed(source = "assets/Player/legs/leg_spider_front.png")] public static const LEG_BASE_FRONT_ANIM:Class;
		[Embed(source = "assets/Player/legs/leg_spider_back.png")] public static const LEG_BASE_BACK_ANIM:Class;
		
		[Embed(source = "assets/Player/wings/wing_base_front.png")] public static const WING_BASE_FRONT_ANIM:Class;
		[Embed(source = "assets/Player/wings/wing_base_back.png")] public static const WING_BASE_BACK_ANIM:Class;
		
		[Embed(source = "assets/Player/arms/arm_base_front.png")] public static const ARM_BASE_FRONT_ANIM:Class;
		[Embed(source = "assets/Player/arms/arm_base_back.png")] public static const ARM_BASE_BACK_ANIM:Class;
		
		[Embed(source = "assets/Player/tails/tailBase.png")] public static const TAIL_BASE_ANIM:Class;
		
		//Background and tileset
		[Embed(source = "assets/backgroundOne.png")] public static const BACKGROUND_ONE:Class;
		[Embed(source = "assets/backgroundTwo.png")] public static const BACKGROUND_TWO:Class;
		[Embed(source = "assets/tileSet.png")] public static const TILE_SET:Class;
	}

}
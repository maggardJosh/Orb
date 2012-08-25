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
		[Embed(source = "assets/Player/legs/leg_spider_front.png")] public static const LEG_SPIDER_FRONT_ANIM:Class;
		[Embed(source = "assets/Player/legs/leg_spider_back.png")] public static const LEG_SPIDER_BACK_ANIM:Class;
		
		[Embed(source = "assets/Player/wings/wing_bat_front.png")] public static const WING_BAT_FRONT_ANIM:Class;
		[Embed(source = "assets/Player/wings/wing_bat_back.png")] public static const WING_BAT_BACK_ANIM:Class;
		
		[Embed(source = "assets/Player/arms/arm_base_front.png")] public static const ARM_BASE_FRONT_ANIM:Class;
		[Embed(source = "assets/Player/arms/arm_base_back.png")] public static const ARM_BASE_BACK_ANIM:Class;
		
		[Embed(source = "assets/Player/tails/tailBase.png")] public static const TAIL_BASE_ANIM:Class;
		
		//Pickups
		[Embed(source = "assets/PowerUps/leg_spider_pickup.png")] public static const SPIDER_LEG_PICKUP:Class;
		[Embed(source = "assets/PowerUps/leg_base_pickup.png")] public static const BASE_LEG_PICKUP:Class;
		[Embed(source = "assets/PowerUps/wing_base_pickup.png")] public static const BAT_WING_PICKUP:Class;
		[Embed(source = "assets/PowerUps/arm_base_pickup.png")] public static const BASE_ARM_PICKUP:Class;
		[Embed(source = "assets/PowerUps/tail_base_pickup.png")] public static const BASE_TAIL_PICKUP:Class;
		[Embed(source = "assets/PowerUps/horn_base_pickup.png")] public static const BASE_HORN_PICKUP:Class;
		
		//Background and tileset
		[Embed(source = "assets/backgroundOne.png")] public static const BACKGROUND_ONE:Class;
		[Embed(source = "assets/backgroundTwo.png")] public static const BACKGROUND_TWO:Class;
		[Embed(source = "assets/tileSet.png")] public static const TILE_SET:Class;
	}

}
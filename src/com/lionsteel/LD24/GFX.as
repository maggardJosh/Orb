package com.lionsteel.LD24 
{
	/**
	 * Graphical Assets
	 * @author Josh Maggard
	 */
	public class GFX 
	{
		//Particles
		[Embed(source = "assets/particle.png")] public static const PARTICLE_ONE:Class;
		
		//Player
		[Embed(source = "assets/egg_blue_big.png")] public static const EGG_BIG:Class;
		[Embed(source = "assets/Player/body/base.png")] public static const BASE_BODY_ANIM:Class;
		[Embed(source = "assets/Player/body/mate_base.png")] public static const MATE_BODY_ANIM:Class;
		[Embed(source = "assets/Player/body/mate_hair.png")] public static const PONY_TAIL:Class;
		
		[Embed(source = "assets/Player/horns/horn_spike.png")] public static const HORN_SPIKE_ANIM:Class;
		[Embed(source = "assets/Player/horns/head_plant.png")] public static const HORN_PLANT_ANIM:Class;
		
		[Embed(source = "assets/Player/legs/leg_jaba_front.png")] public static const LEG_JABA_FRONT_ANIM:Class;
		[Embed(source = "assets/Player/legs/leg_spider_front.png")] public static const LEG_SPIDER_FRONT_ANIM:Class;
		[Embed(source = "assets/Player/legs/leg_spider_back.png")] public static const LEG_SPIDER_BACK_ANIM:Class;
		
		[Embed(source = "assets/Player/wings/wing_bat_front.png")] public static const WING_BAT_FRONT_ANIM:Class;
		[Embed(source = "assets/Player/wings/wing_bat_back.png")] public static const WING_BAT_BACK_ANIM:Class;
		[Embed(source = "assets/Player/wings/wing_tiny_front.png")] public static const WING_TINY_FRONT_ANIM:Class;
		[Embed(source = "assets/Player/wings/wing_tiny_back.png")] public static const WING_TINY_BACK_ANIM:Class;
		
		[Embed(source = "assets/Player/arms/arm_base_front.png")] public static const ARM_BASE_FRONT_ANIM:Class;
		[Embed(source = "assets/Player/arms/arm_base_back.png")] public static const ARM_BASE_BACK_ANIM:Class;
		[Embed(source = "assets/Player/arms/arm_claw_front.png")] public static const ARM_CLAW_FRONT_ANIM:Class;
		[Embed(source = "assets/Player/arms/arm_claw_back.png")] public static const ARM_CLAW_BACK_ANIM:Class;
		
		[Embed(source = "assets/Player/tails/tail_scorpion.png")] public static const TAIL_SCORPION_ANIM:Class;
		[Embed(source = "assets/Player/tails/tail_monkey.png")] public static const TAIL_MONKEY_ANIM:Class;
		
		//Pickups
		[Embed(source = "assets/PowerUps/leg_spider_pickup.png")] public static const SPIDER_LEG_PICKUP:Class;
		[Embed(source = "assets/PowerUps/wing_bat_pickup.png")] public static const BAT_WING_PICKUP:Class;
		[Embed(source = "assets/PowerUps/arm_base_pickup.png")] public static const BASE_ARM_PICKUP:Class;
		[Embed(source = "assets/PowerUps/tail_scorpion_pickup.png")] public static const SCORPION_TAIL_PICKUP:Class;
		[Embed(source = "assets/PowerUps/horn_spike_pickup.png")] public static const SPIKE_HORN_PICKUP:Class;
		[Embed(source = "assets/PowerUps/leg_jaba_pickup.png")] public static const LEG_JABA_PICKUP:Class;
		[Embed(source = "assets/PowerUps/arm_claw_pickup.png")] public static const ARM_CLAW_PICKUP:Class;
		[Embed(source = "assets/PowerUps/head_plant_pickup.png")] public static const HORN_PLANT_PICKUP:Class;
		[Embed(source = "assets/PowerUps/tail_monkey_pickup.png")] public static const TAIL_MONKEY_PICKUP:Class;
		[Embed(source = "assets/PowerUps/wing_tiny_pickup.png")] public static const WING_TINY_PICKUP:Class;
		
		//Background and tileset
		[Embed(source = "assets/backgroundOne.png")] public static const BACKGROUND_ONE:Class;
		[Embed(source = "assets/backgroundTwo.png")] public static const BACKGROUND_TWO:Class;
		[Embed(source = "assets/tileSet.png")] public static const TILE_SET:Class;
		[Embed(source = "assets/TITLE.png")] public static const MAIN_MENU_BG:Class;
		
		//GUI
		[Embed(source = "assets/heart_empty.png")] public static const HEALTH_CONTAINER:Class;
		[Embed(source = "assets/heart_full.png")] public static const HEALTH_FILLER:Class;
		[Embed(source = "assets/Trait_Holder.png")] public static const TRAIT_HOLDER:Class;
		[Embed(source = "assets/Trait_Holder_Locked.png")] public static const TRAIT_LOCKED:Class;
		[Embed(source = "assets/e_key.png")] public static const E_KEY:Class;
		[Embed(source = "assets/egg_blue_small.png")] public static const LIVES_ICON:Class;
		
		[Embed(source = "assets/KillCount/trait_box.png")] public static const TRAIT_BOX:Class;
		
		[Embed(source = "assets/KillCount/arms_base_bw.png")] public static const ARM_BASE_COUNT:Class
		[Embed(source = "assets/KillCount/arms_base_color.png")] public static const ARM_BASE_COUNT_COLOR:Class
		[Embed(source = "assets/KillCount/horn_spike_bw.png")] public static const HORN_SPIKE_COUNT:Class
		[Embed(source = "assets/KillCount/horn_spike_color.png")] public static const HORN_SPIKE_COUNT_COLOR:Class
		[Embed(source = "assets/KillCount/legs_spider_bw.png")] public static const LEG_SPIDER_COUNT:Class
		[Embed(source = "assets/KillCount/legs_spider_color.png")] public static const LEG_SPIDER_COUNT_COLOR:Class
		[Embed(source = "assets/KillCount/tail_scorpion_bw.png")] public static const TAIL_SCORPION_COUNT:Class
		[Embed(source = "assets/KillCount/tail_scorpion_color.png")] public static const TAIL_SCORPION_COUNT_COLOR:Class
		[Embed(source = "assets/KillCount/wings_bat_bw.png")] public static const WING_BAT_COUNT:Class
		[Embed(source = "assets/KillCount/wings_bat_color.png")] public static const WING_BAT_COUNT_COLOR:Class
		[Embed(source = "assets/KillCount/leg_jaba_bw.png")] public static const LEG_JABA_COUNT:Class
		[Embed(source = "assets/KillCount/leg_jaba_color.png")] public static const LEG_JABA_COUNT_COLOR:Class
		[Embed(source = "assets/KillCount/arm_claw_bw.png")] public static const ARM_CLAW_COUNT:Class
		[Embed(source = "assets/KillCount/arm_claw_color.png")] public static const ARM_CLAW_COUNT_COLOR:Class
		[Embed(source = "assets/KillCount/head_plant_bw.png")] public static const HORN_PLANT_COUNT:Class
		[Embed(source = "assets/KillCount/head_plant_color.png")] public static const HORN_PLANT_COUNT_COLOR:Class
		[Embed(source = "assets/KillCount/tail_monkey_bw.png")] public static const TAIL_MONKEY_COUNT:Class
		[Embed(source = "assets/KillCount/tail_monkey_color.png")] public static const TAIL_MONKEY_COUNT_COLOR:Class
		[Embed(source = "assets/KillCount/wing_tiny_bw.png")] public static const WING_TINY_COUNT:Class
		[Embed(source = "assets/KillCount/wing_tiny_color.png")] public static const WING_TINY_COUNT_COLOR:Class
		
		//Screens
		[Embed(source = "assets/descendantScreen.png")] public static const DESCENDANT_SCREEN:Class;
	}

}
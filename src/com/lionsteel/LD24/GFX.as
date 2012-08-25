package com.lionsteel.LD24 
{
	/**
	 * Graphical Assets
	 * @author Josh Maggard
	 */
	public class GFX 
	{
		//[Embed(source="assets/bodyAnim.png")] public static const BODY_ANIM:Class;
		
		[Embed(source = "assets/Player/body/base.png")] public static const BASE_BODY_ANIM:Class;
		[Embed(source = "assets/Player/horns/horn1.png")] public static const HORN_ONE_ANIM:Class;
		[Embed(source = "assets/Player/legs/legs1.png")] public static const LEG_ONE_ANIM:Class;
		[Embed(source = "assets/Player/wings/wing1.png")] public static const WING_ONE_ANIM:Class;
		
		[Embed(source = "assets/backgroundOne.png")] public static const BACKGROUND_ONE:Class;
		[Embed(source = "assets/backgroundTwo.png")] public static const BACKGROUND_TWO:Class;
		[Embed(source = "assets/tileSet.png")] public static const TILE_SET:Class;
	}

}
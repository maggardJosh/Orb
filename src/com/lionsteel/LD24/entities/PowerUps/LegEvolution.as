package com.lionsteel.LD24.entities.PowerUps 
{
	import com.lionsteel.LD24.entities.Player;
	import com.lionsteel.LD24.GFX;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.TiledSpritemap;
	import net.flashpunk.graphics.Tilemap;
	import com.lionsteel.LD24.BodyTypes.LegType;
	
	/**
	 * ...
	 * @author Josh Maggard
	 */
	public class LegEvolution extends PowerUp 
	{
		private var anim:Spritemap;
		private var typeOfLeg:int;
		public function LegEvolution(typeOfLeg:int, pos:Point) 
		{
			this.x = pos.x;
			this.y = pos.y;
			this.typeOfLeg = typeOfLeg;
			width = 20;
			height = 20;
			type = "PowerUp";
			switch(typeOfLeg)
			{
				case LegType.BASE:
					anim = new Spritemap(GFX.BASE_LEG_PICKUP, 20, 20);
					anim.add("idle", [0], .1, true);
					break;
				case LegType.SPIDER:
					anim = new Spritemap(GFX.SPIDER_LEG_PICKUP, 20, 20);
					anim.add("idle", [0], .1, true);
					break;
			}
			this.graphic = anim;
		}
		
		override public function pickup(player:Player):void 
		{
			player.addLeg(typeOfLeg);
			this.world.remove(this);
		}
		
	}

}
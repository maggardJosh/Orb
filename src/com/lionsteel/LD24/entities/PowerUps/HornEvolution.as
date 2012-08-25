package com.lionsteel.LD24.entities.PowerUps 
{
	import com.lionsteel.LD24.BodyTypes.ArmType;
	import com.lionsteel.LD24.BodyTypes.HornType;
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
	public class HornEvolution extends PowerUp 
	{
		private var anim:Spritemap;
		private var typeOfHorn:int;
		public function HornEvolution(typeOfHorn:int, pos:Point) 
		{
			this.x = pos.x;
			this.y = pos.y;
			this.typeOfHorn = typeOfHorn;
			width = 20;
			height = 20;
			type = "PowerUp";
			switch(typeOfHorn)
			{
				case HornType.BASE:
					anim = new Spritemap(GFX.BASE_HORN_PICKUP, 20, 20);
					anim.add("idle", [0], .1, true);
					break;
			}
			this.graphic = anim;
		}
		
		override public function pickup(player:Player):void 
		{
			player.addHorn(typeOfHorn);
			this.world.remove(this);
		}
		
	}

}
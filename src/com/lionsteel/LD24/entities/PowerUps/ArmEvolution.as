package com.lionsteel.LD24.entities.PowerUps 
{
	import com.lionsteel.LD24.BodyTypes.ArmType;
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
	public class ArmEvolution extends PowerUp 
	{
		private var anim:Spritemap;
		private var typeOfArm:int;
		public function ArmEvolution(typeOfArm:int, pos:Point) 
		{
			this.x = pos.x;
			this.y = pos.y;
			this.typeOfArm = typeOfArm;
			width = 20;
			height = 20;
			type = "PowerUp";
			switch(typeOfArm)
			{
				case ArmType.BASE:
					anim = new Spritemap(GFX.BASE_ARM_PICKUP, 20, 20);
					anim.add("idle", [0], .1, true);
					break;
			}
			this.graphic = anim;
		}
		
		override public function pickup(player:Player):void 
		{
			player.addArm(typeOfArm);
			this.world.remove(this);
		}
		
	}

}
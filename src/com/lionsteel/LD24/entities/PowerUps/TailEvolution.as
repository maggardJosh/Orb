package com.lionsteel.LD24.entities.PowerUps 
{
	import com.lionsteel.LD24.BodyTypes.ArmType;
	import com.lionsteel.LD24.BodyTypes.TailType;
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
	public class TailEvolution extends PowerUp 
	{
		private var anim:Spritemap;
		private var typeOfTail:int;
		public function TailEvolution(typeOfTail:int, pos:Point) 
		{
			this.x = pos.x;
			this.y = pos.y;
			this.typeOfTail = typeOfTail;
			width = 20;
			height = 20;
			type = "PowerUp";
			switch(typeOfTail)
			{
				case TailType.BASE:
					anim = new Spritemap(GFX.BASE_TAIL_PICKUP, 20, 20);
					anim.add("idle", [0], .1, true);
					break;
			}
			this.graphic = anim;
		}
		
		override public function pickup(player:Player):void 
		{
			player.addTail(typeOfTail);
			this.world.remove(this);
		}
		
	}

}
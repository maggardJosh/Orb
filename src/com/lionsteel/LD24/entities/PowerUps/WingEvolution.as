package com.lionsteel.LD24.entities.PowerUps 
{
	import com.lionsteel.LD24.BodyTypes.WingType;
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
	public class WingEvolution extends PowerUp 
	{
		private var anim:Spritemap;
		private var typeOfWing:int;
		public function WingEvolution(typeOfWing:int, pos:Point) 
		{
			this.x = pos.x;
			this.y = pos.y;
			this.typeOfWing = typeOfWing;
			width = 20;
			height = 20;
			type = "PowerUp";
			switch(typeOfWing)
			{
				case WingType.BAT:
					anim = new Spritemap(GFX.BAT_WING_PICKUP, 20, 20);
					anim.add("idle", [0], .1, true);
					break;
			}
			this.graphic = anim;
		}
		
		override public function pickup(player:Player):void 
		{
			player.addWing(typeOfWing);
			this.world.remove(this);
		}
		
	}

}
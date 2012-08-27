package com.lionsteel.LD24.entities.PowerUps 
{
	import com.lionsteel.LD24.C;
	import com.lionsteel.LD24.dropIndicator;
	import com.lionsteel.LD24.entities.Player;
	import com.lionsteel.LD24.GFX;
	import com.lionsteel.LD24.killIndicator;
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
				case LegType.SPIDER:
					anim = new Spritemap(GFX.SPIDER_LEG_PICKUP, 32, 32);
					break;
				case LegType.JABA:
					anim = new Spritemap(GFX.LEG_JABA_PICKUP, 32, 32);
					break;
			}
			anim.add("idle", [0,1], .1, true);
			anim.play("idle");
			this.graphic = anim;
		}
		
		override public function drop(player:Player):void 
		{
			player.setLeg(LegType.NONE);
			player.world.add(new dropIndicator(LegType.KILL_COLOR_IMAGES[typeOfLeg], C.LEG_POWERUP_POS, new Point(player.x, player.y)));
			super.drop(player);
		}
		
		override public function pickup(player:Player):Boolean 
		{
			if (player.addLeg(typeOfLeg))
			{
				player.world.add(new killIndicator(LegType.KILL_COLOR_IMAGES[typeOfLeg], new Point(player.x, player.y), C.LEG_POWERUP_POS));
				player.setTempPowerUp(this);
				this.world.remove(this);
				return true;
			}
			else
				return false;
		}
		
		
	}

}
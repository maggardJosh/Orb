package com.lionsteel.LD24.entities.PowerUps 
{
	import com.lionsteel.LD24.BodyTypes.ArmType;
	import com.lionsteel.LD24.BodyTypes.HornType;
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
				case HornType.SPIKE:
					anim = new Spritemap(GFX.SPIKE_HORN_PICKUP, 32, 32);
					break;
				case HornType.PLANT:
					anim = new Spritemap(GFX.HORN_PLANT_PICKUP, 32, 32);
					break;
			}
			anim.add("idle", [0, 1], .1, true);
			anim.play("idle");
			this.graphic = anim;
		}
		
		override public function drop(player:Player):void 
		{
			player.setHorn(HornType.NONE);
			player.world.add(new dropIndicator(HornType.KILL_COLOR_IMAGES[typeOfHorn], C.HORN_POWERUP_POS, new Point(player.x, player.y)));
			super.drop(player);
		}
		
		override public function pickup(player:Player):Boolean 
		{
			var noPowerUp:Boolean = false;
			if (player.horn != HornType.NONE  && player.tempPowerUp != null)
				player.tempPowerUp = new HornEvolution(player.horn,new Point());
			else
				if (player.horn != HornType.NONE)		//If has part but no power up yet
					noPowerUp = true;
				
			if (player.addHorn(typeOfHorn))
			{
				player.world.add(new killIndicator(HornType.KILL_COLOR_IMAGES[typeOfHorn], new Point(player.x, player.y),  C.HORN_POWERUP_POS));
				if (player.tempPowerUp != null)
					player.tempPowerUp.drop(player);
				player.setHorn(this.typeOfHorn);
				if (noPowerUp)
					player.setTempPowerUp(null);
				else
					player.setTempPowerUp(this);
				this.world.remove(this);
				return true;
			}
			else
			return false;
			
		}
		
		
		
	}

}
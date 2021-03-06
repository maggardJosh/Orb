package com.lionsteel.LD24.entities.PowerUps 
{
	import com.lionsteel.LD24.BodyTypes.WingType;
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
					anim = new Spritemap(GFX.BAT_WING_PICKUP, 32, 32);
					break;
				case WingType.TINY:
					anim = new Spritemap(GFX.WING_TINY_PICKUP, 32, 32);
					break;
			}
			anim.add("idle", [0, 1], .1, true);
			anim.play("idle");
			this.graphic = anim;
		}
		
		override public function drop(player:Player):void 
		{
			player.setWing(WingType.NONE);
			player.world.add(new dropIndicator(WingType.KILL_COLOR_IMAGES[typeOfWing], C.WING_POWERUP_POS, new Point(player.x, player.y)));
			super.drop(player);
		}
		override public function pickup(player:Player):Boolean 
		{
			var noPowerUp:Boolean = false;
			if (player.wings != WingType.NONE  && player.tempPowerUp != null)
				player.tempPowerUp = new WingEvolution(player.wings,new Point());
			else
				if (player.wings != WingType.NONE)		//If has part but no power up yet
					noPowerUp = true;
				
			if (player.addWing(typeOfWing))
			{
				player.world.add(new killIndicator(WingType.KILL_COLOR_IMAGES[typeOfWing], new Point(player.x, player.y),  C.WING_POWERUP_POS));
				if (player.tempPowerUp != null)
					player.tempPowerUp.drop(player);
				player.setWing(this.typeOfWing);
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
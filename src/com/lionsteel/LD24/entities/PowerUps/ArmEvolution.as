package com.lionsteel.LD24.entities.PowerUps 
{
	import com.lionsteel.LD24.BodyTypes.ArmType;
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
					anim = new Spritemap(GFX.BASE_ARM_PICKUP, 32, 32);
					break;
				case ArmType.CLAW:
					anim = new Spritemap(GFX.ARM_CLAW_PICKUP, 32, 32);
					break;
			}
			anim.add("idle", [0, 1], .1, true);
			anim.play("idle");
			this.graphic = anim;
		}
		
		override public function drop(player:Player):void 
		{
			player.setArm(ArmType.NONE);
			player.world.add(new dropIndicator(ArmType.KILL_COLOR_IMAGES[typeOfArm], C.ARM_POWERUP_POS, new Point(player.x, player.y)));
			super.drop(player);
		}
		
		override public function pickup(player:Player):Boolean 
		{
			var noPowerUp:Boolean = false;
			if (player.arms != ArmType.NONE  && player.tempPowerUp != null)
				player.tempPowerUp = new ArmEvolution(player.arms, new Point());
			else
				if (player.arms != ArmType.NONE)		//If has part but no power up yet
					noPowerUp = true;
			if (player.addArm(typeOfArm))
			{
				player.world.add(new killIndicator(ArmType.KILL_COLOR_IMAGES[typeOfArm], new Point(player.x, player.y),  C.ARM_POWERUP_POS));
				if (player.tempPowerUp != null)
					player.tempPowerUp.drop(player);
				player.setArm(this.typeOfArm);
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
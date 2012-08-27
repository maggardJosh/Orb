package com.lionsteel.LD24.entities.PowerUps 
{
	import com.lionsteel.LD24.BodyTypes.ArmType;
	import com.lionsteel.LD24.BodyTypes.TailType;
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
				case TailType.SCORPION:
					anim = new Spritemap(GFX.SCORPION_TAIL_PICKUP, 32, 32);
					break;
				case TailType.MONKEY:
					anim = new Spritemap(GFX.TAIL_MONKEY_PICKUP, 32, 32);
					break;
					
			}
			anim.add("idle", [0, 1], .1, true);
					anim.play("idle");
			this.graphic = anim;
		}
		
		
		override public function drop(player:Player):void 
		{
			player.setTail(TailType.NONE);
			player.world.add(new dropIndicator(TailType.KILL_COLOR_IMAGES[typeOfTail], C.TAIL_POWERUP_POS, new Point(player.x, player.y)));
			super.drop(player);
		}
		
		override public function pickup(player:Player):Boolean 
		{
			if (player.addTail(typeOfTail))
			{
				player.world.add(new killIndicator(TailType.KILL_COLOR_IMAGES[typeOfTail], new Point(player.x, player.y), C.TAIL_POWERUP_POS));
				player.setTempPowerUp(this);
				this.world.remove(this);
				return true;
			}else
				return false;
		}
		
		
	}

}
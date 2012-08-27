package com.lionsteel.LD24.entities.PowerUps 
{
	import com.lionsteel.LD24.C;
	import com.lionsteel.LD24.entities.Player;
	import com.lionsteel.LD24.GFX;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Josh Maggard
	 */
	public class PowerUp extends Entity 
	{
		private var collidingWithPlayer:Boolean = false;
		private var eKeyImage:Image;
		private var grounded:Boolean = false;
		public function PowerUp()
		{
			type = "PowerUp";
			width = 32;
			height = 32;
			eKeyImage = new Image(GFX.E_KEY);
		}
		public function drop(player:Player):void
		{
			this.x = player.x;
			this.y = player.y;
			player.currentLevel.add(this);
		}
		public function pickup(player:Player):Boolean
		{
			
			return false;
			
		}
		override public function update():void 
		{
				updateMovement();
			var collisionEntity:Entity = collide("Player", x, y);
			collidingWithPlayer = (collisionEntity != null);
		}
		
		//Apply velocity and check collisions
		private function updateMovement():void
		{
			var collideRoom:Entity;
			//Update y movement and then check collision
			y += 1;
			collideRoom = collide("level", x,Math.ceil(y));
			if (collideRoom != null)
			{
				
					y = collideRoom.y + Math.floor((y-collideRoom.y + height) / C.TILE_SIZE) * C.TILE_SIZE - height;		//Place at the top of the tile they have collided with
					grounded = true;
			}
			collideRoom = collide("PowerUp", x, y);
			if (collideRoom != null)
			{
				if ( x < collideRoom.x)
				{
					x -= 1;
					if (collide("level", x, y) != null)
						x += 1;
				}
				else
				if ( x > collideRoom.x)
				{
					x += 1;
					if (collide("level", x, y) != null)
						x -= 1;
				}
			}
		}
		
		override public function render():void 
		{
			super.render();
			if (collidingWithPlayer)
				eKeyImage.render(FP.buffer, new Point(x + halfWidth - eKeyImage.width / 2, y - eKeyImage.height - 10), FP.camera);
		}
		
	}

}
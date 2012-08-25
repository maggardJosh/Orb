package com.lionsteel.LD24.entities 
{
	import com.lionsteel.LD24.C;
	import com.lionsteel.LD24.GFX;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.TiledSpritemap;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Josh Maggard
	 */
	public class Player extends Entity 
	{
		private var animSheet:Spritemap
		private var velX:Number=0, velY:Number=0;
		private var friction:Number = .88;
		private var accel:Number = 1.3;
		private var jumpForce:Number = -5;
		public function Player() 
		{
			animSheet = new Spritemap(GFX.PLAYER_ANIM, 30, 30);
			animSheet.add("idle", [ 0, 1, 2, 3, 4, 5 ], .1, true);
			animSheet.play("idle");
			width = 32;
			height = 32;
			graphic = animSheet;
		}
		
		override public function update():void 
		{
			super.update();
			handleControls();
			updateMovement()
			updateCamera();
			
			
		}
		
		private function updateMovement():void
		{
			velY += C.Gravity;		//Gravity
			
			x += velX;
			var collideXRoom:Entity = collide("level", Math.ceil(x), y);
			if (collideXRoom!=null)
			{
				//Colliding with wall after x movement
				//Resolve!
				if (velX > 0)	//Moving right
					x = collideXRoom.x +Math.floor((x - collideXRoom.x + width) / C.TILE_SIZE) * C.TILE_SIZE - width;		//place to the left of tile we have collided with
					
			}
			collideXRoom = collide("level", Math.floor(x), y);
			if (collideXRoom != null)
			{
				if(velX<0)		//Moving left
					x = collideXRoom.x + Math.floor((x- collideXRoom.x) / C.TILE_SIZE) * C.TILE_SIZE + C.TILE_SIZE;		//place to the right of tile we have collided with
				
			}
			
			//Update y movement and then check collision
			y += velY
			var collideYRoom:Entity = collide("level", x,Math.ceil(y));
			if (collideYRoom != null)
			{
				//If colliding with wall after y movement
				//Resolve position
				if (velY > 0)		//Moving down
				{
					y = collideYRoom.y + Math.floor((y-collideYRoom.y + height) / C.TILE_SIZE) * C.TILE_SIZE - height;		//Place at the top of the tile they have collided with
					velY = 0;
				}
				
			}
			collideYRoom = collide("level", x, Math.floor(y));
			if(collideYRoom != null)
			{
				if (velY < 0)
				{
					y = collideYRoom.y + Math.floor((y - collideYRoom.y ) / C.TILE_SIZE)  * C.TILE_SIZE + C.TILE_SIZE;		//Place at the bottom of the tile they have collided with
					velY *= .5;
				}
					
					
			}
			velX *= friction;
		}
		
		private function handleControls():void
		{
			if (Input.pressed("UP"))
				velY = jumpForce;
			if (Input.check("RIGHT"))
				velX += accel;
			if (Input.check("LEFT"))
				velX -= accel;
		}
		
		private function updateCamera():void
		{
			
			var camXTarg:Number = x + width/2 - FP.halfWidth;
			var camYTarg:Number = y + height/2 - FP.halfHeight;
			
			FP.setCamera(FP.lerp(camXTarg, FP.camera.x, .8), FP.lerp(camYTarg, FP.camera.y, .8));
		}
	}

}
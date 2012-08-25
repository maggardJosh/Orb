package com.lionsteel.LD24.entities 
{
	import com.lionsteel.LD24.C;
	import com.lionsteel.LD24.GFX;
	import flash.geom.Point;
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
		public static const IDLE:int = 0;
		public static const WALKING:int = 1;
		public static const JUMPING:int = 2;
		public static const FALLING:int = 3;
		
		private var state:int = Player.IDLE;
		
		//Facing direction
		private var facingLeft:Boolean = false;
		
		private var bodyAnim:Spritemap;
		private var armAnim:Spritemap;
		private var legAnim:Spritemap;
		private var tailAnim:Spritemap;
		private var wingAnim:Spritemap;
		private var hornAnim:Spritemap;
		
		private var armOffset:Point;
		private var legOffset:Point;
		private var tailOffset:Point;
		private var wingOffset:Point;
		private var hornOffset:Point;
		
		private var hasArm:Boolean = false;
		private var hasLeg:Boolean = false;
		private var hasTail:Boolean = false;
		private var hasWing:Boolean = false;
		private var hasHorn:Boolean = false;
		
		private var velX:Number=0, velY:Number=0;
		private var friction:Number = .88;
		private var accel:Number = 1.3;
		private var jumpForce:Number = -15;
		private var grounded:Boolean  = false;
		
		private var pos:Point = new Point();
		private var _camPos:Point = new Point();
		
		
		public function Player() 
		{
			bodyAnim = new Spritemap(GFX.BASE_BODY_ANIM,32, 32);
			bodyAnim.add("idle", [ 0], .1, true);
			bodyAnim.add("walk", [1], .1, true);
			bodyAnim.play("idle");
			
			
			
			width = 32;
			height = 32;
			checkAnims();
			
		}
		
		override public function update():void 
		{
			super.update();
			handleControls();
			updateMovement()
			updateCamera();
			checkAnims();
			checkState();
			
		}
		
		private function checkState():void
		{
			
			if (grounded && Math.abs(velX ) > 1)
				state = WALKING;
				else
				if (Math.abs(velX) <  1)
					state = IDLE;
		}
		
		//Checks body type and animation placement
		private function checkAnims():void
		{
			if (state == WALKING)
				bodyAnim.play("walk");
			else
				bodyAnim.play("idle");
				
			bodyAnim.flipped = facingLeft;
		}
		private function updateMovement():void
		{
			velY += C.GRAVITY;		//Gravity
			
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
					grounded = true;
				}
				
			}
			else
			grounded = false;
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
			if (Input.pressed("UP") && grounded)
			{
				velY = jumpForce;
				
				grounded = false;
			}
			if (Input.check("RIGHT"))
			{
				velX += accel;
				facingLeft = false;
			}
			if (Input.check("LEFT"))
			{
				velX -= accel;
				facingLeft = true;
			}
		}
		
		private function updateCamera():void
		{
			
			var camXTarg:Number = x + width/2 - FP.halfWidth;
			var camYTarg:Number = y + height/2 - FP.halfHeight*1.5;
			
			FP.setCamera(FP.lerp(camXTarg, FP.camera.x, .8), FP.lerp(camYTarg, FP.camera.y, .8));
		}
		
		override public function render():void 
		{
			super.render();
			pos.x = x;
			pos.y = y;
			bodyAnim.render(FP.buffer, pos, FP.camera);
			
		}
	}

}
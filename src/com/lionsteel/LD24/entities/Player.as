package com.lionsteel.LD24.entities 
{
	import com.lionsteel.LD24.BodyTypes.*;
	import com.lionsteel.LD24.C;
	import com.lionsteel.LD24.entities.PowerUps.PowerUp;
	import com.lionsteel.LD24.GFX;
	import flash.geom.Point;
	import flash.media.SoundCodec;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.TiledSpritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;	
	import org.flashdevelop.utils.TraceLevel;
	
	/**
	 * 
	 * @author Josh Maggard
	 */
	public class Player extends Monster 
	{
		private var currentLevel:Level;
		public function Player() 
		{
			tintColor = 0xFFFFFF;
			super();
		}
		
		override public function update():void 
		{
			super.update();
			handleControls();
			updateMovement();
			handleCollision();
			updateCamera();
		}
		
		private function handleCollision():void 
		{
			collisionEntity = collide("Enemy", x, y);
			if (collisionEntity != null)
			{
				if (this.velY > 0 && x + width * 2 / 3 > collisionEntity.x && x + width * 1 / 3 < collisionEntity.x + collisionEntity.width)
				{
					var enemy:Enemy = Enemy(collisionEntity);
					
					{
						enemy.kill();
						this.velY = jumpForce;
					}
				}
			}
			collisionEntity = collide("PowerUp", x, y);
			if (collisionEntity != null)
			{
				(collisionEntity as PowerUp).pickup(this);
			}
		}
		
		public function setLevel(level:Level):void
		{
			this.currentLevel = level;
		}
		
		private function handleControls():void
		{
			if (Input.pressed(Key.DIGIT_1)) if (legs == LegType.NONE) setLeg(LegType.SPIDER); else setLeg(LegType.NONE);
			if (Input.pressed(Key.DIGIT_2)) if (horn == HornType.NONE) setHorn(HornType.BASE); else setHorn(HornType.NONE);
			if (Input.pressed(Key.DIGIT_3)) if (wings == WingType.NONE) setWing(WingType.BAT); else setWing(WingType.NONE);
			if (Input.pressed(Key.DIGIT_4)) if (tail == TailType.NONE) setTail(TailType.BASE); else setTail(TailType.NONE);
			if (Input.pressed(Key.DIGIT_5)) if (arms == ArmType.NONE) setArm(ArmType.BASE); else setArm(ArmType.NONE);
			
			if (Input.pressed("UP") )
				tryJump();
				
			if (Input.released("UP") && velY < 0)
				velY *= .3;
			
			if (Input.check("RIGHT"))
				moveRight(C.START_PLAYER_SPEED);
			
			if (Input.check("LEFT"))
				moveLeft(C.START_PLAYER_SPEED);
		}
		
		//Apply velocity and check collisions
		private function updateMovement():void
		{
			velY += C.GRAVITY * floatVar;		//Gravity
			
			if (Input.check("UP") && velY > maxYVel)		//If pressing up 
				velY = maxYVel;												//Float
				
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
					jumpsLeft = totalJumps;		//Reset jump left count
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
		
		private function updateCamera():void
		{
			
			var camXTarg:Number = x + width/2 - FP.halfWidth;
			var camYTarg:Number = y + height / 2 - FP.halfHeight * 1.2;
			
			FP.setCamera(FP.lerp(camXTarg, FP.camera.x, .8), FP.lerp(camYTarg, FP.camera.y, .8));
			if (FP.camera.x < 0)
				FP.camera.x = 0;
			if (FP.camera.x + FP.screen.width > currentLevel.mapWidth)
				FP.camera.x = currentLevel.mapWidth - FP.screen.width;
			if (FP.camera.y + FP.screen.height > currentLevel.mapHeight)
				FP.camera.y = currentLevel.mapHeight - FP.screen.height;
		}
		
	}

}
package com.lionsteel.LD24.entities 
{
	import com.lionsteel.LD24.BodyTypes.*;
	import com.lionsteel.LD24.C;
	import com.lionsteel.LD24.entities.PowerUps.PowerUp;
	import com.lionsteel.LD24.GFX;
	import flash.accessibility.ISearchableText;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundCodec;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
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
		private var maxHealth:int;
		private var defense:int;
		
		private var healthContainer:Image;
		private var healthFiller:Image;
		
		public function Player(level:Level) 
		{
			this.currentLevel = level;
			
			healthContainer = new Image(GFX.HEALTH_CONTAINER);
			healthFiller = new Image(GFX.HEALTH_FILLER);
			tintColor = 0xFFFFFF;
			pushBox = new Entity();
			killBox = new Entity();
			pushBox.width = C.TILE_SIZE;
			pushBox.height = C.TILE_SIZE;
			pushBox.type = "playerPushBox";
			killBox.width = C.TILE_SIZE*1.5;
			killBox.height = C.TILE_SIZE*1.5;
			killBox.type = "playerKillBox";
			super(currentLevel);
			
			health = 3.0;
			maxHealth = 3;
			damage = 1.0;
		}
		
		override public function update():void 
		{
			super.update();
			handleControls();
			updateMovement();
			handleCollision();
			updateCamera();
		}
		
		private function handleEnemyCollision(enemy:Enemy):void
		{
			if (this.velY > 0 && x + width * 2 / 3 > enemy.x && x + width * 1 / 3 < enemy.x + enemy.width)
				{
					if (enemy.horn == HornType.NONE)
					{
						enemy.kill();
						this.velY = jumpForce * .9;
					}
					else
					{
						if (damageCount <= 0)
						{
							bounce(enemy);
							takeDamage(enemy.getDamage());
						}
					}
				}
		}
		
		private function handleCollision():void 
		{
			
			if (damageCount > 0)
				damageCount -= 16;
			
			collisionEntity = collide("Enemy", x, y);
			if (collisionEntity != null)
			{
				handleEnemyCollision(Enemy(collisionEntity));
			}
			collisionEntity = collide("enemyPushBox", x, y);
			if (collisionEntity != null)
			{
				bounce(collisionEntity);
				takeDamage(.4);
			}
			if (Input.check("ATTACK"))
			{
				collisionEntity = collide("PowerUp", x, y);
				if (collisionEntity != null)
				{
					(collisionEntity as PowerUp).pickup(this);
				}
			}
		}
		
		
		private function takeDamage(damageAmount:Number):void
		{
			for (var ind:int = 0; ind < 20; ind ++)
				currentLevel.particleEmitter.emit("death", x + halfWidth, y + halfWidth);
			health -= damageAmount;
			if (health <= 0)
				kill();
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
			if (Input.pressed(Key.DIGIT_4)) if (tail == TailType.NONE) setTail(TailType.SCORPION); else setTail(TailType.NONE);
			if (Input.pressed(Key.DIGIT_5)) if (arms == ArmType.NONE) setArm(ArmType.BASE); else setArm(ArmType.NONE);
			
			if (Input.pressed("UP") )
				tryJump();
				
			if (Input.pressed("ATTACK"))
			{
				tryAttack();
			}
			
			pauseAttack = Input.check("ATTACK");
				
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
			var camYTarg:Number = y + height / 2 - FP.halfHeight * 1.1;
			
			FP.setCamera(FP.lerp(camXTarg, FP.camera.x, .8), FP.lerp(camYTarg, FP.camera.y, .8));
			if (FP.camera.x < 0)
				FP.camera.x = 0;
			if (FP.camera.x + FP.screen.width > currentLevel.mapWidth)
				FP.camera.x = currentLevel.mapWidth - FP.screen.width;
			if (FP.camera.y + FP.screen.height > currentLevel.mapHeight)
				FP.camera.y = currentLevel.mapHeight - FP.screen.height;
		}
		
		override public function render():void 
		{
			if (damageCount <= 0 ||
				damageCount%20 < 10)		//Flash if damaged
				super.render();
			for (var healthInd:Number = 0; healthInd < maxHealth; healthInd++)
			{
				if (health >= healthInd + 1)
					healthFiller.render(FP.buffer, new Point(healthInd * healthContainer.width, 0), new Point());
				else if(health>healthInd)
				{
					var healthRatio:Number = healthInd + 1 - health;
					healthRatio = 1 - healthRatio;
					if (healthRatio > 0.01)
					{
						var partialHealthFiller:Image = new Image(GFX.HEALTH_FILLER, new Rectangle(0, 0, Number(healthFiller.width) * healthRatio, healthFiller.height));
						partialHealthFiller.render(FP.buffer, new Point(healthInd * healthContainer.width, 0), new Point());
					}
				}
				healthContainer.render(FP.buffer, new Point(healthInd * healthContainer.width, 0), new Point());
			}
		}
		
	}

}
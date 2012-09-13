package com.lionsteel.LD24.entities 
{
	import com.lionsteel.LD24.BodyTypes.*;
	import com.lionsteel.LD24.C;
	import com.lionsteel.LD24.GFX;
	import com.lionsteel.LD24.Utils;
	import com.lionsteel.LD24.worlds.GameWorld;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * 
	 * @author Josh Maggard
	 */
	public class Player extends Monster 
	{
		private var lives:int;
		private var defense:int;
		
		private var healthContainer:Image;
		private var healthFiller:Image;
		
		private var livesImage:Image;		
		
		public function Player(level:Level) 
		{
			lives = C.START_LIVES;
			
			healthContainer = new Image(GFX.HEALTH_CONTAINER);
			healthFiller = new Image(GFX.HEALTH_FILLER);
			livesImage = new Image(GFX.LIVES_ICON);
			
			tintColor = 0xFFFFFF;
			
			armPushBox = new Entity();
			armPushBox.width = C.TILE_SIZE;
			armPushBox.height = C.TILE_SIZE;
			armPushBox.type = "playerArmPushBox";
			
			super(currentLevel);
			
			type = "Player";
			health = 3;
			_damage = 1;
		}
		
		override public function update():void 
		{
			super.update();
			handleControls();
			updateMovement();
			handleCollision();
			updateCamera();
			checkLife();
		}
		
		/**
		 * Checks for death (health <= 0) and game over (Lives <= 0)
		 */
		private function checkLife():void
		{
			if (health <= 0)
			{
				if (lives > 0)
				{
					GameWorld(world).resetLevel();
					lives--;
					health = getTotalHearts();
				}
				else {
					GameWorld(this.world).gameOver();
				}
			}
		}
		
		private function handleEnemyCollision(enemy:Enemy):void
		{
			//TODO Enemy collision handling
		/*	//Falling onto enemy
			if (this.velY > 0 && x + width * 2 / 3 > enemy.x && x + width * 1 / 3 < enemy.x + enemy.width)
				{
					if (enemy.horn == HornType.SPIKE)
					{
						if (damageCount <= 0)
						{
							if (enemy.velY < 0)
								enemy.velY = 0;
							bounce(enemy);
							takeDamage(enemy.getDamage());
						}
					
					}
					else
					{
						//Jumped on enemy without spike
						jumpsLeft = getTotalJumps();
						enemy.takeDamage(getDamage());
						enemy.bounce(this);
						enemy.velY = 0;
						if (Input.check("UP"))
							this.velY = getJumpForce() * 1.4;
						else
							this.velY = getJumpForce() * .9;
					}
				}
				else
				if (this.y > enemy.y && enemy.velY > 0 && enemy.x + enemy.width * 2 / 3 > x && enemy.x + enemy.width * 1 / 3 < x + width)	//Enemy Falling onto you
				{
					if (horn == HornType.SPIKE)
					{
						
						enemy.takeDamage(getDamage());
						enemy.bounce(this);
						if (this.velY < 0)
							this.velY = 0;
					}
					else
					{
						
						if (damageCount <= 0)
						{
							takeDamage(enemy.getDamage());
							bounce(enemy);
							enemy.velY = jumpForce;
						}
					}
				}
				else
				if ( damageCount <= 0 && x + width * 2 / 3 > enemy.x && x + width * 1 / 3 < enemy.x + enemy.width)			//Running into enemies
				{
					takeDamage(enemy.getDamage());
					bounce(enemy);
					enemy.bounce(this);
				}
				*/
		}
		
		/**
		 * Handles all player collision (Enemy, Level, etc...)
		 */
		private function handleCollision():void 
		{
			//If we are invulnerable
			if (invulnerabiltyCounter > 0)
				invulnerabiltyCounter -= 16;
			
			collisionEntity = collide("Enemy", x, y);
			if (collisionEntity != null)
			{
				handleEnemyCollision(Enemy(collisionEntity));
			}
			
		}
		
		/**
		 * Takes health away and flashes screen
		 * @param	damageAmount	Amount to subtract from health
		 */
		private function takeDamage(damageAmount:Number):void
		{
			Utils.flash.start(0xFF0000, .1,.5);
			for (var ind:int = 0; ind < 20; ind ++)
				currentLevel.particleEmitter.emit("death", x + halfWidth, y + halfWidth);
			health -= damageAmount;
		}
		
		/**
		 * Sets our current level
		 * @param	level	Level object to set current level to
		 */
		public function setLevel(level:Level):void
		{
			this.currentLevel = level;
		}
		
		/**
		 * Handle all player controls (movement, attack, cheats, etc...)
		 */
		private function handleControls():void
		{
			//{region Cheats
			if (Input.pressed(Key.DIGIT_1)) setLeg(legs+1);// if (legs == LegType.NONE) setLeg(LegType.JABA); else setLeg(LegType.NONE);
			if (Input.pressed(Key.DIGIT_2)) setArm(arms+1);// if (arms == ArmType.NONE) setArm(ArmType.CLAW); else setArm(ArmType.NONE);
			if (Input.pressed(Key.DIGIT_3)) setHorn(horn+1);// if (horn == HornType.NONE) setHorn(HornType.PLANT); else setHorn(HornType.NONE);
			if (Input.pressed(Key.DIGIT_4)) setTail(tail+1);// if (tail == TailType.NONE) setTail(TailType.MONKEY); else setTail(TailType.NONE);
			if (Input.pressed(Key.DIGIT_5)) setWing(wings+1);// if (wings == WingType.NONE) setWing(WingType.TINY); else setWing(WingType.NONE);
			if (Input.pressed(Key.R)){ setLeg( -1); setArm( -1); setHorn( -1); setTail( -1); setWing( -1);}
			if (Input.pressed(Key.K)) health = 0;
			//}endregion
			
			
			if (Input.pressed("UP") )
				tryJump();
				
			if (Input.pressed("ATTACK"))
				tryMelee();
			
			pauseAttack = Input.check("ATTACK");
				
			//If we released jump and we were going up
			// then stop going up so fast!
			if (Input.released("UP") && velY < 0)
				velY *= .3;
			
			if (Input.check("RIGHT"))
				moveRight(C.START_PLAYER_SPEED);
			
			if (Input.check("LEFT"))
				moveLeft(C.START_PLAYER_SPEED);
		}
		
		/**
		 * Apply velocity and check collisions
		 */
		private function updateMovement():void
		{
			velY += C.GRAVITY;		//Gravity
			
			if (Input.check("UP") && velY > maxYVel)		//If pressing up 
				velY = maxYVel;								//Float
				
			//Do X movement and check for collision first
			x += velX;
			//Check right collision (Ceiling)
			var collideXRoom:Entity = collide("level", Math.ceil(x), y);
			if (collideXRoom!=null)
			{
				//Colliding with wall after x movement
				//Resolve!
				if (velX > 0)	//Moving right
					x = collideXRoom.x +Math.floor((x - collideXRoom.x + width) / C.TILE_SIZE) * C.TILE_SIZE - width;		//place to the left of tile we have collided with
					
			}
			//Check left collision (floor)
			collideXRoom = collide("level", Math.floor(x), y);
			if (collideXRoom != null)
			{
				if(velX<0)		//Moving left
					x = collideXRoom.x + Math.floor((x- collideXRoom.x) / C.TILE_SIZE) * C.TILE_SIZE + C.TILE_SIZE;		//place to the right of tile we have collided with
				
			}
			
			//Update y movement and then check collision
			y += velY
			var collideYRoom:Entity = collide("level", x,Math.ceil(y));	//Check bottom collision first
			if (collideYRoom != null)
			{
				//If colliding with wall after y movement
				//Resolve position
				if (velY > 0)		//Moving down
				{
					
					y = collideYRoom.y + Math.floor((y-collideYRoom.y + height) / C.TILE_SIZE) * C.TILE_SIZE - height;		//Place at the top of the tile they have collided with
					velY = 0;
					grounded = true;
					jumpsLeft = getTotalJumps();		//Reset jump left count
				}
				
			}
			else
				grounded = false;
				
			//Check collision with top
			collideYRoom = collide("level", x, Math.floor(y));
			if(collideYRoom != null)
			{
				if (velY < 0)
				{
					y = collideYRoom.y + Math.floor((y - collideYRoom.y ) / C.TILE_SIZE)  * C.TILE_SIZE + C.TILE_SIZE;		//Place at the bottom of the tile they have collided with
					velY *= .5;
				}
					
					
			}
			
			//Apply friction to x vel only
			velX *= friction;
		}
		
		/**
		 * Simply lerp the camera to where the player is centered. 
		 * (Actually he is closer to the bottom of the screen... but whatever)
		 */
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
		
		/**
		 * Draws the heart health bar
		 */
		private function drawHealth():void
		{
			
			//Go through all hearts
			for (var healthInd:Number = 0; healthInd < getTotalHearts(); healthInd++)
			{
				//If this heart is full go ahead and draw the whole full heart
				if (health >= healthInd + 1)
					healthFiller.render(FP.buffer, new Point(healthInd * healthContainer.width, 0), new Point());
				else if(health>healthInd)		//Else if it is not full only draw a portion of the heart
				{
					var healthRatio:Number = healthInd + 1 - health;
					healthRatio = 1 - healthRatio;
					//Health ratio = the portion of the heart that should be filled
					if (healthRatio > 0.1)		//This is here basically so that we don't divide by zero
					{
						//Get the partial heart image that we need for our health fraction and draw it
						var partialHealthFiller:Image = new Image(GFX.HEALTH_FILLER, new Rectangle(0, 0, Number(healthFiller.width) * healthRatio, healthFiller.height));
						partialHealthFiller.render(FP.buffer, new Point(healthInd * healthContainer.width, 0), new Point());
					}
				}
				//Always draw all the heart outlines
				healthContainer.render(FP.buffer, new Point(healthInd * healthContainer.width, 0), new Point());
			}
		}
		
		/**
		 * Overridden render function so that we can draw health and flash if damaged
		 */
		override public function render():void 
		{
			if (invulnerabiltyCounter <= 0 ||
				invulnerabiltyCounter % 20 < 10)		//Flash if damaged
			{
				super.render();
			}
			
			//Draw health bar
			drawHealth();
			
		}
		
	}
}
package com.lionsteel.LD24.entities 
{
	import com.lionsteel.LD24.BodyTypes.*;
	import com.lionsteel.LD24.C;
	import com.lionsteel.LD24.GFX;
	import com.lionsteel.LD24.Kongregate;
	import com.lionsteel.LD24.Main;
	import com.lionsteel.LD24.Utils;
	import com.lionsteel.LD24.worlds.DescendantScreen;
	import com.lionsteel.LD24.worlds.GameOver;
	import com.lionsteel.LD24.worlds.GameWorld;
	import flash.accessibility.ISearchableText;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundCodec;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
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
		private var lives:int;
		private var defense:int;
		
		private var healthContainer:Image;
		private var healthFiller:Image;
		
		public var evolution:int = 0;
		
		private var armKillCount:int = 0;
		private var legKillCount:int = 0;
		private var hornKillCount:int = 0;
		private var wingKillCount:int = 0;
		private var tailKillCount:int = 0;
		
		//Keep track of types of kills
		private var armKillType:int = -1;
		private var legKillType: int = -1;
		private var hornKillType:int = -1;
		private var wingKillType:int = -1;
		private var tailKillType:int = -1;
		
		//Graphics for the kill counts		
		private var armKillColorImage:Image;
		private var legKillColorImage:Image;
		private var hornKillColorImage:Image;
		private var wingKillColorImage:Image;
		private var tailKillColorImage:Image;
		
		private var traitHolderImage:Image;
		private var traitLockImage:Image;
		private var livesImage:Image;
		
		private var emptyKillCount:Image;
		
		
		public function Player(level:Level) 
		{
			lives = 3;
			emptyKillCount = new Image(GFX.TRAIT_BOX);
			traitLockImage = new Image(GFX.TRAIT_LOCKED);
			healthContainer = new Image(GFX.HEALTH_CONTAINER);
			healthFiller = new Image(GFX.HEALTH_FILLER);
			traitHolderImage = new Image(GFX.TRAIT_HOLDER);
			livesImage = new Image(GFX.LIVES_ICON);
			traitHolderImage.alpha = .9;
			
			tintColor = 0xFFFFFF;
			
			armPushBox = new Entity();
			tailPushBox= new Entity();
			armPushBox.width = C.TILE_SIZE;
			armPushBox.height = C.TILE_SIZE;
			armPushBox.type = "playerArmPushBox";
			tailPushBox.width = C.TILE_SIZE*2;
			tailPushBox.height = C.TILE_SIZE*2;
			tailPushBox.type = "playerTailPushBox";
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
			
			if (world == null)
				return;
		}
		
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
			
			/*//Falling onto enemy
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
				}*/
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
		}
		
		private function takeDamage(damageAmount:Number):void
		{
			Utils.flash.start(0xFF0000, .1,.5);
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
			 //Cheats
			if (Input.pressed(Key.DIGIT_1)) setLeg(legs+1);// if (legs == LegType.NONE) setLeg(LegType.JABA); else setLeg(LegType.NONE);
			if (Input.pressed(Key.DIGIT_2)) setArm(arms+1);// if (arms == ArmType.NONE) setArm(ArmType.CLAW); else setArm(ArmType.NONE);
			if (Input.pressed(Key.DIGIT_3)) setHorn(horn+1);// if (horn == HornType.NONE) setHorn(HornType.PLANT); else setHorn(HornType.NONE);
			if (Input.pressed(Key.DIGIT_4)) setTail(tail+1);// if (tail == TailType.NONE) setTail(TailType.MONKEY); else setTail(TailType.NONE);
			if (Input.pressed(Key.DIGIT_5)) setWing(wings+1);// if (wings == WingType.NONE) setWing(WingType.TINY); else setWing(WingType.NONE);
			if (Input.pressed(Key.R)){ setLeg( -1); setArm( -1); setHorn( -1); setTail( -1); setWing( -1);}
			if (Input.pressed(Key.K)) health = 0;
			
			
			
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
			velY += C.GRAVITY;		//Gravity
			
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
					jumpsLeft = getTotalJumps();		//Reset jump left count
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
		
		private function drawHealth():void
		{
			
			
			for (var healthInd:Number = 0; healthInd < getTotalHearts(); healthInd++)
			{
				if (health >= healthInd + 1)
					healthFiller.render(FP.buffer, new Point(healthInd * healthContainer.width, 0), new Point());
				else if(health>healthInd)
				{
					var healthRatio:Number = healthInd + 1 - health;
					healthRatio = 1 - healthRatio;
					if (healthRatio > 0.1)
					{
						var partialHealthFiller:Image = new Image(GFX.HEALTH_FILLER, new Rectangle(0, 0, Number(healthFiller.width) * healthRatio, healthFiller.height));
						partialHealthFiller.render(FP.buffer, new Point(healthInd * healthContainer.width, 0), new Point());
					}
				}
				healthContainer.render(FP.buffer, new Point(healthInd * healthContainer.width, 0), new Point());
			}
		}
		
		override public function render():void 
		{
			if (damageCount <= 0 ||
				damageCount % 20 < 10)		//Flash if damaged
			{
				super.render();
			}
			
			drawHealth();
			
		}
		
	}
}
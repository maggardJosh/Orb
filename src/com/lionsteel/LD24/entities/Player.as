package com.lionsteel.LD24.entities 
{
	import com.lionsteel.LD24.BodyTypes.*;
	import com.lionsteel.LD24.C;
	import com.lionsteel.LD24.dropIndicator;
	import com.lionsteel.LD24.entities.PowerUps.ArmEvolution;
	import com.lionsteel.LD24.entities.PowerUps.HornEvolution;
	import com.lionsteel.LD24.entities.PowerUps.LegEvolution;
	import com.lionsteel.LD24.entities.PowerUps.PowerUp;
	import com.lionsteel.LD24.entities.PowerUps.TailEvolution;
	import com.lionsteel.LD24.entities.PowerUps.WingEvolution;
	import com.lionsteel.LD24.GFX;
	import com.lionsteel.LD24.killIndicator;
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
		
		private var emptyKillCount:Image;
		
		private var tempPowerUp:PowerUp;
		private var locked:Array = new Array;
		
		
		
		public function Player(level:Level) 
		{
			locked[EvolutionTypes.ARM_EVOLUTION] = false;
			locked[EvolutionTypes.HORN_EVOLUTION] = false;
			locked[EvolutionTypes.LEG_EVOLUTION] = false;
			locked[EvolutionTypes.TAIL_EVOLUTION] = false;
			locked[EvolutionTypes.WING_EVOLUTION] = false;
			
			emptyKillCount = new Image(GFX.TRAIT_BOX);
			traitLockImage = new Image(GFX.TRAIT_LOCKED);
			healthContainer = new Image(GFX.HEALTH_CONTAINER);
			healthFiller = new Image(GFX.HEALTH_FILLER);
			traitHolderImage = new Image(GFX.TRAIT_HOLDER);
			
			traitHolderImage.alpha = .7;
			
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
			type = "Player";
			health = 3.0;
			maxHealth = 3;
			damage = 1.0
		}
		
		override public function update():void 
		{
			super.update();
			handleControls();
			updateMovement();
			handleCollision();
			updateCamera();
			
			if (world == null)
				return;
			checkKillCounts();
		}
		
		private function checkKillCounts():void
		{
			if (legKillCount > 0 && legKillCount >= LegType.KILL_COUNT[legKillType])
			{
				world.add(new dropIndicator(LegType.KILL_COLOR_IMAGES[legKillType], new Point(C.KILL_COUNT_START_X ).add(FP.camera), new Point(x, y)))
				legKillCount = 0;
				world.add(new LegEvolution(legKillType, new Point(x, y)));
			}
			if (armKillCount > 0 && armKillCount >= ArmType.KILL_COUNT[armKillType])
			{
				world.add(new dropIndicator(ArmType.KILL_COLOR_IMAGES[armKillType], new Point(C.KILL_COUNT_START_X + C.KILL_X_SPACING).add(FP.camera), new Point(x, y)))
				armKillCount = 0;
				world.add(new ArmEvolution(armKillType, new Point(x, y)));
			}
			if (hornKillCount > 0 && hornKillCount >= HornType.KILL_COUNT[armKillType])
			{
				world.add(new dropIndicator(HornType.KILL_COLOR_IMAGES[hornKillType], new Point(C.KILL_COUNT_START_X + C.KILL_X_SPACING * 2).add(FP.camera), new Point(x, y)))
				hornKillCount = 0;
				world.add(new HornEvolution(hornKillType, new Point(x, y)));
			}
			if (tailKillCount > 0 && tailKillCount >= TailType.KILL_COUNT[tailKillType])
			{
				world.add(new dropIndicator(TailType.KILL_COLOR_IMAGES[tailKillType], new Point(C.KILL_COUNT_START_X + C.KILL_X_SPACING * 3).add(FP.camera), new Point(x, y)))
				tailKillCount = 0;
				world.add(new TailEvolution(tailKillType, new Point(x, y)));
			}
			if (wingKillCount > 0 && wingKillCount >= WingType.KILL_COUNT[wingKillType])
			{
				world.add(new dropIndicator(WingType.KILL_COLOR_IMAGES[wingKillType], new Point(C.KILL_COUNT_START_X + C.KILL_X_SPACING * 4).add(FP.camera), new Point(x, y)))
				wingKillCount = 0;
				world.add(new WingEvolution(wingKillType, new Point(x, y)));
			}
		}
		
		private function handleEnemyCollision(enemy:Enemy):void
		{
			//if (enemy.damageCount > 0 )
			//	return;
			//Falling onto enemy
			if (this.velY > 0 && x + width * 2 / 3 > enemy.x && x + width * 1 / 3 < enemy.x + enemy.width)
				{
					if (enemy.horn == HornType.NONE)
					{
						enemy.takeDamage(damage * 1.5);
						enemy.bounce(this);
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
				else
				if (this.y > enemy.y && enemy.velY > 0 && enemy.x + enemy.width * 2 / 3 > x && enemy.x + enemy.width * 1 / 3 < x + width)
				{
					if (horn == HornType.NONE && damageCount <= 0)
					{
						takeDamage(enemy.getDamage());
						bounce(enemy);
					}
					else
					{
						enemy.takeDamage(damage * 1.5);
						enemy.bounce(this);
					}
				}
				else
				if ( damageCount <= 0 && x + width * 2 / 3 > enemy.x && x + width * 1 / 3 < enemy.x + enemy.width)		//If
				{
					takeDamage(enemy.getDamage());
					bounce(enemy);
				}
		}
		
		public function addArmKill(armType:int):void
		{
			if (armKillType == armType)
				armKillCount++;
			else
				resetArmKillCount(armType);
				
				refreshArmKillColor();
		}
		
		public function refreshArmKillColor():void
		{
			var ratio:Number = Number(armKillCount)/ Number(ArmType.KILL_COUNT[armKillType]);
			armKillColorImage = new Image(ArmType.KILL_COLOR_IMAGES[armKillType], new Rectangle(0,ArmType.KILL_IMAGES[armKillType].height*(1-ratio) , ArmType.KILL_IMAGES[armKillType].width, ArmType.KILL_IMAGES[armKillType].height*ratio));
		}
		
		private function resetArmKillCount(armType:int):void
		{
			armKillCount = 1;
			armKillType = armType;

		}
		
		
		public function addWingKill(wingType:int):void
		{
			if (wingKillType == wingType)
				wingKillCount++;
			else
				resetWingKillCount(wingType);
				
				refreshWingKillColor();
		}
		
		public function refreshWingKillColor():void
		{
			var ratio:Number = Number(wingKillCount)/ Number(WingType.KILL_COUNT[wingKillType]);
			wingKillColorImage = new Image(WingType.KILL_COLOR_IMAGES[wingKillType], new Rectangle(0,WingType.KILL_IMAGES[wingKillType].height*(1-ratio) , WingType.KILL_IMAGES[wingKillType].width, WingType.KILL_IMAGES[wingKillType].height*ratio));
		}
		
		private function resetWingKillCount(wingType:int):void
		{
			wingKillCount = 1;
			wingKillType = wingType;

		}
		
		public function addHornKill(hornType:int):void
		{
			if (hornKillType == hornType)
				hornKillCount++;
			else
				resetHornKillCount(hornType);
				
			refreshHornKillColor();
		}
		
		public function refreshHornKillColor():void
		{
			var ratio:Number = Number(hornKillCount)/ Number(HornType.KILL_COUNT[hornKillType]);
			hornKillColorImage = new Image(HornType.KILL_COLOR_IMAGES[hornKillType], new Rectangle(0,HornType.KILL_IMAGES[hornKillType].height*(1-ratio) , HornType.KILL_IMAGES[hornKillType].width, HornType.KILL_IMAGES[hornKillType].height*ratio));
		}
		
		private function resetHornKillCount(hornType:int):void
		{
			hornKillCount = 1;
			hornKillType = hornType;

		}
		
		public function addLegKill(legType:int):void
		{
			if (legKillType == legType)
				legKillCount++;
			else
				resetLegKillCount(legType);
				
				refreshLegKillColor();
		}
		
		public function refreshLegKillColor():void
		{
			var ratio:Number = Number(legKillCount)/ Number(LegType.KILL_COUNT[legKillType]);

			legKillColorImage = new Image(LegType.KILL_COLOR_IMAGES[legKillType], new Rectangle(0,LegType.KILL_IMAGES[legKillType].height*(1-ratio) , LegType.KILL_IMAGES[legKillType].width, LegType.KILL_IMAGES[legKillType].height*ratio));
		}
		
		private function resetLegKillCount(legType:int):void
		{
			legKillCount = 1;
			legKillType = legType;

		}
		
		
		public function addTailKill(tailType:int):void
		{
			if (tailKillType == tailType)
				tailKillCount++;
			else
				resetTailKillCount(tailType);
				
				refreshTailKillColor();
		}
		
		public function refreshTailKillColor():void
		{
			var ratio:Number = Number(tailKillCount)/ Number(TailType.KILL_COUNT[tailKillType]);
			tailKillColorImage = new Image(TailType.KILL_COLOR_IMAGES[tailKillType], new Rectangle(0,TailType.KILL_IMAGES[tailKillType].height*(1-ratio) , TailType.KILL_IMAGES[tailKillType].width, TailType.KILL_IMAGES[tailKillType].height*ratio));
		}
		
		private function resetTailKillCount(armType:int):void
		{
			tailKillCount = 1;
			tailKillType = armType;

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
			if (Input.pressed("INTERACT"))
			{
				collisionEntity = collide("PowerUp", x, y);
				
				if (collisionEntity != null)
				{
					if (tempPowerUp != null)
					{
						tempPowerUp.drop(this);
					}
					(collisionEntity as PowerUp).pickup(this);
				}
				
				collisionEntity = collide("Mate", x, y);
				if (collisionEntity != null)
				{
					mate(Mate(collisionEntity));
				}
			}
		}
		
		private function mate(mate:Mate):void
		{
			
			var copyOfSelf:Monster = copy();
			world.add(copyOfSelf);
			this.setArm(ArmType.NONE);
			this.setLeg(LegType.NONE);
			this.setWing(WingType.NONE);
			this.setTail(TailType.NONE);
			this.setHorn(HornType.NONE);
			
			
			for (var step:int = 0; step < EvolutionTypes.NUM_EVOLUTIONS; step++)
				locked[step] = false;
				
			this.evolution++;
			var gotAttrib:Boolean = false;
			for (var step:int= 0; step < evolution; step++)
			{
				
				gotAttrib = false;
				if (FP.random < .5)
				{
					//Use yours
					switch(FP.rand(EvolutionTypes.NUM_EVOLUTIONS))
					{
						case EvolutionTypes.ARM_EVOLUTION:
								if (copyOfSelf.arms != ArmType.NONE)
								{
									gotAttrib =addArm(copyOfSelf.arms);
									if (gotAttrib)
										locked[EvolutionTypes.ARM_EVOLUTION] = true;
								}
							break;
						case EvolutionTypes.HORN_EVOLUTION:
							if (copyOfSelf.horn != HornType.NONE)
							{
								gotAttrib = addHorn(copyOfSelf.horn);
								if (gotAttrib)
									locked[EvolutionTypes.HORN_EVOLUTION] = true;
							}
							break;
						case EvolutionTypes.LEG_EVOLUTION:
							if (copyOfSelf.legs != LegType.NONE)
							{
								gotAttrib = addLeg(copyOfSelf.legs);
								if (gotAttrib)
									locked[EvolutionTypes.LEG_EVOLUTION] = true;
							}
							break;
						case EvolutionTypes.TAIL_EVOLUTION:
							if (copyOfSelf.tail != TailType.NONE)
							{
								gotAttrib = addTail(copyOfSelf.tail);
								if (gotAttrib)
									locked[EvolutionTypes.TAIL_EVOLUTION] = true;
							}
							break;
						case EvolutionTypes.WING_EVOLUTION:
							if (copyOfSelf.wings != WingType.NONE)
							{
								gotAttrib = addWing(copyOfSelf.wings);
								if (gotAttrib)
									locked[EvolutionTypes.WING_EVOLUTION] = true;
							}
							break;
					}
					
				}
				else
				{
					//Use your mate's
					switch(FP.rand(EvolutionTypes.NUM_EVOLUTIONS))
					{
						case EvolutionTypes.ARM_EVOLUTION:
								if (mate.arms != ArmType.NONE)
								{
									gotAttrib = addArm(mate.arms);
									if (gotAttrib)
										locked[EvolutionTypes.ARM_EVOLUTION] = true;
								}
							break;
						case EvolutionTypes.HORN_EVOLUTION:
							if (mate.horn != HornType.NONE)
							{
								gotAttrib = addHorn(mate.horn);
								if (gotAttrib)
									locked[EvolutionTypes.HORN_EVOLUTION] = true;
							}
							break;
						case EvolutionTypes.LEG_EVOLUTION:
							if (mate.legs != LegType.NONE)
							{
								gotAttrib = addLeg(mate.legs);
								if (gotAttrib)
									locked[EvolutionTypes.LEG_EVOLUTION] = true;
							}
							break;
						case EvolutionTypes.TAIL_EVOLUTION:
							if (mate.tail != TailType.NONE)
							{
								gotAttrib = addTail(mate.tail);
								if (gotAttrib)
									locked[EvolutionTypes.TAIL_EVOLUTION] = true;
							}
							break;
						case EvolutionTypes.WING_EVOLUTION:
							if (mate.wings != WingType.NONE)
							{
								gotAttrib = addWing(mate.wings);
								if (gotAttrib)
									locked[EvolutionTypes.WING_EVOLUTION] = true;
							}
							break;
					}
				}
				if (!gotAttrib)
					step--;
			}
			GameWorld(this.world).nextLevel();
		}
		
		
		public function setTempPowerUp(powerUp:PowerUp):void
		{
				tempPowerUp = powerUp;
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
			if (Input.pressed(Key.DIGIT_2)) if (horn == HornType.NONE) setHorn(HornType.SPIKE); else setHorn(HornType.NONE);
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
		
		private function drawKillCounts():void
		{
			var ratio:Number;
			for (var ind:int = 0; ind < 5; ind++)
				emptyKillCount.render(FP.buffer, new Point(C.KILL_COUNT_START_X + C.KILL_X_SPACING * ind, 0), new Point());
			if (legKillCount != 0)
			{
				ratio = (legKillCount)/ (LegType.KILL_COUNT[legKillType]);
 				LegType.KILL_IMAGES[legKillType].render(FP.buffer, new Point(C.KILL_COUNT_START_X, 0), new Point());
				legKillColorImage.render(FP.buffer, new Point(C.KILL_COUNT_START_X, LegType.KILL_IMAGES[legKillType].height*(1-ratio)), new Point());
			}
			if (armKillCount != 0)
			{
				ratio = (armKillCount)/ (ArmType.KILL_COUNT[armKillType]);
				ArmType.KILL_IMAGES[armKillType].render(FP.buffer, new Point(C.KILL_COUNT_START_X+ C.KILL_X_SPACING, 0), new Point());
				armKillColorImage.render(FP.buffer, new Point(C.KILL_COUNT_START_X+C.KILL_X_SPACING, ArmType.KILL_IMAGES[armKillType].height*(1-ratio)), new Point());
			}
			if (hornKillCount != 0)
			{
				ratio= (hornKillCount)/ (HornType.KILL_COUNT[hornKillType]);
				HornType.KILL_IMAGES[hornKillType].render(FP.buffer, new Point(C.KILL_COUNT_START_X+ C.KILL_X_SPACING*2, 0), new Point());
				hornKillColorImage.render(FP.buffer, new Point(C.KILL_COUNT_START_X + C.KILL_X_SPACING * 2, HornType.KILL_IMAGES[hornKillType].height * (1 - ratio)), new Point());
			}
			if (tailKillCount != 0)
			{
				ratio = (tailKillCount)/ (TailType.KILL_COUNT[tailKillType]);
				TailType.KILL_IMAGES[tailKillType].render(FP.buffer, new Point(C.KILL_COUNT_START_X+ C.KILL_X_SPACING*3, 0), new Point());
				tailKillColorImage.render(FP.buffer, new Point(C.KILL_COUNT_START_X + C.KILL_X_SPACING * 3, TailType.KILL_IMAGES[tailKillType].height * (1 - ratio)), new Point());
			}
			if (wingKillCount != 0)
			{
				 ratio= (wingKillCount)/ (WingType.KILL_COUNT[wingKillType]);
				WingType.KILL_IMAGES[wingKillType].render(FP.buffer, new Point(C.KILL_COUNT_START_X+ C.KILL_X_SPACING*4, 0), new Point());
				wingKillColorImage.render(FP.buffer, new Point(C.KILL_COUNT_START_X + C.KILL_X_SPACING * 4, WingType.KILL_IMAGES[wingKillType].height * (1 - ratio)), new Point());
			}
			
		}
		
		override public function render():void 
		{
			if (damageCount <= 0 ||
				damageCount % 20 < 10)		//Flash if damaged
			{
				super.render();
			}
			traitHolderImage.render(FP.buffer, C.TRAIT_HOLDER_POS, new Point);
			
			
			if (legs != LegType.NONE)
			{
				LegType.IMAGE[legs].render(FP.buffer, C.LEG_POWERUP_POS, new Point());
			}
			if (arms != ArmType.NONE)
			{
				ArmType.IMAGE[arms].render(FP.buffer, C.ARM_POWERUP_POS, new Point());
			}
			if (horn != HornType.NONE)
			{
				HornType.IMAGE[horn].render(FP.buffer, C.HORN_POWERUP_POS, new Point());
			}
			if (tail != TailType.NONE)
			{
				TailType.IMAGE[tail].render(FP.buffer, C.TAIL_POWERUP_POS, new Point());
			}
			if(wings != WingType.NONE)
			{
				WingType.IMAGE[wings].render(FP.buffer, C.WING_POWERUP_POS, new Point());
			}
			
			if (locked[EvolutionTypes.LEG_EVOLUTION])
				traitLockImage.render(FP.buffer, C.LEG_POWERUP_POS, new Point());
				if (locked[EvolutionTypes.ARM_EVOLUTION])
				traitLockImage.render(FP.buffer, C.ARM_POWERUP_POS, new Point());
				if (locked[EvolutionTypes.TAIL_EVOLUTION])
				traitLockImage.render(FP.buffer, C.TAIL_POWERUP_POS, new Point());
				if (locked[EvolutionTypes.WING_EVOLUTION])
				traitLockImage.render(FP.buffer, C.WING_POWERUP_POS, new Point());
				if (locked[EvolutionTypes.HORN_EVOLUTION])
				traitLockImage.render(FP.buffer, C.HORN_POWERUP_POS, new Point());
			
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
			drawKillCounts();
		}
		
	}

}
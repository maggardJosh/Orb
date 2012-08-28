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
			checkKillCounts();
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
		
		private function checkKillCounts():void
		{
			if (legKillCount > 0 && legKillCount >= LegType.KILL_COUNT[legKillType])
			{
				world.add(new dropIndicator(LegType.KILL_COLOR_IMAGES[legKillType], new Point(C.KILL_COUNT_START_X ).add(FP.camera), new Point(x, y)))
				legKillCount = 0;
				currentLevel.add(new LegEvolution(legKillType, new Point(x, y)));
			}
			if (armKillCount > 0 && armKillCount >= ArmType.KILL_COUNT[armKillType])
			{
				world.add(new dropIndicator(ArmType.KILL_COLOR_IMAGES[armKillType], new Point(C.KILL_COUNT_START_X + C.KILL_X_SPACING).add(FP.camera), new Point(x, y)))
				armKillCount = 0;
				currentLevel.add(new ArmEvolution(armKillType, new Point(x, y)));
			}
			if (hornKillCount > 0 && hornKillCount >= HornType.KILL_COUNT[hornKillType])
			{
				world.add(new dropIndicator(HornType.KILL_COLOR_IMAGES[hornKillType], new Point(C.KILL_COUNT_START_X + C.KILL_X_SPACING * 2).add(FP.camera), new Point(x, y)))
				hornKillCount = 0;
				currentLevel.add(new HornEvolution(hornKillType, new Point(x, y)));
			}
			if (tailKillCount > 0 && tailKillCount >= TailType.KILL_COUNT[tailKillType])
			{
				world.add(new dropIndicator(TailType.KILL_COLOR_IMAGES[tailKillType], new Point(C.KILL_COUNT_START_X + C.KILL_X_SPACING * 3).add(FP.camera), new Point(x, y)))
				tailKillCount = 0;
				currentLevel.add(new TailEvolution(tailKillType, new Point(x, y)));
			}
			if (wingKillCount > 0 && wingKillCount >= WingType.KILL_COUNT[wingKillType])
			{
				world.add(new dropIndicator(WingType.KILL_COLOR_IMAGES[wingKillType], new Point(C.KILL_COUNT_START_X + C.KILL_X_SPACING * 4).add(FP.camera), new Point(x, y)))
				wingKillCount = 0;
				currentLevel.add(new WingEvolution(wingKillType, new Point(x, y)));
			}
		}
		
		private function handleEnemyCollision(enemy:Enemy):void
		{
			//Falling onto enemy
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
					(collisionEntity as PowerUp).pickup(this)
				}
				
				collisionEntity = collide("Mate", x, y);
				if (collisionEntity != null)
				{
					if (GameWorld(world).levelNum == 0)
					{						
						currentLevel.clearLevel();
						FP.world.remove(this);
						FP.world = new GameWorld(1, new Player(currentLevel));
					}
					else
					mate(Mate(collisionEntity));
				}
			}
		}
		
		private function mate(mate:Mate):void
		{
			
			if (GameWorld(world).levelNum+1 >= GameWorld(world).levels.length)
			{
				Main.DescendantHistory.push(copy());
				FP.world.remove(this);
				FP.world = new GameOver();
				Kongregate.submit("BeatGame", 1);
				return;
			}
			var copyOfSelf:Monster = copy();
			currentLevel.add(copyOfSelf);
			this.setArm(ArmType.NONE);
			this.setLeg(LegType.NONE);
			this.setWing(WingType.NONE);
			this.setTail(TailType.NONE);
			this.setHorn(HornType.NONE);
			this.tempPowerUp = null;
			this.health = getTotalHearts();
			
			for (var step:int = 0; step < EvolutionTypes.NUM_EVOLUTIONS; step++)
				locked[step] = false;
			this.evolution++;
			if (evolution > EvolutionTypes.NUM_EVOLUTIONS)
				evolution = EvolutionTypes.NUM_EVOLUTIONS;
			var gotAttrib:Boolean = false;
			for (step = 0; step < evolution; step++)
			{
				tempPowerUp = null;
				gotAttrib = false;
				if (FP.random < .5)
				{
					//Use yours
					switch(FP.rand(EvolutionTypes.NUM_EVOLUTIONS))
					{
						case EvolutionTypes.ARM_EVOLUTION:
								if (copyOfSelf.arms != ArmType.NONE && !locked[EvolutionTypes.ARM_EVOLUTION])
								{
									gotAttrib =addArm(copyOfSelf.arms);
									if (gotAttrib)
										locked[EvolutionTypes.ARM_EVOLUTION] = true;
								}
							break;
						case EvolutionTypes.HORN_EVOLUTION:
							if (copyOfSelf.horn != HornType.NONE && !locked[EvolutionTypes.HORN_EVOLUTION])
							{
								gotAttrib = addHorn(copyOfSelf.horn);
								if (gotAttrib)
									locked[EvolutionTypes.HORN_EVOLUTION] = true;
							}
							break;
						case EvolutionTypes.LEG_EVOLUTION:
							if (copyOfSelf.legs != LegType.NONE && !locked[EvolutionTypes.LEG_EVOLUTION])
							{
								gotAttrib = addLeg(copyOfSelf.legs);
								if (gotAttrib)
									locked[EvolutionTypes.LEG_EVOLUTION] = true;
							}
							break;
						case EvolutionTypes.TAIL_EVOLUTION:
							if (copyOfSelf.tail != TailType.NONE && !locked[EvolutionTypes.TAIL_EVOLUTION])
							{
								gotAttrib = addTail(copyOfSelf.tail);
								if (gotAttrib)
									locked[EvolutionTypes.TAIL_EVOLUTION] = true;
							}
							break;
						case EvolutionTypes.WING_EVOLUTION:
							if (copyOfSelf.wings != WingType.NONE && !locked[EvolutionTypes.WING_EVOLUTION])
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
								if (mate.arms != ArmType.NONE && !locked[EvolutionTypes.ARM_EVOLUTION])
								{
									gotAttrib = addArm(mate.arms);
									if (gotAttrib)
										locked[EvolutionTypes.ARM_EVOLUTION] = true;
								}
							break;
						case EvolutionTypes.HORN_EVOLUTION:
							if (mate.horn != HornType.NONE && !locked[EvolutionTypes.HORN_EVOLUTION])
							{
								gotAttrib = addHorn(mate.horn);
								if (gotAttrib)
									locked[EvolutionTypes.HORN_EVOLUTION] = true;
							}
							break;
						case EvolutionTypes.LEG_EVOLUTION:
							if (mate.legs != LegType.NONE && !locked[EvolutionTypes.LEG_EVOLUTION])
							{
								gotAttrib = addLeg(mate.legs);
								if (gotAttrib)
									locked[EvolutionTypes.LEG_EVOLUTION] = true;
							}
							break;
						case EvolutionTypes.TAIL_EVOLUTION:
							if (mate.tail != TailType.NONE && !locked[EvolutionTypes.TAIL_EVOLUTION])
							{
								gotAttrib = addTail(mate.tail);
								if (gotAttrib)
									locked[EvolutionTypes.TAIL_EVOLUTION] = true;
							}
							break;
						case EvolutionTypes.WING_EVOLUTION:
							if (mate.wings != WingType.NONE && !locked[EvolutionTypes.WING_EVOLUTION])
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
			currentLevel.clearLevel();
			FP.world.remove(this);
			FP.world = new DescendantScreen(copyOfSelf, mate, this,  GameWorld(FP.world).levelNum+ 1);
		}
		
		
		public function setTempPowerUp(powerUp:PowerUp):void
		{
				tempPowerUp = powerUp;
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
			/* Cheats
			if (Input.pressed(Key.DIGIT_1)) setLeg(legs+1);// if (legs == LegType.NONE) setLeg(LegType.JABA); else setLeg(LegType.NONE);
			if (Input.pressed(Key.DIGIT_2)) setArm(arms+1);// if (arms == ArmType.NONE) setArm(ArmType.CLAW); else setArm(ArmType.NONE);
			if (Input.pressed(Key.DIGIT_3)) setHorn(horn+1);// if (horn == HornType.NONE) setHorn(HornType.PLANT); else setHorn(HornType.NONE);
			if (Input.pressed(Key.DIGIT_4)) setTail(tail+1);// if (tail == TailType.NONE) setTail(TailType.MONKEY); else setTail(TailType.NONE);
			if (Input.pressed(Key.DIGIT_5)) setWing(wings+1);// if (wings == WingType.NONE) setWing(WingType.TINY); else setWing(WingType.NONE);
			if (Input.pressed(Key.R)){ setLeg( -1); setArm( -1); setHorn( -1); setTail( -1); setWing( -1);}
			if (Input.pressed(Key.K)) health = 0;
			*/
			
			
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
			drawLives();
			drawKillCounts();
			
		}
		
		private function drawLives():void
		{
			for (var ind:int = 0; ind < lives; ind++)
			{
				livesImage.render(FP.buffer, new Point(0 + livesImage.width * ind, healthContainer.height), new Point());
			}
		}
	}
}
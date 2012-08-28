package com.lionsteel.LD24.entities 
{
	import com.lionsteel.LD24.AI_STATE;
	import com.lionsteel.LD24.BodyTypes.*;
	import com.lionsteel.LD24.C;
	import com.lionsteel.LD24.entities.PowerUps.ArmEvolution;
	import com.lionsteel.LD24.entities.PowerUps.HornEvolution;
	import com.lionsteel.LD24.entities.PowerUps.LegEvolution;
	import com.lionsteel.LD24.entities.PowerUps.TailEvolution;
	import com.lionsteel.LD24.entities.PowerUps.WingEvolution;
	import com.lionsteel.LD24.GFX;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Josh Maggard
	 */
	public class Enemy extends Monster 
	{
		private var collideRoom:Entity;
		private var stateCounter:int;
		
		private var enemyAI:int;
		
		public function Enemy(numEvolutions:int, level:Level) 
		{
			
			armPushBox = new Entity();
			tailPushBox = new Entity();
			armPushBox.type = "EnemyArmPushBox";
			tailPushBox.type = "EnemyTailPushBox";
			if (FP.random < .5)
				tintColor = 0xFF8888;
			else
				tintColor = 0x888888;
			super(level);
			health = numEvolutions +1;
			type = "Enemy";
			_damage = .3;
			var hasEvolved:Boolean = false;
			for ( var x:int = 0; x < numEvolutions; x++)
			{
				hasEvolved = false;
				var upgrade:int = FP.rand(EvolutionTypes.NUM_EVOLUTIONS);
				switch(upgrade)
				{
					case EvolutionTypes.ARM_EVOLUTION:
						if(FP.random < .5)
							hasEvolved = addArm(ArmType.BASE);
						else
							hasEvolved = addArm(ArmType.CLAW);
						break;
					case EvolutionTypes.HORN_EVOLUTION:
						if(FP.random <.5)
							hasEvolved = addHorn(HornType.SPIKE);
						else
							hasEvolved = addHorn(HornType.PLANT);
						break;
					case EvolutionTypes.LEG_EVOLUTION:
						if(FP.random<.5)
							hasEvolved = addLeg(LegType.SPIDER);
						else
							hasEvolved = addLeg(LegType.JABA);
						break;
					case EvolutionTypes.TAIL_EVOLUTION:
						if(FP.random<.5)
							hasEvolved = addTail(TailType.SCORPION);
						else
							hasEvolved = addTail(TailType.MONKEY);
						break;
					case EvolutionTypes.WING_EVOLUTION:
						if(FP.random<.5)
							hasEvolved = addWing(WingType.BAT);
						else
							hasEvolved = addWing(WingType.TINY);
						break;
				}
				if (!hasEvolved)
					x -= 1;
			}
			
		}
		
		
		override public function update():void 
		{
			handleAI();
			updateMovement();
			checkPlayerBoxes();
			super.update();
			
		}
		
		private function checkPlayerBoxes():void
		{
			var xBounceVar:Number = 30;
			var yBounceVar:Number = -15;
			var damageVar:Number = 1.0;
			if (damageCount <= 0)
			{
				switch(currentLevel.player.tail)
				{
					case TailType.SCORPION:
						yBounceVar *= .5;
						xBounceVar *= .3;
						break;
					case TailType.MONKEY:
						yBounceVar *= 2;
						xBounceVar *= .5;
						if (currentLevel.player.numTailDamagedThisAttack > 0)
							damageVar = 0;
						break;
				}
				collisionEntity = collide("playerTailPushBox", x, y);
				if (collisionEntity != null)
				{
					
					currentLevel.player.numTailDamagedThisAttack++;
					bounce(collisionEntity, xBounceVar, yBounceVar);
					takeDamage(currentLevel.player.getDamage()*damageVar);
				}
				
				xBounceVar = 30;
				yBounceVar = -15;
				damageVar = 1.0;
				switch(currentLevel.player.arms)
				{
					case ArmType.BASE:
						if (currentLevel.player.numArmDamagedThisAttack > 0)
							damageVar = 0;
						break;
					case ArmType.CLAW:
						xBounceVar *= .3;
						yBounceVar *= .5;
						break;
				}
				collisionEntity = collide("playerArmPushBox", x, y);
				if (collisionEntity != null)
				{
					
					currentLevel.player.numArmDamagedThisAttack++;
					bounce(collisionEntity, xBounceVar, yBounceVar);
					takeDamage(currentLevel.player.getDamage()*damageVar);
				}
				
			} else { damageCount -= 16; }
		}
		
		public function takeDamage(damageAmount:Number):void
		{
			if (damageAmount == 0)
				return;
			for (var ind:int = 0; ind < 20; ind ++)
				currentLevel.particleEmitter.emit("death", x + halfWidth, y + halfWidth);
			health -= damageAmount;
			if (health <= 0)
				kill();
				
		}
		
		//Apply velocity and check collisions
		private function updateMovement():void
		{
			velY += C.GRAVITY * floatVar;		//Gravity
			if (velY > maxYVel)		//If pressing down let fall faster
				velY = maxYVel;												//Else limit y vel
			
			x += velX;
			collideRoom = collide("level", x, y);
			if (collideRoom!=null)
			{
				//Colliding with wall after x movement
				//Resolve!
				if (velX > 0)	//Moving right
					x = collideRoom.x +Math.floor((x - collideRoom.x + width) / C.TILE_SIZE) * C.TILE_SIZE - width;		//place to the left of tile we have collided with
					
				if(velX<0)		//Moving left
					x = collideRoom.x + Math.floor((x- collideRoom.x) / C.TILE_SIZE) * C.TILE_SIZE + C.TILE_SIZE;		//place to the right of tile we have collided with
				
				velX = 0;
				if (grounded)
			{
					state = AI_STATE.JUMPING;
					tryJump();
			}
					else
				{
					if(velY > 0)
						facingLeft = !facingLeft;
				}
			}
			
			//Update y movement and then check collision
			y += velY
			collideRoom = collide("level", x,Math.ceil(y));
			if (collideRoom != null)
			{
				//If colliding with wall after y movement
				//Resolve position
				if (velY > 0)		//Moving down
				{
					
					y = collideRoom.y + Math.floor((y-collideRoom.y + height) / C.TILE_SIZE) * C.TILE_SIZE - height;		//Place at the top of the tile they have collided with
					velY = 0;
					grounded = true;
					jumpsLeft = totalJumps;		//Reset jump left count
				}
				
			}
			else
			grounded = false;
			collideRoom = collide("level", x, Math.floor(y));
			if(collideRoom != null)
			{
				if (velY < 0)
				{
					y = collideRoom.y + Math.floor((y - collideRoom.y ) / C.TILE_SIZE)  * C.TILE_SIZE + C.TILE_SIZE;		//Place at the bottom of the tile they have collided with
					velY *= .5;
				}
					
					
			}
			if (damageCount > 0 && !grounded)
				velX *= .99;
			else
				velX *= friction;
		}
		
		private function handleAI():void
		{
			stateCounter += 16;
			switch(enemyAI)
			{
				
				case AI_STATE.WALKING:
					if (damageCount > 0)
						return;
					if (facingLeft)
						moveLeft(C.START_ENEMY_SPEED);
					else
						moveRight(C.START_ENEMY_SPEED);
					
					if ( stateCounter > 2000 && FP.random < .1)
					{
						enemyAI = AI_STATE.IDLE;
						stateCounter = 0;
					}
					if ( stateCounter > 1000 && FP.random < .01)
					{
						enemyAI = AI_STATE.JUMPING;
					}
					break;
				case AI_STATE.IDLE:
					if ( stateCounter > 1000 && FP.random < .1)
					{
						if (FP.random < .3)
							facingLeft = !facingLeft;
						enemyAI = AI_STATE.WALKING;
						stateCounter = 0;
					}
					break;
				case AI_STATE.JUMPING:
					if (grounded || velY > 0)
						tryJump();
					
					if (facingLeft)
						moveLeft(C.START_ENEMY_SPEED);
					else
						moveRight(C.START_ENEMY_SPEED);
					if (jumpsLeft <= 0)
					{
						enemyAI = AI_STATE.WALKING
						stateCounter = 0;
					}
					break;
				
			}
		}
		
	}

}
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
			
			killBox = new Entity();
			pushBox = new Entity();
			killBox.type = "EnemyKillBox";
			pushBox.type = "EnemyPushBox";
			if (FP.random < .5)
				tintColor = 0xFF8888;
			else
				tintColor = 0x888888;
			super(level);
			health = numEvolutions +1;
			type = "Enemy";
			damage = .3;
			
			for ( var x:int = 0; x < numEvolutions; x++)
			{
				
				var upgrade:int = FP.rand(EvolutionTypes.NUM_EVOLUTIONS);
				switch(upgrade)
				{
					case EvolutionTypes.ARM_EVOLUTION:
						addArm(ArmType.BASE);
						break;
					case EvolutionTypes.HORN_EVOLUTION:
						addHorn(HornType.SPIKE);
						break;
					case EvolutionTypes.LEG_EVOLUTION:
						addLeg(LegType.SPIDER);
						break;
					case EvolutionTypes.TAIL_EVOLUTION:
						addTail(TailType.SCORPION);
						break;
					case EvolutionTypes.WING_EVOLUTION:
						addWing(WingType.BAT);
						break;
				}
			}
			
		}
		
		public function getDamage():Number
		{ 	return damage; }
		
		override public function update():void 
		{
			handleAI();
			updateMovement();
			checkPlayerBoxes();
			super.update();
			
		}
		
		private function checkPlayerBoxes():void
		{
			if (damageCount <= 0)
			{
				collisionEntity = collide("playerPushBox", x, y);
				if (collisionEntity != null)
				{
					bounce(collisionEntity);
					takeDamage(currentLevel.player.damage);
				}
				collisionEntity = collide("playerKillBox", x, y);
				if (collisionEntity != null)
					takeDamage(currentLevel.player.damage * 2);
			} else { damageCount -= 16; }
		}
		
		public function takeDamage(damageAmount:Number):void
		{
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
					facingLeft = !facingLeft;
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
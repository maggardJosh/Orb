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
		
		public function Enemy(numEvolutions:int) 
		{
			if (FP.random < .5)
				tintColor = 0xFF8888;
			else
				tintColor = 0x888888;
			super();
			type = "Enemy";
			
			for ( var x:int = 0; x < numEvolutions; x++)
			{
				var upgrade:int = FP.rand(EvolutionTypes.NUM_EVOLUTIONS);
				switch(upgrade)
				{
					case EvolutionTypes.ARM_EVOLUTION:
						addArm(ArmType.BASE);
						break;
					case EvolutionTypes.HORN_EVOLUTION:
						addHorn(HornType.BASE);
						break;
					case EvolutionTypes.LEG_EVOLUTION:
						addLeg(LegType.SPIDER);
						break;
					case EvolutionTypes.TAIL_EVOLUTION:
						addTail(TailType.BASE);
						break;
					case EvolutionTypes.WING_EVOLUTION:
						addWing(WingType.BAT);
						break;
				}
			}
			
		}
		
		override public function update():void 
		{
			handleAI();
			updateMovement();
			super.update();
			
		}
		
		public function kill():void
		{
			if (this.legs != LegType.NONE)
				this.world.add(new LegEvolution(this.legs, new Point(this.x+halfWidth, this.y+halfHeight)));
			if (this.wings != WingType.NONE)
				this.world.add(new WingEvolution(this.wings, new Point(this.x+halfWidth, this.y+halfHeight)));
			if (this.arms != ArmType.NONE)
				this.world.add(new ArmEvolution(this.arms, new Point(this.x + halfWidth, this.y + halfHeight)));
			if (this.tail != TailType.NONE)
				this.world.add(new TailEvolution(this.tail, new Point(this.x + halfWidth, this.y + halfHeight)));
			if (this.horn != HornType.NONE)
				this.world.add(new HornEvolution(this.horn, new Point(this.x + halfWidth, this.y + halfHeight)));
			this.world.remove(this);
		}
		
		//Apply velocity and check collisions
		private function updateMovement():void
		{
			velY += C.GRAVITY * floatVar;		//Gravity
			if (!Input.check("DOWN") && velY > maxYVel)		//If pressing down let fall faster
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
					if (facingLeft)
						moveLeft(C.START_ENEMY_SPEED);
					else
						moveRight(C.START_ENEMY_SPEED);
					
					if ( stateCounter > 2000 && FP.random < .1)
					{
						enemyAI = IDLE;
						stateCounter = 0;
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
				
			}
		}
		
	}

}
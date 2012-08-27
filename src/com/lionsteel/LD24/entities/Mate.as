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
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Josh Maggard
	 */
	public class Mate extends Monster 
	{
		private var collideRoom:Entity;
		private var stateCounter:int;
		
		private var enemyAI:int;
		private var ponyTail:Image;
		private var ponyTailOffset:Point;
		private var hasEvolved:Boolean = false;
		private var eKeyImage:Image;
		
		public var collidingWithPlayer:Boolean = false;
		
		public function Mate(numEvolutions:int, level:Level) 
		{
			eKeyImage = new Image(GFX.E_KEY);
			ponyTail = new Image(GFX.PONY_TAIL);
			ponyTailOffset = new Point( -100 / 2 + C.TILE_SIZE / 2, -80 / 2 + C.TILE_SIZE / 2);
			
			killBox = new Entity();
			pushBox = new Entity();
			tintColor = 0xFF6666;
			super(level);
			setBody(BodyType.MATE);
			health = numEvolutions +1;
			type = "Mate";
			
			if (numEvolutions > EvolutionTypes.NUM_EVOLUTIONS)
				numEvolutions = EvolutionTypes.NUM_EVOLUTIONS;
			
			for ( var x:int = 0; x < numEvolutions; x++)
			{
				hasEvolved = false;
				var upgrade:int = FP.rand(EvolutionTypes.NUM_EVOLUTIONS);
				switch(upgrade)
				{
					case EvolutionTypes.ARM_EVOLUTION:
						hasEvolved = addArm(ArmType.BASE);
						break;
					case EvolutionTypes.HORN_EVOLUTION:
						hasEvolved = addHorn(HornType.SPIKE);
						break;
					case EvolutionTypes.LEG_EVOLUTION:
						if(FP.random<.5)
							hasEvolved = addLeg(LegType.SPIDER);
							else
							hasEvolved = addLeg(LegType.JABA);
						break;
					case EvolutionTypes.TAIL_EVOLUTION:
						hasEvolved = addTail(TailType.SCORPION);
						break;
					case EvolutionTypes.WING_EVOLUTION:
						hasEvolved = addWing(WingType.BAT);
						break;
				}
				if (!hasEvolved)
					x -= 1;
			}
			
		}
		
		override public function update():void 
		{
			ponyTail.flipped = facingLeft;
			checkCollisions();
			updateMovement();
			super.update();
			
		}
		
		private function checkCollisions():void
		{
			collisionEntity = collide("Player", x, y);
			collidingWithPlayer = (collisionEntity != null);
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
			if (damageCount > 0 && !grounded)
				velX *= .99;
			else
				velX *= friction;
		}
		
		override public function render():void 
		{
			super.render();
			ponyTail.render(FP.buffer, pos.add(ponyTailOffset), FP.camera);
			
			if (collidingWithPlayer)
				eKeyImage.render(FP.buffer, pos.add(new Point(halfWidth - eKeyImage.width / 2, -eKeyImage.height - 10)), FP.camera);
		}
		
	}

}
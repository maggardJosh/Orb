package com.lionsteel.LD24.entities 
{
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
	public class Enemy extends Entity 
	{
		public static const IDLE:int = 0;
		public static const WALKING:int = 1;
		public static const JUMPING:int = 2;
		public static const FALLING:int = 3;
		
		private var collideRoom:Entity;
		
		private var stateCounter:int = 0;		//Number of Milliseconds in current state
		
		private var state:int = Enemy.IDLE;
		
		private var tintColor:uint;
		
		//Facing direction
		private var facingLeft:Boolean = false;
		private var jumpsLeft:int = 0;
		private var totalJumps:int = 1;		//this is the total jumps you get when you land (more with diff wings)
		private var floatVar:Number = 1.0;		//Gravity is multiplied by this (with wings this is lower)
		private var maxYVel:Number = C.START_MAX_Y_VEL;
		private var speedVar:Number = 1.0;		//Speed multplied by this	
		
		private var bodyAnim:Spritemap;
		private var frontArmAnim:Spritemap;
		private var backArmAnim:Spritemap;
		private var frontLegAnim:Spritemap;
		private var backLegAnim:Spritemap;
		private var tailAnim:Spritemap;
		private var frontWingAnim:Spritemap;
		private var backWingAnim:Spritemap;
		private var hornAnim:Spritemap;
		
		private var armOffset:Point;
		private var legOffset:Point;
		private var tailOffset:Point;
		private var wingOffset:Point;
		private var hornOffset:Point;
		
		//Start everything out at nothing
		//(Set bodytype in constructor)
		public var body:int = BodyType.NONE;
		public var arms:int = ArmType.NONE;
		public var legs:int = LegType.NONE;
		public var tail:int = TailType.NONE;
		public var wings:int = WingType.NONE;
		public var horn:int = HornType.NONE;
		
		private var velX:Number=0, velY:Number=0;
		private var friction:Number = .88;
		private var jumpForce:Number = -15;
		private var grounded:Boolean  = false;
		
		private var pos:Point = new Point();
		private var _camPos:Point = new Point();
		
		
		public function Enemy(numEvolutions:int) 
		{
			if (FP.random < .5)
				tintColor = 0xFF8888;
			else
				tintColor = 0x888888;
			setBody(BodyType.BASE);
			
			type = "Enemy";
			height = 32;
			
			for ( var x:int = 0; x < numEvolutions; x++)
			{
				var upgrade:int = FP.rand(EvolutionTypes.NUM_EVOLUTIONS);
				switch(upgrade)
				{
					case EvolutionTypes.ARM_EVOLUTION:
						setArm(ArmType.BASE);
						break;
					case EvolutionTypes.HORN_EVOLUTION:
						setHorn(HornType.BASE);
						break;
					case EvolutionTypes.LEG_EVOLUTION:
						setLeg(LegType.SPIDER);
						break;
					case EvolutionTypes.TAIL_EVOLUTION:
						setTail(TailType.BASE);
						break;
					case EvolutionTypes.WING_EVOLUTION:
						setWing(WingType.BASE);
						break;
				}
			}
			
		}
		
		override public function update():void 
		{
			super.update();
			handleAI();
			updateMovement()
			checkAnims();
			
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
		
		private function setBody(type:int):void
		{
			body = type;
			switch(type)
			{
				case 0: 		//Base Body
					bodyAnim = new Spritemap(GFX.BASE_BODY_ANIM,32, 32);
					bodyAnim.add("idle", [ 0], .1, true);
					bodyAnim.add("walk", [1], .1, true);
					bodyAnim.play("idle");
					bodyAnim.color = tintColor;
					width = 32;
				break;
			}
		}
		
		private function setHorn(type:int):void 
		{
			horn = type;
			switch(type)
			{
				case HornType.NONE:
					break;
				case HornType.BASE:
					hornAnim = new Spritemap(GFX.HORN_ONE_ANIM, 33, 32);
					hornAnim.add("idle", [0], .1, true);
					hornAnim.add("walk", [1], .1, true);
					hornOffset = new Point(-hornAnim.width/2 + C.TILE_SIZE/2, -hornAnim.height/2 + C.TILE_SIZE/2)
				break;
			}
			hornAnim.color = tintColor;
		}
		
		private function setWing(type:int):void
		{
			wings = type;
			switch(type)
			{
				case WingType.NONE:
					floatVar = 1.0;
					totalJumps = 1;
					maxYVel = C.START_MAX_Y_VEL;
					if (legs == LegType.NONE)
						height = 32;
					break;
				case WingType.BASE:
					frontWingAnim = new Spritemap(GFX.WING_BASE_FRONT_ANIM, 112, 64);
					backWingAnim = new Spritemap(GFX.WING_BASE_BACK_ANIM, 112, 64);
					frontWingAnim.add("idle", [0], .1, true);
					frontWingAnim.add("walk", [1], .1, true);
					backWingAnim.add("idle", [0], .1, true);
					backWingAnim.add("walk", [1], .1, true);
					wingOffset = new Point( -frontWingAnim.width / 2 + C.TILE_SIZE / 2, -frontWingAnim.height / 2 + C.TILE_SIZE / 2);
					floatVar = .7;
					totalJumps = 3;
					maxYVel = 3;
					if (legs == LegType.NONE)
					{
						height = WingType.wingHeight(wings);
						y -= 10;
					}
				break;
			}
			backWingAnim.color = tintColor;
			frontWingAnim.color = tintColor;
		}
		
		private function setTail(type:int):void
		{
			tail = type;
			switch(type)
			{
				case TailType.NONE:
					
					break;
				case TailType.BASE:
					tailAnim = new Spritemap(GFX.TAIL_BASE_ANIM, 32, 32);
					tailAnim.add("idle", [0], .1, true);
					tailAnim.add("walk", [1], .1, true);
					tailOffset = new Point( -tailAnim.width / 2 + width / 2, -tailAnim.height / 2 + C.TILE_SIZE/2);
					break;
			}
			tailAnim.color = tintColor;
		}
		
		private function setArm(type:int):void
		{
			arms = type;
			switch(type)
			{
				case ArmType.NONE:
					
					break;
				case ArmType.BASE:
					frontArmAnim = new Spritemap(GFX.ARM_BASE_FRONT_ANIM, 32	, 26);
					backArmAnim = new Spritemap(GFX.ARM_BASE_BACK_ANIM, 32, 26);
					frontArmAnim.add("idle", [0], .1, true);
					frontArmAnim.add("walk", [1], .1, true);
					backArmAnim.add("idle", [0], .1, true);
					backArmAnim.add("walk", [1], .1, true);
					armOffset = new Point( -frontArmAnim.width / 2 + width / 2, -frontArmAnim.height / 2 + C.TILE_SIZE/2);
					break;
			}
			
			frontArmAnim.color = tintColor;
			backArmAnim.color = tintColor;
		}
		
		private function setLeg(type:int):void
		{
			legs = type;
			switch(type)
			{
				case LegType.NONE:
					if(wings == WingType.NONE)
						height = 32;
					else
						height = WingType.wingHeight(wings);
				break;
				case LegType.BASE:
					frontLegAnim = new Spritemap(GFX.LEG_BASE_FRONT_ANIM, 100, 80);
					backLegAnim = new Spritemap(GFX.LEG_BASE_BACK_ANIM, 100,80);
					frontLegAnim.add("idle", [0], .1, true);
					frontLegAnim.add("walk", [1], .1, true);
					backLegAnim.add("idle", [0], .1, true);
					backLegAnim.add("walk", [1], .1, true);
					height = LegType.legHeight(LegType.BASE);
					legOffset = new Point( -frontLegAnim.width / 2 + width / 2, -frontLegAnim.height / 2 + C.TILE_SIZE/2);
					y -= 22;
				break;
			case LegType.SPIDER:
					frontLegAnim = new Spritemap(GFX.LEG_SPIDER_FRONT_ANIM, 100,80);
					backLegAnim = new Spritemap(GFX.LEG_SPIDER_BACK_ANIM, 100,80);
					frontLegAnim.add("idle", [0], .1, true);
					frontLegAnim.add("walk", [1], .1, true);
					backLegAnim.add("idle", [0], .1, true);
					backLegAnim.add("walk", [1], .1, true);
					height = LegType.legHeight(LegType.BASE);
					legOffset = new Point( -frontLegAnim.width / 2 + width / 2, -frontLegAnim.height / 2 + C.TILE_SIZE / 2);
					speedVar = 1.5;
					y -= 22;
				break;
			default:
				trace("Leg type " + type + "Does not exist");
				break;
			}
			
			backLegAnim.color = tintColor;
			frontLegAnim.color = tintColor;
		}
		
		//Checks body type and animation placement
		private function checkAnims():void
		{
			if (state == WALKING)
				bodyAnim.play("walk");
			else
				bodyAnim.play("idle");
				
			bodyAnim.flipped = facingLeft;
			if (legs != LegType.NONE)
			{
				frontLegAnim.play(bodyAnim.currentAnim);
				backLegAnim.frame = frontLegAnim.frame;
				frontLegAnim.flipped = facingLeft;
				backLegAnim.flipped = facingLeft;
				
			}
			if (horn != HornType.NONE)
			{
				hornAnim.play(bodyAnim.currentAnim);
				hornAnim.flipped = facingLeft;
			}
			if (wings != WingType.NONE)
			{
				frontWingAnim.play(bodyAnim.currentAnim);
				backWingAnim.frame = frontWingAnim.frame;
				frontWingAnim.flipped = facingLeft;
				backWingAnim.flipped = facingLeft;
			}
			if (tail != TailType.NONE)
			{
				tailAnim.play(bodyAnim.currentAnim);
				tailAnim.flipped = facingLeft;
			}
			if (arms != ArmType.NONE)
			{
				frontArmAnim.play(bodyAnim.currentAnim);
				backArmAnim.frame = frontArmAnim.frame;
				frontArmAnim.flipped = facingLeft;
				backArmAnim.flipped = facingLeft;
			}
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
			switch(state)
			{
				
				case Enemy.WALKING:
					if (facingLeft)
						velX -= C.START_ENEMY_SPEED * speedVar;
					else
						velX += C.START_ENEMY_SPEED * speedVar;
					
					if ( stateCounter > 2000 && FP.random < .1)
					{
						state = Enemy.IDLE;
						stateCounter = 0;
					}
					break;
				case Enemy.IDLE:
					if ( stateCounter > 1000 && FP.random < .1)
					{
						if (FP.random < .3)
							facingLeft = !facingLeft;
						state = Enemy.WALKING;
						stateCounter = 0;
					}
					break;
				
			}
		}
		
		override public function render():void 
		{
			super.render();
			pos.x = x;
			pos.y = y;
			
			if (legs != LegType.NONE)
				backLegAnim.render(FP.buffer, pos.add(legOffset), FP.camera);
			if (arms != ArmType.NONE)
				backArmAnim.render(FP.buffer, pos.add(armOffset), FP.camera);
			if (wings != WingType.NONE)
				backWingAnim.render(FP.buffer, pos.add(wingOffset), FP.camera);
			bodyAnim.render(FP.buffer, pos, FP.camera);
			if (horn != HornType.NONE)
				hornAnim.render(FP.buffer, pos.add(hornOffset), FP.camera);
			if (tail != TailType.NONE)
				tailAnim.render(FP.buffer, pos.add(tailOffset), FP.camera);
			if (wings != WingType.NONE)
				frontWingAnim.render(FP.buffer, pos.add(wingOffset), FP.camera);
			if (arms != ArmType.NONE)
				frontArmAnim.render(FP.buffer, pos.add(armOffset), FP.camera);
			if (legs != LegType.NONE)
				frontLegAnim.render(FP.buffer, pos.add(legOffset), FP.camera);
			
			
		}
	}

}
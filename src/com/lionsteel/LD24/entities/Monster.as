package com.lionsteel.LD24.entities 
{
	import com.lionsteel.LD24.BodyTypes.*;
	import com.lionsteel.LD24.C;
	import com.lionsteel.LD24.entities.PowerUps.ArmEvolution;
	import com.lionsteel.LD24.entities.PowerUps.HornEvolution;
	import com.lionsteel.LD24.entities.PowerUps.LegEvolution;
	import com.lionsteel.LD24.entities.PowerUps.PowerUp;
	import com.lionsteel.LD24.entities.PowerUps.TailEvolution;
	import com.lionsteel.LD24.entities.PowerUps.WingEvolution;
	import com.lionsteel.LD24.GFX;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundCodec;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.TiledSpritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;	
	import org.flashdevelop.utils.TraceLevel;
	
	/**
	 * 
	 * @author Josh Maggard
	 */
	public class Monster extends Entity 
	{
		public static const IDLE:int = 0;
		public static const WALKING:int = 1;
		public static const JUMPING:int = 2;
		public static const FALLING:int = 3;
		public static const ATTACK:int = 4;
		
		protected var state:int = IDLE;
		protected var damageCount:int = 0;
		
		protected var tintColor:uint;
		
		protected var pushBox:Entity;
		protected var killBox:Entity;
		
		//Facing direction
		protected var facingLeft:Boolean = false;
		protected var jumpsLeft:int = 0;
		protected var totalJumps:int = 1;		//this is the total jumps you get when you land (more with diff wings)
		protected var legJumpVar:Number = 1.0;		//Multply jump force by this
		protected var wingJumpVar:Number = 1.0;	//Multply jump force by this
		protected var floatVar:Number = 1.0;		//Gravity is multiplied by this (with wings this is lower)
		protected var maxYVel:Number = C.START_MAX_Y_VEL;
		private var legSpeedVar:Number = 1.0;		//Speed multplied by this	
		private var wingSpeedVar:Number = 1.0;		//Speed multplied by this	
		
		private var armMeleeDistance:Rectangle;
		
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
		
		protected var pauseAttack:Boolean = false;
		
		private var hasControl:Boolean = true;
		
		//Start everything out at nothing
		//(Set bodytype in constructor)
		public var body:int = BodyType.NONE;
		public var arms:int = ArmType.NONE;
		public var legs:int = LegType.NONE;
		public var tail:int = TailType.NONE;
		public var wings:int = WingType.NONE;
		public var horn:int = HornType.NONE;
		
		protected var velX:Number=0, velY:Number=0;
		protected var friction:Number = .8;
		protected var jumpForce:Number = -15;
		protected var grounded:Boolean  = false;
		
		private var pos:Point = new Point();
		private var _camPos:Point = new Point();
		
		private var meleeArmCooldown:int = 0;
		private var meleeTailCooldown:int = 0;
		
		private var attackCount:int  = 0;
		
		protected var collisionEntity:Entity;
		protected var currentLevel:Level;
		
		public function Monster(level:Level) 
		{
			this.currentLevel = level;
			setBody(BodyType.BASE);
			
			height = 32;
			
		}
		
		override public function update():void 
		{
			if (killBox.world != null)
				killBox.world.remove(killBox);
			super.update();
			checkAnims();
			checkState();
			checkCounters();
			checkBoxes();
		}
		
		private function checkBoxes():void
		{
			collisionEntity = collide("pushBox", x, y);
			if (collisionEntity != null && collisionEntity != pushBox)
				bounce(collisionEntity);
			collisionEntity = collide("killBox", x, y);
			if (collisionEntity != null && collisionEntity != killBox)
				kill();
		}
		
		public function kill():void
		{
			for (var ind:int = 0; ind < 20; ind++)	
			currentLevel.particleEmitter.emit("death", x, y);
			
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
		
		
		protected function bounce(entity:Entity):void
		{
			if (entity.x < x)
			{
				facingLeft = true;
				velX = 20;
				velY = jumpForce;
				
			} 
			else
			{
				facingLeft = false;
				velX = -20;
				velY = jumpForce;
			}
			damageCount = C.INVULNERABLE_COUNT;
		}
		
		private function checkCounters():void
		{
			if (meleeArmCooldown > 0)
				meleeArmCooldown -= 16;
			if (meleeTailCooldown > 0)
				meleeTailCooldown -= 16;
			if (attackCount > 0)
				attackCount -= 16;
		}
		
		private function checkState():void
		{
			switch(state)
			{
				case ATTACK:
				
					if (attackCount <= 0)
					{
						state = IDLE;
					}
					break;
				case IDLE:
					if (Math.abs(velX) > .3)
						state = WALKING;
					break;
				case WALKING:
					if (Math.abs(velX) < .3)
						state = IDLE;
					if (velY > 1)
						state = FALLING;
					break;
				case JUMPING:
					if (velY > 0)
						state = FALLING;
					break;
				case FALLING:
					if (grounded)
						state = IDLE;
					break;
				
			}
		}
		public function addLeg(type:int):void
		{
			if (legs == LegType.NONE)
				setLeg(type);
		}
		public function addWing(type:int):void
		{
			if (wings == WingType.NONE)
				setWing(type);
		}
		
		public function addArm(type:int):void
		{
			if (arms == ArmType.NONE)
				setArm(type);
		}
		
		public function addTail(type:int):void
		{
			if (tail == TailType.NONE)
				setTail(type);
		}
		
		public function addHorn(type:int):void
		{
			if (horn == HornType.NONE)
				setHorn(type);
		}
		
		public function tryAttack():void
		{
			if (!hasControl)
				return;
			if (arms != ArmType.NONE && meleeArmCooldown <= 0)
			{
				state = ATTACK;
				bodyAnim.play("attack", true);
				frontArmAnim.play("meleeStart", true);
				attackCount = C.ATTACK_COUNT;
				meleeArmCooldown = C.ARM_MELEE_COOLDOWN;
			}else if (tail != TailType.NONE && meleeTailCooldown <= 0)
			{
				state = ATTACK;
				bodyAnim.play("attack", true);
				tailAnim.play("meleeStart", true);
				attackCount = C.ATTACK_COUNT;
				meleeTailCooldown = C.TAIL_MELEE_COOLDOWN;
			}
		}
		
		protected function setBody(type:int):void
		{
			body = type;
			switch(type)
			{
				case 0: 		//Base Body
					bodyAnim = new Spritemap(GFX.BASE_BODY_ANIM,32, 32);
					bodyAnim.add("idle", [ 0], .1, true);
					bodyAnim.add("walk", [1], .1, true);
					bodyAnim.add("jump", [2], .1, true);
					bodyAnim.add("fall", [3], .1, true);
					bodyAnim.add("melee", [4], .1, true);
					bodyAnim.add("range", [5], .1, true);
					bodyAnim.add("crouch", [6], .1, true);
					bodyAnim.add("birth", [7], .1, true);
					bodyAnim.play("idle");
					
					width = 32;
				break;
			}
			bodyAnim.color = tintColor;
		}
		
		protected function setHorn(type:int):void 
		{
			horn = type;
			switch(type)
			{
				case HornType.NONE:
					break;
				case HornType.BASE:
					hornAnim = new Spritemap(GFX.HORN_SPIKE_ANIM, 64, 64);
					hornAnim.add("idle", [0], .1, true);
					hornAnim.add("walk", [1], .1, true);
					hornAnim.add("jump", [2], .1, true);
					hornAnim.add("fall", [3], .1, true);
					hornOffset = new Point(-hornAnim.width/2 + C.TILE_SIZE/2, -hornAnim.height/2 + C.TILE_SIZE/2)
				break;
			}
			hornAnim.color = tintColor;
		}
		
		protected function setWing(type:int):void
		{
			wings = type;
			switch(type)
			{
				case WingType.NONE:
					floatVar = 1.0;
					wingJumpVar = 1.0;
					wingSpeedVar = 1.0;
					totalJumps = 1;
					maxYVel = C.START_MAX_Y_VEL;
					if (legs == LegType.NONE)
						height = 32;
					break;
				case WingType.BAT:
					frontWingAnim = new Spritemap(GFX.WING_BAT_FRONT_ANIM, 100, 80);
					backWingAnim = new Spritemap(GFX.WING_BAT_BACK_ANIM, 100, 80);
					frontWingAnim.add("idle", [0,1,2,3], .1, true);
					frontWingAnim.add("walk", [4, 5, 6, 7], .1, true);
					frontWingAnim.add("jump", [8,9,10,11], .07, false);
					frontWingAnim.add("fall", [12,13,14,15], .1, false);
					wingOffset = new Point( -frontWingAnim.width / 2 + C.TILE_SIZE / 2, -frontWingAnim.height / 2 + C.TILE_SIZE / 2);
					floatVar = .8;
					totalJumps = 3;
					maxYVel = 3;
					if (legs == LegType.NONE)
					{
						height = WingType.wingHeight(wings);
						y -= 10;
					}
				break;
			}
			frontWingAnim.color = tintColor;
			backWingAnim.color = tintColor;
		}
		
		protected function setTail(type:int):void
		{
			tail = type;
			switch(type)
			{
				case TailType.NONE:
					
					break;
				case TailType.SCORPION:
					tailAnim = new Spritemap(GFX.TAIL_SCORPION_ANIM, 120, 100);
					tailAnim.add("idle",[0] ,.1, true);
					tailAnim.add("walk", [4,5,6,7], .1, true);
					tailAnim.add("jump", [8], .1, true);
					tailAnim.add("fall", [12], .1, true);
					tailAnim.add("meleeStart", [16], .7, false);
					tailAnim.add("melee", [16,17,18,19,19,19,19],.3, false);
					tailAnim.add("range", [20], .1, true);
					tailAnim.add("crouch", [24], .1, true);
					tailAnim.add("birth", [28], .1, true);
					tailOffset = new Point( -tailAnim.width / 2 + width / 2, -tailAnim.height / 2 + C.TILE_SIZE/2);
					break;
			}
			tailAnim.color = tintColor;
		}
		
		protected function setArm(type:int):void
		{
			arms = type;
			switch(type)
			{
				case ArmType.NONE:
					
					break;
				case ArmType.BASE:
					frontArmAnim = new Spritemap(GFX.ARM_BASE_FRONT_ANIM, 100, 80);
					backArmAnim = new Spritemap(GFX.ARM_BASE_BACK_ANIM, 100, 80);
					frontArmAnim.add("idle",[0] ,.1, true);
					frontArmAnim.add("walk", [4,5,6,7], .1, true);
					frontArmAnim.add("jump", [8], .1, true);
					frontArmAnim.add("fall", [12], .1, true);
					frontArmAnim.add("meleeStart", [16], .7, false);
					frontArmAnim.add("melee", [16,17,18,19,19,19],.3, false);
					frontArmAnim.add("range", [20], .1, true);
					frontArmAnim.add("crouch", [24], .1, true);
					frontArmAnim.add("birth", [28], .1, true);
					armMeleeDistance = new Rectangle(0, 0, 40, 40);
					armOffset = new Point( -frontArmAnim.width / 2 + width / 2, -frontArmAnim.height / 2 + C.TILE_SIZE/2);
					break;
			}
			frontArmAnim.color = tintColor;
			backArmAnim.color = tintColor;
		}

		
		protected function setLeg(type:int):void
		{
			legs = type;
			switch(type)
			{
				case LegType.NONE:
					if(wings == WingType.NONE)
						height = 32;
					else
						height = WingType.wingHeight(wings);
					legJumpVar = 1.0;
					legSpeedVar = 1.0;
				break;
			case LegType.SPIDER:
					frontLegAnim = new Spritemap(GFX.LEG_SPIDER_FRONT_ANIM, 100, 80);
					backLegAnim = new Spritemap(GFX.LEG_SPIDER_BACK_ANIM, 100,80);
					frontLegAnim.add("idle", [0,1,2,3], .3, true);
					frontLegAnim.add("walk", [4, 5, 6, 7], .25, true);
					frontLegAnim.add("jump", [8, 9, 10, 11], .3, true);
					frontLegAnim.add("fall", [8], .3,true);
					frontLegAnim.play("idle");
					height = LegType.legHeight(LegType.BASE);
					legOffset = new Point( -frontLegAnim.width / 2 + width / 2, -frontLegAnim.height / 2 + C.TILE_SIZE / 2);
					legSpeedVar = 1.4;
					legJumpVar = 1.3;
					y -= 22;
				break;
			default:
				trace("Leg type " + type + "Does not exist");
				break;
			}
			backLegAnim.color = tintColor;
			frontLegAnim.color = tintColor;
		}
		
		protected function tryJump():void
		{
			if (!hasControl)
				return;
			if (jumpsLeft > 0)
			{
				velY = jumpForce * legJumpVar * wingJumpVar;
				jumpsLeft--;
				grounded = false;
				state = JUMPING;
				bodyAnim.play("jump", true);
			}
		}
		
		protected function moveRight(speed:Number):void
		{
			if (!hasControl)
				return;
			velX += speed * legSpeedVar * wingSpeedVar;
			facingLeft = false;
			
		}
		
		protected function moveLeft(speed:Number):void
		{
			if (!hasControl)
				return;
			velX -= speed * legSpeedVar * wingSpeedVar;
			facingLeft = true;
			
		}
		
		//Checks body type and animation placement
		private function checkAnims():void
		{
			switch(state)
			{
				case ATTACK:
					bodyAnim.play("attack");
					break;
				case JUMPING:
					bodyAnim.play("jump");
					break;
				case FALLING:
					bodyAnim.play("fall");
					break;
				case WALKING:
					bodyAnim.play("walk");
					break;
				case IDLE:
					bodyAnim.play("idle");
					break;
			}
				
			bodyAnim.update();
				
			bodyAnim.flipped = facingLeft;
			if (legs != LegType.NONE)
			{
				frontLegAnim.play(bodyAnim.currentAnim);
				frontLegAnim.update();
				backLegAnim.frame = frontLegAnim.frame;
				frontLegAnim.flipped = facingLeft;
				backLegAnim.flipped = facingLeft;
				
			}
			if (horn != HornType.NONE)
			{
				hornAnim.play(bodyAnim.currentAnim);
				hornAnim.update();
				hornAnim.flipped = facingLeft;
			}
			if (wings != WingType.NONE)
			{
				frontWingAnim.play(bodyAnim.currentAnim);
				frontWingAnim.update();
				backWingAnim.frame = frontWingAnim.frame;
				frontWingAnim.flipped = facingLeft;
				backWingAnim.flipped = facingLeft;
			}
			if (tail != TailType.NONE)
			{
				if (tailAnim.currentAnim == "meleeStart")
				{
					if (tailAnim.complete && !pauseAttack)
					{
						tailAnim.play("melee", true);
						if (facingLeft)
							velX = -.4;
						else
							velX = .4;
						hasControl = false;
					}
				}
				else
				if (tailAnim.currentAnim == "melee")
				{
					velX *= 1.5
					
					if (tailAnim.complete)
					{
						hasControl = true;
						velX *= .1;
						tailAnim.play("idle");
						//checkArmAttack();
					}
				}
				else
				tailAnim.play(bodyAnim.currentAnim);
				tailAnim.update();
				tailAnim.flipped = facingLeft;
			}
			if (arms != ArmType.NONE)
			{
				if (frontArmAnim.currentAnim == "meleeStart")
				{
					if (frontArmAnim.complete && !pauseAttack)
					{
						frontArmAnim.play("melee", true);
						if (facingLeft)
							velX = -.4;
						else
							velX = .4;
						hasControl = false;
					}
				}
				else
				if (frontArmAnim.currentAnim == "melee")
				{
					velX *= 1.5
					this.world.add(pushBox);
					pushBox.y = y;
					if (facingLeft)
						pushBox.x = x - width;
					else
						pushBox.x = x + width;
					
					if (frontArmAnim.complete)
					{
						this.world.remove(pushBox);
						this.world.add(killBox);
						velX = 0;
						if (facingLeft)
							killBox.x = x - width;
						else
							killBox.x = x + width;
						killBox.y = y;
						hasControl = true;
						
						frontArmAnim.play("idle");
					}
				}
				else
				frontArmAnim.play(bodyAnim.currentAnim);
				frontArmAnim.update();
				backArmAnim.frame = frontArmAnim.frame;
				frontArmAnim.flipped = facingLeft;
				backArmAnim.flipped = facingLeft;
			}
		}
		
		override public function render():void 
		{
			super.render();
			pos.x = x;
			pos.y = y;
			
			if (wings != WingType.NONE)
				backWingAnim.render(FP.buffer, pos.add(wingOffset), FP.camera);
			if (arms != ArmType.NONE)
				backArmAnim.render(FP.buffer, pos.add(armOffset), FP.camera);
			if (legs != LegType.NONE)
				backLegAnim.render(FP.buffer, pos.add(legOffset), FP.camera);
			if (tail != TailType.NONE)
				tailAnim.render(FP.buffer, pos.add(tailOffset), FP.camera);
			bodyAnim.render(FP.buffer, pos, FP.camera);
			if (horn != HornType.NONE)
				hornAnim.render(FP.buffer, pos.add(hornOffset), FP.camera);
			if (legs != LegType.NONE)
				frontLegAnim.render(FP.buffer, pos.add(legOffset), FP.camera);
			if (arms != ArmType.NONE)
				frontArmAnim.render(FP.buffer, pos.add(armOffset), FP.camera);
			if (wings != WingType.NONE)
				frontWingAnim.render(FP.buffer, pos.add(wingOffset), FP.camera);
			
			
			
		}
	}

}
package com.lionsteel.LD24.entities 
{
	import com.lionsteel.LD24.BodyTypes.*;
	import com.lionsteel.LD24.C;
	import com.lionsteel.LD24.GFX;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundCodec;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.TiledSpritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;	
	import org.flashdevelop.utils.TraceLevel;
	
	/**
	 * Monster is what the player controls.
	 * It can be given different body parts that have different effects.
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
		
		/** Invulnerability counter
		 *  If greater than 0 then this cannot take damage */ 
		public var damageCount:int = 0;		
		
		protected var tintColor:uint;				
		
		protected var armPushBox:Entity;
		protected var tailPushBox:Entity;
		
		
		public var facingLeft:Boolean = false;			//Facing direction
		protected var jumpsLeft:int = 0;

		protected var maxYVel:Number = C.START_MAX_Y_VEL;
		
		public var _damage:Number = 1.0;
		public var health:Number;
		
		//{region Get Modifiers Functions
		/**
		 * Returns the max health based on current body parts
		 * @return max health considering body parts
		 */
		protected function getTotalHearts():int
		{
			return C.START_HEALTH + BodyType.HEARTS_ADDED[body] + LegType.HEARTS_ADDED[legs] + ArmType.HEARTS_ADDED[arms] + TailType.HEARTS_ADDED[tail] + HornType.HEARTS_ADDED[horn] + WingType.HEARTS_ADDED[wings];
		}
		
		/**
		 * Multiplies speed by all the body part speed modifiers
		 * @return adjusted speed
		 */
		protected function getSpeed():Number
		{
			return C.START_PLAYER_SPEED * BodyType.SPEED_VAR[body] * LegType.SPEED_VAR[legs] * ArmType.SPEED_VAR[arms] * TailType.SPEED_VAR[tail] * HornType.SPEED_VAR[horn] * WingType.SPEED_VAR[wings];
		}
		
		/**
		 * Multiplies our damage by the total damage modifiers of each body part
		 * @return adjusted damage
		 */
		public function getDamage():Number
		{
			return _damage * BodyType.TOTAL_DAMAGE_VAR[body] * LegType.TOTAL_DAMAGE_VAR[legs] * ArmType.TOTAL_DAMAGE_VAR[arms] * TailType.TOTAL_DAMAGE_VAR[tail] * HornType.TOTAL_DAMAGE_VAR[horn] * WingType.TOTAL_DAMAGE_VAR[wings];
		}
		
		/**
		 * Multiplies our jumpforce by all the body part jump force modifiers
		 * @return adjusted jumpforce
		 */
		protected function getJumpForce():Number
		{
			return jumpForce * BodyType.JUMP_FORCE_VAR[body] * LegType.JUMP_FORCE_VAR[legs] * ArmType.JUMP_FORCE_VAR[arms] * TailType.JUMP_FORCE_VAR[tail] * HornType.JUMP_FORCE_VAR[horn] * WingType.JUMP_FORCE_VAR[wings];
		}
		
		
		/**
		 * Takes into account all jump variables of all the parts
		 * to get the total jumps should be allowed
		 * @return total number of jumps based on body parts
		 */
		protected function getTotalJumps():int
		{
			return 1 + BodyType.JUMPS_ADDED[body] + LegType.JUMPS_ADDED[legs] + ArmType.JUMPS_ADDED[arms]+ TailType.JUMPS_ADDED[tail]+ HornType.JUMPS_ADDED[horn] + WingType.JUMPS_ADDED[wings];
		}
		
		//}endregion
		
		private var bodyAnim:Spritemap;
		private var frontArmAnim:Spritemap;
		private var backArmAnim:Spritemap;
		private var frontLegAnim:Spritemap;
		private var backLegAnim:Spritemap;
		private var tailAnim:Spritemap;
		private var frontWingAnim:Spritemap;
		private var backWingAnim:Spritemap;
		private var hornAnim:Spritemap;
		
		public var eggImage:Image;
		private var eggOffset:Point;
		
		private var armOffset:Point;
		private var legOffset:Point;
		private var tailOffset:Point;
		private var wingOffset:Point;
		private var hornOffset:Point;
		
		protected var pauseAttack:Boolean = false;
		
		protected var hasControl:Boolean = true;
		
		//{region body parts
		//(Set bodytype in constructor)
		public var body:int = BodyType.BASE;
		public var arms:int = ArmType.NONE;
		public var legs:int = LegType.NONE;
		public var tail:int = TailType.NONE;
		public var wings:int = WingType.NONE;
		public var horn:int = HornType.NONE;
		//}endregion
		
		public var velX:Number=0, velY:Number=0;
		protected var friction:Number = .8;
		protected var jumpForce:Number = -15;
		protected var grounded:Boolean  = false;
		
		protected var pos:Point = new Point();
		private var _camPos:Point = new Point();
		
		private var meleeCountdown:int = 0;
		private var rangedCountdown:int = 0;
		
		private var attackCount:int  = 0;
		
		protected var collisionEntity:Entity;
		public var currentLevel:Level;
		
		public var numArmDamagedThisAttack:int = 0;
		public var numTailDamagedThisAttack:int = 0;
		
		public function Monster(level:Level) 
		{
			this.currentLevel = level;
			
			eggImage = new Image(GFX.EGG_BIG);
			eggOffset = new Point( -eggImage.width / 2 + C.TILE_SIZE/2, -eggImage.height / 2 );
			
			height = 32;
			setBody(BodyType.BASE);
			
			
		}
		
		/**
		 * Get a direct copy of this monster
		 * @return a copy of this monster object
		 */
		public function copy():Monster
		{
			var newMon:Monster = new Monster(currentLevel);
			newMon.bodyAnim.color = tintColor;
			newMon.tintColor = tintColor;
			newMon.addArm(arms);
			newMon.addLeg(legs);
			newMon.addHorn(horn);
			newMon.addTail(tail);
			newMon.addWing(wings);
			newMon.tintColor = tintColor;
			newMon.x = x;
			newMon.y = y;
			newMon.tailPushBox = tailPushBox
			newMon.armPushBox= armPushBox;
			
			return newMon;
		}
		
		/**
		 * clamps all variables between their max and min values
		 */
		private function clamps():void
		{
			velX = FP.clamp(velX, -C.MAX_VEL_X, C.MAX_VEL_X);
			velY = FP.clamp(velY, -C.MAX_VEL_Y, C.MAX_VEL_Y);
			
			
			if (health > getTotalHearts())
				health = getTotalHearts();
		}
		
		/**
		 * Update velocity, animations, state and counters.
		 * Also other things...
		 */
		override public function update():void 
		{
			
			//TODO Probably add a passive function for bodies to use (Set special abilities)
			
			if (horn == HornType.PLANT)
			{
				//Slow regen
				health += .0003;
			}
			
			clamps();
			
			if (eggImage.alpha > 0)
				eggImage.alpha -= .02;
			super.update();
			checkAnims();
			checkState();
			checkCounters();
		}
		
		/**
		 * Bounces this monster away from entity
		 * @param	entity	Entity to bounce away from
		 * @param	xBounce	xVelocity to use
		 * @param	yBounce	yVelocity to use
		 */
		public function bounce(entity:Entity, xBounce:Number = 30, yBounce:Number = -15):void
		{
			if (entity.x < x)			//We are on the right side of the entity
			{
				velX = xBounce;
				velY = yBounce;
			} 
			else					//We are on the left side
			{
				velX = -xBounce;		//REVERSE X VELOCITY
				velY = yBounce;
			}
			
			damageCount = C.INVULNERABLE_COUNT;	

		}
		
		/**
		 * Simply counts counters down if they are > 0
		 */
		private function checkCounters():void
		{
			if (meleeCountdown > 0)
				meleeCountdown -= C.MILLI_PER_FRAME;
			if (rangedCountdown > 0)
				rangedCountdown -= C.MILLI_PER_FRAME;
			if (attackCount > 0)
				attackCount -= C.MILLI_PER_FRAME;
		}
		
		/**
		 * Detects what we are doing and set our state
		 * Used for animations
		 */
		private function checkState():void
		{
			
			switch(state)
			{
				case ATTACK:
					if (attackCount <= 0)
						state = IDLE;
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
					if (velY >= 0)
						state = FALLING;
					break;
				case FALLING:
					if (grounded)
						state = IDLE;
					break;
				
			}
		}
		
		//{region Add Body Part Section
		public function addLeg(type:int):Boolean
		{
			if (legs == LegType.NONE && type != LegType.NONE)
				setLeg(type);
			return true;
		}
		public function addWing(type:int):Boolean
		{
			if (wings == WingType.NONE && type != WingType.NONE)
				setWing(type);
			else
				return false;
			return true;
		}
		
		public function addArm(type:int):Boolean
		{
			if (arms == ArmType.NONE && type != ArmType.NONE)
				setArm(type);
			else
				return false;
			return true;
		}
		
		public function addTail(type:int):Boolean
		{
			if (tail == TailType.NONE && type!=TailType.NONE)
				setTail(type);
			else
				return false;
			return true;
		}
		
		public function addHorn(type:int):Boolean
		{
			if (horn == HornType.NONE&&type != HornType.NONE)
				setHorn(type);
			else
				return false;
			return true;
		}
		//}endregion
		
		//{region try stuff functions
		public function tryMelee():void
		{
			if (!hasControl)
				return;
			if (arms != ArmType.NONE && meleeCountdown <= 0)
			{
				//TODO: Melee combo system
				state = ATTACK;
				bodyAnim.play("attack", true);
				frontArmAnim.play("meleeStart", true);
				meleeCountdown = C.ARM_MELEE_COOLDOWN;
			}
		}
		
		public function tryRanged():void
		{
			if (!hasControl)
				return;
			if (tail != TailType.NONE && rangedCountdown <= 0)
			{
				//TODO: Ranged Attack
			}
		}
		
		protected function tryJump():void
		{
			if (!hasControl)
				return;
			if (jumpsLeft > 0)
			{
				velY = getJumpForce();
				jumpsLeft--;
				grounded = false;
				state = JUMPING;
				bodyAnim.play("jump", true);
			}
		}
		
		//}endregion
		
		/**
		 * simply resets character's velocity and plays birth animation
		 * and makes sure the player has no control
		 */
		public function startBirth():void
		{
			velX = 0;
			velY = 0;
			bodyAnim.play("birth", true);
			eggImage.alpha = 1.0;
			hasControl = false;
		}
		
		//{region setBodyPart functions
		protected function setBody(type:int):void
		{
			body = type;
			
			bodyAnim = BodyType.getAnim(type);
			
			width = 32;
			
			bodyAnim.color = tintColor;
		}
		
		public function setHorn(type:int):void 
		{
			if (type >= HornType.NUM_PARTS)
				type = HornType.NONE;
			horn = type;
			
			hornAnim = HornType.getAnim(type);
			
			hornOffset = new Point( -hornAnim.width / 2 + C.TILE_SIZE / 2, -hornAnim.height / 2 + C.TILE_SIZE / 2)
			
			hornAnim.color = tintColor;
		}
		
		public function setWing(type:int):void
		{
			if (type >= WingType.NUM_PARTS)	
				type = 0;
			wings = type;
			
			frontWingAnim = WingType.getFrontAnim(type);
			backWingAnim = WingType.getBackAnim(type);
			
			maxYVel = C.START_MAX_Y_VEL * WingType.FLOAT_VAR[type];			//Find new max *floating* y velocity
			
			wingOffset = new Point( -frontWingAnim.width / 2 + C.TILE_SIZE / 2, -frontWingAnim.height / 2 + C.TILE_SIZE / 2);
			
			frontWingAnim.color = tintColor;
			backWingAnim.color = tintColor;
		}
		
		public function setTail(type:int):void
		{
			if (type >= TailType.NUM_PARTS)
				type = 0;
			tail = type;
			
			tailAnim = TailType.getAnim(type);
			
			tailOffset = new Point( -tailAnim.width / 2 + width / 2, -tailAnim.height / 2 + C.TILE_SIZE/2);
			
			tailAnim.color = tintColor;
		}
		
		public function setArm(type:int):void
		{
			if (type >= ArmType.NUM_PARTS)
				type = 0;
			arms = type;
			frontArmAnim = ArmType.getFrontAnim(arms);
			backArmAnim = ArmType.getBackAnim(arms);
			
			
			armOffset = new Point( -frontArmAnim.width / 2 + width / 2, -frontArmAnim.height / 2 + C.TILE_SIZE/2);
			
			frontArmAnim.color = tintColor;
			backArmAnim.color = tintColor;
		}

		
		public function setLeg(type:int):void
		{
			if (type >= LegType.NUM_PARTS)
				type = 0;
			legs = type;
			
			y -= LegType.legHeight(legs) -height;
			height = LegType.legHeight(legs);
			
			frontLegAnim = LegType.getFrontAnim(type);
			backLegAnim = LegType.getBackAnim(type);
			
			legOffset = new Point( -frontLegAnim.width / 2 + width / 2, -frontLegAnim.height / 2 + C.TILE_SIZE / 2);
			
			backLegAnim.color = tintColor;
			frontLegAnim.color = tintColor;
		}
		
		//}endregion
		
		//{region play anim functions
		public function playBirth():void
		{
			bodyAnim.play("birth");
			if (eggImage.alpha > 0)
				eggImage.alpha -= .02;
			checkAnims();
		}
		
		public function playIdle():void
		{
			state = IDLE;
			bodyAnim.play("idle");
			checkAnims();
		}
		//}endregion
		
		//{region move functions
		protected function moveRight(speed:Number):void
		{
			if (!hasControl)
				return;
			velX += speed;
			facingLeft = false;
			
		}
		
		protected function moveLeft(speed:Number):void
		{
			if (!hasControl)
				return;
			velX -= speed;
			facingLeft = true;
			
		}
		//}endregion
		
		/**
		 * Checks body type and animation placement
		 */
		private function checkAnims():void
		{
			
			bodyAnim.update();
			if (bodyAnim.currentAnim == "birth")
			{
				if (bodyAnim.complete)
				{
					bodyAnim.play("idle");
					hasControl = true;
				}
			}
			else
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
				
			}
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
				//If we are attacking with tail then it is on it's own
				if (tailAnim.currentAnim == "meleeStart")
				{
					if (tailAnim.complete && !pauseAttack)
					{
						numTailDamagedThisAttack = 0;
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
					//velY = 0;
					this.world.add(tailPushBox);
					tailPushBox.y = y - 32;
					if (facingLeft)
						tailPushBox.x = x - width;
					else
						tailPushBox.x = x + width;
					if (tailAnim.complete)
					{
						this.world.remove(tailPushBox);
						velX = 0;
						hasControl = true;
						tailAnim.play("idle");
					}
				}
				else
				tailAnim.play(bodyAnim.currentAnim);
				tailAnim.update();
				tailAnim.flipped = facingLeft;
			}
			if (arms != ArmType.NONE)
			{
				//If we are attacking with our arms then they animate on their own
				if (frontArmAnim.currentAnim == "meleeStart")
				{
					if (frontArmAnim.complete && !pauseAttack)
					{
						numArmDamagedThisAttack = 0;
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
					velY = -C.GRAVITY;
					this.world.add(armPushBox);
					armPushBox.y = y;
					if (facingLeft)
						armPushBox.x = x - width;
					else
						armPushBox.x = x + width;
					
					if (frontArmAnim.complete)
					{
						this.world.remove(armPushBox);
						velX = 0;
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
		
		/**
		 * Renders all body parts in the correct order
		 */
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

			if (bodyAnim.currentAnim == "birth")
				eggImage.render(FP.buffer, pos.add(eggOffset), FP.camera);
			
		}
	}

}
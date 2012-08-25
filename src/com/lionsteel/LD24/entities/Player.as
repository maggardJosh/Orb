package com.lionsteel.LD24.entities 
{
	import com.lionsteel.LD24.BodyTypes.*;
	import com.lionsteel.LD24.C;
	import com.lionsteel.LD24.GFX;
	import flash.geom.Point;
	import flash.media.SoundCodec;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.TiledSpritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	

	

	

	

	
	/**
	 * ...
	 * @author Josh Maggard
	 */
	public class Player extends Entity 
	{
		public static const IDLE:int = 0;
		public static const WALKING:int = 1;
		public static const JUMPING:int = 2;
		public static const FALLING:int = 3;
		
		private var state:int = Player.IDLE;
		
		//Facing direction
		private var facingLeft:Boolean = false;
		private var jumpsLeft:int = 0;
		private var totalJumps:int = 1;		//this is the total jumps you get when you land (more with diff wings)
		private var floatVar:Number = 1.0;		//Gravity is multiplied by this (with wings this is lower)
		private var maxYVel:Number = C.MAX_Y_VEL;
		
		private var bodyAnim:Spritemap;
		private var armAnim:Spritemap;
		private var legAnim:Spritemap;
		private var tailAnim:Spritemap;
		private var wingAnim:Spritemap;
		private var hornAnim:Spritemap;
		
		private var armOffset:Point;
		private var legOffset:Point;
		private var tailOffset:Point;
		private var wingOffset:Point;
		private var hornOffset:Point;
		
		//Start everything out at nothing
		//(Set bodytype in constructor)
		private var body:int = BodyType.NONE;
		private var arms:int = ArmType.NONE;
		private var legs:int = LegType.NONE;
		private var tail:int = TailType.NONE;
		private var wings:int = WingType.NONE;
		private var horn:int = HornType.NONE;
		
		private var velX:Number=0, velY:Number=0;
		private var friction:Number = .88;
		private var accel:Number = 1.3;
		private var jumpForce:Number = -15;
		private var grounded:Boolean  = false;
		
		private var pos:Point = new Point();
		private var _camPos:Point = new Point();
		
		
		public function Player() 
		{
			setBody(BodyType.BASE);
			
			height = 32;
			
		}
		
		override public function update():void 
		{
			super.update();
			handleControls();
			updateMovement()
			updateCamera();
			checkAnims();
			checkState();
			
		}
		
		private function checkState():void
		{
			
			if (grounded && Math.abs(velX ) > 1)
				state = WALKING;
				else
				if (Math.abs(velX) <  1)
					state = IDLE;
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
		}
		
		private function setWing(type:int):void
		{
			wings = type;
			switch(type)
			{
				case WingType.NONE:
					floatVar = 1.0;
					totalJumps = 1;
					maxYVel = C.MAX_Y_VEL;
					if (legs == LegType.NONE)
						height = 32;
					break;
				case WingType.BASE:
					wingAnim = new Spritemap(GFX.WING_ONE_ANIM, 112, 64);
					wingAnim.add("idle", [0], .1, true);
					wingAnim.add("walk", [1], .1, true);
					wingOffset = new Point( -wingAnim.width / 2 + C.TILE_SIZE / 2, -wingAnim.height / 2 + C.TILE_SIZE / 2);
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
					legAnim = new Spritemap(GFX.LEG_ONE_ANIM, 112,72);
					legAnim.add("idle", [0], .1, true);
					legAnim.add("walk", [1], .1, true);
					height = LegType.legHeight(LegType.BASE);
					legOffset = new Point( -legAnim.width / 2 + width / 2, -legAnim.height / 2 + C.TILE_SIZE/2);
					y -= 22;
				break;
			case LegType.SPIDER:
					legAnim = new Spritemap(GFX.LEG_ONE_ANIM, 112,72);
					legAnim.add("idle", [0], .1, true);
					legAnim.add("walk", [1], .1, true);
					height = LegType.legHeight(LegType.BASE);
					legOffset = new Point( -legAnim.width / 2 + width / 2, -legAnim.height / 2 + C.TILE_SIZE/2);
					y -= 22;
				break;
			default:
				trace("Leg type " + type + "Does not exist");
				break;
			}
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
				legAnim.play(bodyAnim.currentAnim);
				legAnim.flipped = facingLeft;
			}
			if (horn != HornType.NONE)
			{
				hornAnim.play(bodyAnim.currentAnim);
				hornAnim.flipped = facingLeft;
			}
			if (wings != WingType.NONE)
			{
				wingAnim.play(bodyAnim.currentAnim);
				wingAnim.flipped = facingLeft;
			}
		}
		
		//Apply velocity and check collisions
		private function updateMovement():void
		{
			velY += C.GRAVITY * floatVar;		//Gravity
			if (!Input.check("DOWN") && velY > maxYVel)		//If pressing down let fall faster
				velY = maxYVel;												//Else limit y vel
			
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
		
		private function handleControls():void
		{
			if (Input.pressed(Key.DIGIT_1)) if (legs == LegType.NONE) setLeg(LegType.SPIDER); else setLeg(LegType.NONE);
			if (Input.pressed(Key.DIGIT_2)) if (horn == HornType.NONE) setHorn(HornType.BASE); else setHorn(HornType.NONE);
			if (Input.pressed(Key.DIGIT_3)) if (wings == WingType.NONE) setWing(WingType.BASE); else setWing(WingType.NONE);
			
			if (Input.pressed("UP") && jumpsLeft > 0)
			{
				velY = jumpForce;
				jumpsLeft--;
				grounded = false;
			}
			if (Input.check("RIGHT"))
			{
				velX += accel;
				facingLeft = false;
			}
			if (Input.check("LEFT"))
			{
				velX -= accel;
				facingLeft = true;
			}
		}
		
		private function updateCamera():void
		{
			
			var camXTarg:Number = x + width/2 - FP.halfWidth;
			var camYTarg:Number = y + height/2 - FP.halfHeight*1.5;
			
			FP.setCamera(FP.lerp(camXTarg, FP.camera.x, .8), FP.lerp(camYTarg, FP.camera.y, .8));
		}
		
		override public function render():void 
		{
			super.render();
			pos.x = x;
			pos.y = y;
			bodyAnim.render(FP.buffer, pos, FP.camera);
			
			if (legs != LegType.NONE)
				legAnim.render(FP.buffer, pos.add(legOffset), FP.camera);
			if (horn != HornType.NONE)
				hornAnim.render(FP.buffer, pos.add(hornOffset), FP.camera);
			if (wings != WingType.NONE)
				wingAnim.render(FP.buffer, pos.add(wingOffset), FP.camera);
			
			
			
		}
	}

}
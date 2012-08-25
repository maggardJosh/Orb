package com.lionsteel.LD24.entities 
{
	import com.lionsteel.LD24.GFX;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.TiledSpritemap;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Josh Maggard
	 */
	public class Player extends Entity 
	{
		private var animSheet:Spritemap
		public function Player() 
		{
			animSheet = new Spritemap(GFX.PLAYER_ANIM, 30, 30);
			animSheet.add("idle", [ 0, 1, 2, 3, 4, 5 ], .1, true);
			animSheet.play("idle");
			graphic = animSheet;
		}
		
		override public function update():void 
		{
			super.update();
			updateCamera();
			handleControls();
		}
		
		private function handleControls():void
		{
			if (Input.check("UP"))
				y -= 3;
			if (Input.check("DOWN"))
			y += 3;
			if (Input.check("RIGHT"))
			x += 3;
		if (Input.check("LEFT"))
			x -= 3;
		}
		
		private function updateCamera():void
		{
			
			var camXTarg:Number = x + width/2 - FP.halfWidth;
			var camYTarg:Number = y + height/2 - FP.halfHeight;
			
			FP.setCamera(FP.lerp(camXTarg, FP.camera.x, .8), FP.lerp(camYTarg, FP.camera.y, .8));
		}
	}

}
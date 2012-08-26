package com.lionsteel.LD24 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Josh Maggard
	 */
	public class killIndicator extends Entity 
	{
		private var target:Point;
		private var tempPos:Point;
		private var screenPos:Point = new Point();
		private var startingCam:Point;
		public function killIndicator(src:Class, startPos:Point, target:Point) 
		{
			startingCam = FP.camera;
			this.x = startPos.x;
			screenPos.x = this.x - FP.camera.x;
			this.y = startPos.y;
			screenPos.y = this.y - FP.camera.y;
			this.target = target;
			graphic = new Image(src);
			
		}
		
		override public function update():void 
		{
			screenPos.x = screenPos.x * .9 + target.x * .1;
			screenPos.y = screenPos.y * .9 + target.y  * .1;
			
			if (Math.abs(screenPos.x - target.x) < 5&&
				Math.abs(screenPos.y - target.y) < 5)
					this.world.remove(this);
					
			this.x = screenPos.x + FP.camera.x;
			this.y = screenPos.y +  FP.camera.y;
				
		}
		
	}

}
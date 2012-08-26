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
	public class dropIndicator extends Entity 
	{
		private var target:Point;
		private var tempPos:Point;
		private var startingCam:Point;
		public function dropIndicator(src:Class, startPos:Point, target:Point) 
		{
			startingCam = FP.camera;
			this.x = startPos.x;
			this.y = startPos.y;
			this.target = target;
			graphic = new Image(src);
			
		}
		
		override public function update():void 
		{
			this.x = this.x * .9 + target.x * .1;
			this.y = this.y * .9 + target.y  * .1;
			
			if (Math.abs(this.x - target.x) < 5&&
				Math.abs(this.y - target.y) < 5)
					this.world.remove(this);
					
				
		}
		
	}

}
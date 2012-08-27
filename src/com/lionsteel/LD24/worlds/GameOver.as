package com.lionsteel.LD24.worlds 
{
	import adobe.utils.CustomActions;
	import com.lionsteel.LD24.GFX;
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Josh Maggard
	 */
	public class GameOver extends World 
	{
		private var selectedMenu:int = 0;
		private var backgroundOne:Backdrop;
		private var backgroundTwo:Backdrop;
		public function GameOver() 
		{
			
			backgroundOne = new Backdrop(GFX.BACKGROUND_ONE, true, false);
			backgroundOne.y = -10;
			backgroundOne.scrollX = .8;
			backgroundOne.scrollY = .5;
			backgroundTwo = new Backdrop(GFX.BACKGROUND_TWO, true, false);
			backgroundTwo.y = -10;
			backgroundTwo.scrollX = .4;
			backgroundTwo.scrollY = .4;		
			
			
		//	addGraphic(backgroundTwo);
		//	addGraphic(backgroundOne);
		}
		
		override public function update():void 
		{
			FP.camera.x += 2;
		
			if (Input.pressed("ATTACK") || Input.pressed("INTERACT"))
				doAction();
			super.update();
		}
		
		private function doAction():void
		{
			FP.world = new MainMenu();
		}
		override public function render():void 
		{
			backgroundTwo.render(FP.buffer, new Point(backgroundTwo.x, backgroundTwo.y), FP.camera);
				Text.size = 72;
			
			var startMenu:Text = new Text("Game Over");
			
			startMenu.render(FP.buffer, new Point(FP.halfWidth - startMenu.width / 2, FP.halfHeight - startMenu.height / 2), new Point());
			
			backgroundOne.render(FP.buffer, new Point(backgroundOne.x, backgroundOne.y), FP.camera);
			
			super.render();
		}
		
	}

}
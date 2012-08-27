package com.lionsteel.LD24.worlds 
{
	import adobe.utils.CustomActions;
	import com.lionsteel.LD24.GFX;
	import com.lionsteel.LD24.Main;
	import flash.geom.Point;
	import net.flashpunk.Entity;
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
			var ind = 0;
			for each(var entity in Main.DescendantHistory)
			{
				
				entity.x = FP.width + ind * 150;
				entity.y = 300;
				ind++;
			}
			
		//	addGraphic(backgroundTwo);
		//	addGraphic(backgroundOne);
		}
		
		override public function update():void 
		{
			//FP.camera.x += .7;
			backgroundTwo.x += .4 * .7;
			backgroundOne.x += .8 * .7;
			for each(var entity in Main.DescendantHistory)
			{
				entity.x -= 1.0;
				if (entity.x < -entity.width)
					entity.x += Math.max(Main.DescendantHistory.length * 150, FP.width + entity.width);
			}
			
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
			var ind:int = 0;
			for each(var entity in Main.DescendantHistory)
			{
				entity.render();
				Text.size = 30;
				var genText:Text = new Text("Gen " + ind)
				genText.render(FP.buffer, new Point(entity.x + entity.width / 2 - genText.width / 2, entity.y - genText.height - 10), FP.camera);
				ind ++;
			}
			
			startMenu.render(FP.buffer, new Point(FP.halfWidth - startMenu.width / 2, FP.halfHeight - startMenu.height / 2), new Point());
			
			backgroundOne.render(FP.buffer, new Point(backgroundOne.x, backgroundOne.y), FP.camera);
			
			super.render();
		}
		
	}

}
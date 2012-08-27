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
	public class MainMenu extends World 
	{
		private var selectedMenu:int = 0;
		private var backgroundOne:Backdrop;
		private var backgroundTwo:Backdrop;
		public function MainMenu() 
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
			if (Input.pressed("UP"))
				selectedMenu--;
			if (Input.pressed("DOWN"))
				selectedMenu++;
			if (selectedMenu < 0)
				selectedMenu = 1;
			else if (selectedMenu > 1)
				selectedMenu = 0;
			if (Input.pressed("ATTACK") || Input.pressed("INTERACT"))
				doAction();
			super.update();
		}
		
		private function doAction():void
		{
			switch(selectedMenu)
			{
				case 0:		//Start Game
					FP.world = new GameWorld();
					break;
					
				case 1:	//Quit Game
					
					break;
			}
		}
		override public function render():void 
		{
			backgroundTwo.render(FP.buffer, new Point(backgroundTwo.x, backgroundTwo.y), FP.camera);
			if (selectedMenu == 0)
			{
				Text.size = 40;
			}
			else
				Text.size = 32;
			var startMenu:Text = new Text("Start Game");
			if (selectedMenu == 0)
				startMenu.color = 0xAAAA00;
			else
				startMenu.color = 0xFFFFFF;

			startMenu.render(FP.buffer, new Point(FP.halfWidth - startMenu.width / 2, FP.halfHeight - startMenu.height / 2 - 30), new Point());
			if (selectedMenu == 1)
				Text.size = 40;
			else
				Text.size = 32;
			var quitMenu:Text = new Text("Quit Game");
			if (selectedMenu == 1)
				quitMenu.color = 0xAAAA00;
			else
				quitMenu.color = 0xFFFFFF;
			quitMenu.render(FP.buffer, new Point(FP.halfWidth - quitMenu.width / 2, FP.halfHeight - quitMenu.height / 2 + 30), new Point());
			backgroundOne.render(FP.buffer, new Point(backgroundOne.x, backgroundOne.y), FP.camera);
			
			super.render();
		}
		
	}

}
package com.lionsteel.LD24.worlds 
{
	import com.lionsteel.LD24.entities.Enemy;
	import com.lionsteel.LD24.entities.Level;
	import com.lionsteel.LD24.entities.Player;
	import com.lionsteel.LD24.GFX;
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import org.flashdevelop.utils.TraceLevel;
	
	/**
	 * World that is our game
	 * @author Josh Maggard
	 */
	public class GameWorld extends World 
	{
		[Embed (source = "../assets/Levels/levelOne.oel", mimeType = "application/octet-stream")] private const levelOneXML:Class;
		[Embed (source = "../assets/Levels/levelTwo.oel", mimeType = "application/octet-stream")] private const levelTwoXML:Class;
		private var levels:Array = new Array( levelOneXML, levelTwoXML );
		public var levelNum:int;
		private var backgroundOne:Backdrop;
		private var backgroundTwo:Backdrop;
		public var player:Player;
		private var currentLevel:Level;
		
		private var tutText:Array = new Array();
		
		private var tutCount:int = 0;
		private var tutLengthEach:int = 5000;
		
		private var particleEmitter:Emitter;
		public function GameWorld( levelNum:int, playerVar:Player) 
		{
			Text.size = 30;
			tutText[0] = new Text("WASD - Move");
			tutText[1] = new Text("Space - Jump");
			tutText[2] = new Text("E - Interact/Pickup");
			tutText[3] = new Text("Enter - Attack with Arms or Tail");
			tutText[4] = new Text("Kill the same type of enemy\nenough times and gain their ability!");
			tutText[5] = new Text("Good Luck!");
			
			for (var ind:int = 0; ind < tutText.length; ind++)
				tutText[ind].alpha = 0;
			
			this.levelNum = levelNum;
			particleEmitter = new Emitter(GFX.PARTICLE_ONE, 10, 10);
			particleEmitter.newType("death", [0]);
			particleEmitter.setAlpha("death", 1, 0);
			particleEmitter.setMotion("death", 50,50, 10, 90, 25, 5);
			
			
			backgroundOne = new Backdrop(GFX.BACKGROUND_ONE, true, false);
			backgroundOne.y = -150;
			backgroundOne.scrollX = .8;
			backgroundOne.scrollY = .5;
			backgroundTwo = new Backdrop(GFX.BACKGROUND_TWO, true, false);
			backgroundTwo.y = -150;
			backgroundTwo.scrollX = .4;
			backgroundTwo.scrollY = .4;
			this.player = playerVar;
			player.layer = -1;
			
			
			
			
			addGraphic(backgroundTwo);
			add(player);
			addGraphic(backgroundOne);
			
			nextLevel();
			
			
		}
		
		public function gameOver():void
		{
			FP.world = new GameOver();
		}
		
		public function resetLevel():void
		{
			if (currentLevel != null)
			{
				currentLevel.clearLevel();
				this.remove(currentLevel);
			}
			currentLevel = new Level(levels[levelNum], particleEmitter, this, player);
			
			player.setLevel(currentLevel);
			player.startBirth();
			
			player.x = currentLevel.playerStart.x;
			player.y = currentLevel.playerStart.y;
			currentLevel.player = player;
		}
		
		public function nextLevel():void
		{
			if (currentLevel != null)
			{
				currentLevel.clearLevel();
				this.remove(currentLevel);
			}
			
			if (levelNum >= levels.length)
				levelNum = 0;
			currentLevel = new Level(levels[levelNum], particleEmitter, this, player);
			
			player.setLevel(currentLevel);
			
			player.x = currentLevel.playerStart.x;
			player.y = currentLevel.playerStart.y;
			currentLevel.player = player;
			
		}
		
		override public function update():void 
		{
			super.update();
			
			if(levelNum == 0 && tutCount < tutText.length*tutLengthEach)
				tutCount += 16
				
			backgroundOne.x -= .1;
			backgroundTwo.x -= .05;
		}
		
		
		override public function render():void 
		{
			super.render();
			if (levelNum == 0)
			{
				for (var ind:int = 0; ind < tutText.length; ind++)
				{
					if (int(tutCount / tutLengthEach) != ind)
					{
						if(Text(tutText[ind]).alpha >0)
							Text(tutText[ind]).alpha -= .1;
					}
						else
						if(Text(tutText[ind]).alpha < 1)
							Text(tutText[ind]).alpha += .03;
						Text(tutText[ind]).render(FP.buffer, new Point(FP.halfWidth - Text(tutText[ind]).width / 2, 100), new Point());
				}
			}
		}
		
	}

}
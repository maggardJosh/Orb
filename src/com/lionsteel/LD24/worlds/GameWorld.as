package com.lionsteel.LD24.worlds 
{
	import com.lionsteel.LD24.entities.Enemy;
	import com.lionsteel.LD24.entities.Level;
	import com.lionsteel.LD24.entities.Player;
	import com.lionsteel.LD24.GFX;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Emitter;
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
		private var levelNum:int = -1;
		private var backgroundOne:Backdrop;
		private var backgroundTwo:Backdrop;
		public var player:Player;
		private var currentLevel:Level;
		
		private var particleEmitter:Emitter;
		public function GameWorld() 
		{
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
			player = new Player(null);
			player.layer = -1
			
			
			
			
			
			addGraphic(backgroundTwo);
			add(player);
			
			addGraphic(backgroundOne);
			
			nextLevel();
			
			
		}
		
		public function nextLevel():void
		{
			if (currentLevel != null)
			{
				currentLevel.clearLevel();
				this.remove(currentLevel);
			}
			levelNum++;
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
			
			backgroundOne.x -= .1;
			backgroundTwo.x -= .05;
		}
		
		
	}

}
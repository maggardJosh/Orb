package com.lionsteel.LD24.worlds 
{
	import com.lionsteel.LD24.BodyTypes.WingType;
	import com.lionsteel.LD24.C;
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
		[Embed (source = "../assets/Levels/Tutorial_level.oel", mimeType = "application/octet-stream")] private const tutLevelXML:Class;
		[Embed (source = "../assets/Levels/LEVEL_ONE.oel", mimeType = "application/octet-stream")] private const levelOneXML:Class;
		[Embed (source = "../assets/Levels/LEVEL_TWO.oel", mimeType = "application/octet-stream")] private const levelTwoXML:Class;
		[Embed (source = "../assets/Levels/LEVEL_THREE.oel", mimeType = "application/octet-stream")] private const levelThreeXML:Class;
		[Embed (source = "../assets/Levels/LEVEL_FOUR.oel", mimeType = "application/octet-stream")] private const levelFourXML:Class;
		[Embed (source = "../assets/Levels/LEVEL_FIVE.oel", mimeType = "application/octet-stream")] private const levelFiveXML:Class;
		public var levels:Array = new Array( tutLevelXML, levelOneXML, levelTwoXML, levelThreeXML, levelFourXML, levelFiveXML);
		public var levelNum:int;
		private var backgroundOne:Backdrop;
		private var backgroundTwo:Backdrop;
		public var player:Player;
		private var currentLevel:Level;
		
		private var tutText:Array = new Array();
		private var tutPos:Array = new Array();
		
		private var tutEndCount:int = 0;
		private var tutLengthEach:int = 5000;
		
		private var tutEndText:Text;
		
		private var particleEmitter:Emitter;
		public function GameWorld( levelNum:int, playerVar:Player) 
		{
			Text.size = 28;
			tutEndText = new Text("Have Fun!");
			
			tutText[0] = new Text("Use WASD to move\nand space to jump\n(Press escape to skip tutorial)");
			tutText[1] = new Text("Jump on enemies to kill them\n(Watch out for spikes)");
			tutText[2] = new Text("Kill enough similar\nenemies in a row\nto get their traits\n(Use E to pick up dropped traits)");
			tutText[3] = new Text("Certain traits allow you\nto fly or jump multiple times\n(Hold Space to coast)");
			tutText[4] = new Text("Use Enter to attack with your\narms or tail");
			tutText[5] = new Text("Use E to pick a mate\nMating randomizes your traits\nand allows you to have\nmore at one time");
			
			tutPos[ -1] = 0;
			tutPos[0] = 24 * C.TILE_SIZE;
			tutPos[1] = 44 * C.TILE_SIZE;
			tutPos[2] = 71 * C.TILE_SIZE;
			tutPos[3] = 108 * C.TILE_SIZE;
			tutPos[4] = 180 * C.TILE_SIZE;
			tutPos[5] = 200 * C.TILE_SIZE;
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
			
			currentLevel = new Level(levels[levelNum], particleEmitter, this, player);
			
			player.setLevel(currentLevel);
			
			player.x = currentLevel.playerStart.x;
			player.y = currentLevel.playerStart.y;
			currentLevel.player = player;
			
		}
		
		override public function update():void 
		{
			
			super.update();
			
			if (levelNum == 0 && Input.pressed(Key.ESCAPE))
			{
				currentLevel.clearLevel();
				FP.world.remove(player);
				FP.world = new GameWorld(1, new Player(currentLevel));
			}
			
			if(levelNum == 1 && tutEndCount < 2000)
				tutEndCount += 16
			else
			if (levelNum == 1 && tutEndText.alpha > 0)
				tutEndText.alpha -= .01;
				
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
					if ( player.x < tutPos[ind] && player.x > tutPos[ind-1])
					{
						if(Text(tutText[ind]).alpha < 1)
							Text(tutText[ind]).alpha += .03;
					}
						else
						if(Text(tutText[ind]).alpha >0)
							Text(tutText[ind]).alpha -= .1;
							
					Text(tutText[ind]).render(FP.buffer, new Point(FP.halfWidth - Text(tutText[ind]).width / 2, 80), new Point());
				}
			}else
			if (levelNum == 1)
			{
				tutEndText.render(FP.buffer,  new Point(FP.halfWidth - tutEndText.width / 2, 100), new Point());
			}
		}
		
	}

}
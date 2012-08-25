package com.lionsteel.LD24.worlds 
{
	import com.lionsteel.LD24.entities.Enemy;
	import com.lionsteel.LD24.entities.Level;
	import com.lionsteel.LD24.entities.Player;
	import com.lionsteel.LD24.GFX;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Backdrop;
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
		[Embed (source = "../assets/Levels/levelOne.oel", mimeType="application/octet-stream")] private const levelXML:Class;
		private var backgroundOne:Backdrop;
		private var backgroundTwo:Backdrop;
		private var player:Player;
		private var currentLevel:Level;
		public function GameWorld() 
		{
			backgroundOne = new Backdrop(GFX.BACKGROUND_ONE, true, false);
			backgroundOne.scrollX = .8;
			backgroundOne.scrollY = .2;
			backgroundTwo = new Backdrop(GFX.BACKGROUND_TWO, true, false);
			backgroundTwo.scrollX = .4;
			backgroundTwo.scrollY = .1;
			
			currentLevel = new Level(levelXML);
			player = new Player();
			
			player.x = currentLevel.playerStart.x;
			player.y = currentLevel.playerStart.y;
			
			var enemy:Enemy = new Enemy();
			enemy.x = player.x + 10;
			enemy.y = player.y;
			
			
			addGraphic(backgroundTwo);
			add(enemy);
			add(player);
			add(currentLevel);
			
			addGraphic(backgroundOne);
			
			
		}
		
		
	}

}
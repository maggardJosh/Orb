package com.lionsteel.LD24
{
	import com.lionsteel.LD24.worlds.GameWorld;
	import flash.display.Sprite;
	import flash.events.Event;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Josh Maggard
	 */
	[SWF(width="640", height="480", frameRate="60",backgroundColor="#FFFFFF")]
	public class Main extends Engine 
	{
		public function Main()
		{
			
			super(640, 480, 60, true);
			FP.world = new GameWorld();
		}
		
	}
	
}
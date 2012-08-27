package com.lionsteel.LD24
{
	import com.lionsteel.LD24.BodyTypes.ArmType;
	import com.lionsteel.LD24.BodyTypes.HornType;
	import com.lionsteel.LD24.BodyTypes.LegType;
	import com.lionsteel.LD24.BodyTypes.TailType;
	import com.lionsteel.LD24.BodyTypes.WingType;
	import com.lionsteel.LD24.worlds.GameWorld;
	import com.lionsteel.LD24.worlds.MainMenu;
	import flash.display.Sprite;
	import flash.events.Event;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Josh Maggard
	 */
	[SWF(width="640", height="480", frameRate="60",backgroundColor="#FFFFFF")]
	public class Main extends Engine 
	{
		public function Main()
		{
			ArmType.init();
			TailType.init();
			LegType.init();
			HornType.init();
			WingType.init();
			
			super(640, 480, 60, true);
			FP.world = new MainMenu();
			FP.screen.color = 0x3333AA;
			
			//Define controls for arrow keys and wasd
			Input.define("UP", Key.UP, Key.W, Key.SPACE);
			Input.define("DOWN", Key.DOWN, Key.S);
			Input.define("LEFT", Key.LEFT, Key.A);
			Input.define("RIGHT", Key.RIGHT, Key.D);
			Input.define("ATTACK", Key.ENTER);
			Input.define("INTERACT", Key.E);
		}
		
	}
	
}
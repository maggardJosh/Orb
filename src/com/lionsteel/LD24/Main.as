package com.lionsteel.LD24
{

	import com.lionsteel.LD24.BodyTypes.*;
	import com.lionsteel.LD24.worlds.MainMenu;
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
		public static var DescendantHistory:Array = new Array();
		public function Main()
		{
			
			
			super(640, 480, C.FRAMES_PER_SECOND, true);
			FP.world = new MainMenu();
			FP.screen.color = 0x3333AA;
			
			//{region define controls
			Input.define("UP", Key.UP, Key.W, Key.SPACE);
			Input.define("DOWN", Key.DOWN, Key.S);
			Input.define("LEFT", Key.LEFT, Key.A);
			Input.define("RIGHT", Key.RIGHT, Key.D);
			Input.define("ATTACK", Key.ENTER);
			Input.define("INTERACT", Key.E);
			//}endregion
			
			
		}
		
		override public function init():void 
		{
			
			//{region BodyType inits
			ArmType.init();
			TailType.init();
			LegType.init();
			HornType.init();
			WingType.init();
			BodyType.init();
			//}endregion
			
			Kongregate.connect(FP.stage);
			super.init();
		}
		
		
		override public function update():void 
		{
			Utils.quake.update();
			Utils.flash.update();
			super.update();
		}
		
		override public function render():void 
		{
			super.render();
			Utils.flash.render();
		}
		
	}
	
}
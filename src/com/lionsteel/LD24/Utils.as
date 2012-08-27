package com.lionsteel.LD24
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import com.lionsteel.LD24.Utils.*;
	
	import net.flashpunk.FP;
	
	public final class Utils
	{
		public static var quake:Quake = new Quake;
		public static var flash:Flash = new Flash;
		
		public static function openURL(url:String):void
		{
			navigateToURL(new URLRequest(url));
		}
		
		public static function pan(centerX:Number):Number
		{
			return ((centerX-FP.camera.x) / FP.width) * 2 - 1;
		}
	}
}
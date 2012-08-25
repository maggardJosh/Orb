package com.lionsteel.LD24.entities 
{
	import com.lionsteel.LD24.GFX;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	
	/**
	 * ...
	 * @author Josh Maggard
	 */
	public class Level extends Entity 
	{
		
		private var tileMap:Tilemap;
		private var grid:Grid;
		
		public function Level() 
		{
			tileMap = new Tilemap(GFX.TILE_SET, 2000, 640, 32, 32);
			
			tileMap.setRect(3, 4, 1, 10, 0);
			tileMap.setRect(4, 4, 10, 10, 1);
			tileMap.setRect(14, 4, 1, 10, 2);
			
			this.graphic = tileMap;
		}
		
	}

}
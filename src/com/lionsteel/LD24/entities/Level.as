package com.lionsteel.LD24.entities 
{
	import com.lionsteel.LD24.C;
	import com.lionsteel.LD24.GFX;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.World;
	
	/**
	 * Stores a level's tileMap, collision grid, and entities
	 * @author Josh Maggard
	 */
	public class Level extends Entity 
	{
		//{region Variables
		private var tileMap:Tilemap;		//TileMap
		private var grid:Grid;				//Collision Grid
		
		public var mapWidth:int;			//Width (in pixels) of the map
		public var mapHeight:int;			//Height (in pixels) of the map
		
		public var playerStart:Point;			//player spawn point
		public var particleEmitter:Emitter;		//Emitter that is in charge of all particles
		private var levelNum:int;				//current level number 0=first level
		
		public var player:Player;					//Reference to our player object
		private var enemyList:Array = new Array();	//List of all enemies in level
		//}endregion
		
		public function Level(xml:Class, emitter:Emitter, world:World, player:Player) 
		{
			//Add ourselves to the world
			world.add(this);
			
			this.player = player;
			this.particleEmitter = emitter;
			loadLevel(xml);		//Load the level from the xml that was passed
			
			type = "level";			//Collision type = "Level"
			
			this.graphic = tileMap;			//We are displayed by our tileMap
			this.mask = grid;				//And collide with our grid
		}
		
		/**
		 * removes all entities from the world
		 */
		public function clearLevel():void
		{
			for each(var entity:Entity in enemyList)
			{
				if(entity.world != null)
					entity.world.remove(entity);
			}
			
		}
		
		/**
		 * Load this level from an xml list. Works with levels exported from OGMO
		 * @param	xml	XML list to load from
		 */
		private function loadLevel(xml:Class):void
		{
			var rawData:ByteArray = new xml;
			var dataString:String = rawData.readUTFBytes( rawData.length );
			var xmlData:XML = new XML(dataString);
			
			var dataList:XMLList;
			var dataElement:XML;
			
			mapWidth = int(xmlData.@width);
			mapHeight = int(xmlData.@height);
			
			//New tileMap and collision grid based off mapWidth and mapHeight
			tileMap = new Tilemap(GFX.TILE_SET, mapWidth, mapHeight, C.TILE_SIZE, C.TILE_SIZE);
			grid = new Grid(mapWidth, mapHeight, C.TILE_SIZE, C.TILE_SIZE);
			
			dataList = xmlData.tilemap.tile;	//Get a list of all the tiles
			for each(dataElement in dataList)
			{
				//Set tileMap
				tileMap.setTile(int(dataElement.@x), int(dataElement.@y), int(dataElement.@id));				
			}	
			
			//Get our collision grid
			for each(dataElement in xmlData.Collision)
			{
				var bitString:String = dataElement;
				var xValue:int = 0;
				var yValue:int = 0;
				for (var ind:int = 0; ind < bitString.length; ind++)
				{
					if (bitString.charAt(ind) == "\n")	//If we've reached the end-of-line
					{
						//Next line in grid
						xValue = 0;	
						yValue++;
					}
					else
					{
						grid.setTile(xValue, yValue, bitString.charAt(ind) == "1");
						xValue++;
					}
				}
			}
			
			//Load start point
			dataList = xmlData.entities.playerStart;
			for each(dataElement in dataList)
				playerStart = new Point( int(dataElement.@x), int(dataElement.@y));
			
			//TODO load new enemies from OGMO levels
			var enemyAdd:Enemy;
			/* Old enemy add code
			
			dataList = xmlData.entities.OneTrait;
			for each(dataElement in dataList)
			{
				enemyAdd = new Enemy(1, this);
				enemyList.push(enemyAdd);
				enemyAdd.x = int(dataElement.@x);
				enemyAdd.y = int(dataElement.@y);
				world.add(enemyAdd);
			}
			
			dataList = xmlData.entities.TwoTraits;
			for each(dataElement in dataList)
			{
				enemyAdd = new Enemy(2, this);
				enemyList.push(enemyAdd);
				enemyAdd.x = int(dataElement.@x);
				enemyAdd.y = int(dataElement.@y);
				world.add(enemyAdd);
			}
			
			dataList = xmlData.entities.ThreeTraits;
			for each(dataElement in dataList)
			{
				enemyAdd = new Enemy(3, this);
				enemyList.push(enemyAdd);
				enemyAdd.x = int(dataElement.@x);
				enemyAdd.y = int(dataElement.@y);
				world.add(enemyAdd);
			}
			dataList = xmlData.entities.FourTraits;
			for each(dataElement in dataList)
			{
				enemyAdd = new Enemy(4, this);
				enemyList.push(enemyAdd);
				enemyAdd.x = int(dataElement.@x);
				enemyAdd.y = int(dataElement.@y);
				world.add(enemyAdd);
			}
			
			dataList = xmlData.entities.FivTraits;
			for each(dataElement in dataList)
			{
				enemyAdd = new Enemy(5, this);
				enemyList.push(enemyAdd);
				enemyAdd.x = int(dataElement.@x);
				enemyAdd.y = int(dataElement.@y);
				world.add(enemyAdd);
			}*/
			
		}
		
		/**
		 * Adds an entity to the level
		 * Also sorts them into lists (such as enemyList)
		 * @param	entity	Entity to put in level
		 */
		public function add(entity:Entity):void
		{
			world.add(entity);
			if(entity is Enemy)
				enemyList.push(entity);
		}
		
		/**
		 * Overridden update so that we can call the particle emitter update with it
		 */
		override public function update():void 
		{
			particleEmitter.update();
			
			super.update();
		}
		
		/**
		 * Overridden render to call particleEmitter.render as well
		 */
		override public function render():void 
		{
			super.render();
			particleEmitter.render(FP.buffer, new Point, FP.camera);
		}
	}

}
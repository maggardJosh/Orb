package com.lionsteel.LD24.entities 
{
	import com.lionsteel.LD24.BodyTypes.ArmType;
	import com.lionsteel.LD24.BodyTypes.HornType;
	import com.lionsteel.LD24.BodyTypes.LegType;
	import com.lionsteel.LD24.BodyTypes.TailType;
	import com.lionsteel.LD24.BodyTypes.WingType;
	import com.lionsteel.LD24.C;
	import com.lionsteel.LD24.GFX;
	import com.lionsteel.LD24.worlds.GameWorld;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Josh Maggard
	 */
	public class Level extends Entity 
	{
		
		private var tileMap:Tilemap;
		private var grid:Grid;
		
		public var mapWidth:int;
		public var mapHeight:int;
		
		public var playerStart:Point;
		public var particleEmitter:Emitter;
		private var levelNum:int;
		
		public var player:Player;
		private var enemyList:Array = new Array();
		
		public function Level(xml:Class, emitter:Emitter, world:World, player:Player) 
		{
			world.add(this);
			this.player = player;
			this.particleEmitter = emitter;
			loadLevel(xml);
			
			type = "level";
			
			this.graphic = tileMap;
			this.mask = grid;
		}
		
		public function clearLevel():void
		{
			for each(var entity:Entity in enemyList)
			{
				if(entity.world != null)
					entity.world.remove(entity);
			}
			
		}
		
		private function loadLevel(xml:Class):void
		{
			var rawData:ByteArray = new xml;
			var dataString:String = rawData.readUTFBytes( rawData.length );
			var xmlData:XML = new XML(dataString);
			
			var dataList:XMLList;
			var dataElement:XML;
			
			mapWidth = int(xmlData.@width);
			mapHeight = int(xmlData.@height);
			
			tileMap = new Tilemap(GFX.TILE_SET, mapWidth, mapHeight, C.TILE_SIZE, C.TILE_SIZE);
			grid = new Grid(mapWidth, mapHeight, C.TILE_SIZE, C.TILE_SIZE);
			
			dataList = xmlData.tilemap.tile;
			for each(dataElement in dataList)
			{
				tileMap.setTile(int(dataElement.@x), int(dataElement.@y), int(dataElement.@id));				
			}
			for each(dataElement in xmlData.Collision)
			{
				var bitString:String = dataElement;
				var xValue:int = 0;
				var yValue:int = 0;
				for (var ind:int = 0; ind < bitString.length; ind++)
				{
					if (bitString.charAt(ind) == "\n")
					{
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
			{
				playerStart = new Point( int(dataElement.@x), int(dataElement.@y));
			}
			var enemyAdd:Enemy;
			
			
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
			}
			
			if (GameWorld(world).levelNum == 0)
				spawnTutorialStuff();
		}
		
		private function spawnTutorialStuff():void
		{
			var newEnemy:Enemy;
			
			//Jump Tutorial
			newEnemy = new Enemy(0, this);
			newEnemy.setHorn(HornType.SPIKE);
			newEnemy.x = 31*C.TILE_SIZE;
			newEnemy.y = 25 * C.TILE_SIZE;
			add(newEnemy);
			
			newEnemy = new Enemy(0, this);
			newEnemy.setArm(ArmType.BASE);
			newEnemy.x = 28 * C.TILE_SIZE;
			newEnemy.y = 25 * C.TILE_SIZE;
			add(newEnemy);
			
			newEnemy = new Enemy(0, this);
			newEnemy.setTail(TailType.MONKEY);
			newEnemy.x = 30 * C.TILE_SIZE;
			newEnemy.y = 25 * C.TILE_SIZE;
			add(newEnemy);
			
			newEnemy = new Enemy(0, this);
			newEnemy.setLeg(LegType.JABA);
			newEnemy.x = 31 * C.TILE_SIZE;
			newEnemy.y = 25 * C.TILE_SIZE;
			add(newEnemy);
			
			newEnemy = new Enemy(0, this);
			newEnemy.setLeg(LegType.JABA);
			newEnemy.x = 31 * C.TILE_SIZE;
			newEnemy.y = 25 * C.TILE_SIZE;
			add(newEnemy);
			
			newEnemy = new Enemy(0, this);
			newEnemy.setLeg(LegType.JABA);
			newEnemy.x = 31 * C.TILE_SIZE;
			newEnemy.y = 25 * C.TILE_SIZE;
			add(newEnemy);
			
			//Trait Tutorial
			newEnemy = new Enemy(0, this);
			newEnemy.setHorn(HornType.PLANT);
			newEnemy.x = 46 * C.TILE_SIZE;
			newEnemy.y = 25 * C.TILE_SIZE;
			add(newEnemy);
			
			newEnemy = new Enemy(0, this);
			newEnemy.setHorn(HornType.PLANT);
			newEnemy.x =  47* C.TILE_SIZE;
			newEnemy.y = 25 * C.TILE_SIZE;
			add(newEnemy);
			
			newEnemy = new Enemy(0, this);
			newEnemy.setHorn(HornType.PLANT);
			newEnemy.x =  47* C.TILE_SIZE;
			newEnemy.y = 25 * C.TILE_SIZE;
			add(newEnemy);
			
			newEnemy = new Enemy(0, this);
			newEnemy.setHorn(HornType.PLANT);
			newEnemy.x =  47* C.TILE_SIZE;
			newEnemy.y = 25 * C.TILE_SIZE;
			add(newEnemy);
			
			newEnemy = new Enemy(0, this);
			newEnemy.setHorn(HornType.PLANT);
			newEnemy.x =  50* C.TILE_SIZE;
			newEnemy.y = 25 * C.TILE_SIZE;
			add(newEnemy);
			
			newEnemy = new Enemy(0, this);
			newEnemy.setHorn(HornType.PLANT);
			newEnemy.x = 55 * C.TILE_SIZE;
			newEnemy.y = 25 * C.TILE_SIZE;
			add(newEnemy);
			
			newEnemy = new Enemy(0, this);
			newEnemy.setHorn(HornType.PLANT);
			newEnemy.x = 55 * C.TILE_SIZE;
			newEnemy.y = 25 * C.TILE_SIZE;
			add(newEnemy);
			
			newEnemy = new Enemy(0, this);
			newEnemy.setHorn(HornType.PLANT);
			newEnemy.x =  57* C.TILE_SIZE;
			newEnemy.y = 25 * C.TILE_SIZE;
			add(newEnemy);
			
			
			for ( var ind:int = 0; ind < 10; ind ++)
			{
				newEnemy = new Enemy(0, this);
				newEnemy.setHorn(HornType.SPIKE);
				newEnemy.x = 115 * C.TILE_SIZE;
				newEnemy.y = 20 * C.TILE_SIZE;
				add(newEnemy);
			}
		}
		
		public function add(entity:Entity):void
		{
			world.add(entity);
			enemyList.push(entity);
		}
		
		override public function update():void 
		{
			particleEmitter.update();
			
			super.update();
		}
		override public function render():void 
		{
			super.render();
			particleEmitter.render(FP.buffer, new Point, FP.camera);
		}
	}

}
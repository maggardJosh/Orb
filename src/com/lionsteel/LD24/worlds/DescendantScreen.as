package com.lionsteel.LD24.worlds 
{
	import com.lionsteel.LD24.entities.Mate;
	import com.lionsteel.LD24.entities.Monster;
	import com.lionsteel.LD24.entities.Player;
	import com.lionsteel.LD24.GFX;
	import com.lionsteel.LD24.Main;
	import flash.accessibility.ISearchableText;
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Josh Maggard
	 */
	public class DescendantScreen extends World 
	{
		private var screen:Image;
		private var leftParent:Monster;
		private var rightParent:Monster;
		private var descendant:Player;
		private var nextLevel:int;
		private var lowerHeight:int;		//Used to show bottom of screen
		public function DescendantScreen(leftParent:Monster, rightParent:Monster, descendant:Player, nextLevel:int) 
		{
			lowerHeight = 1;
			this.leftParent = leftParent;
			this.rightParent = rightParent;
			this.descendant = descendant;
			this.nextLevel = nextLevel;
		
			leftParent.x = 190;
			leftParent.y = 120;
			leftParent.facingLeft = false;
			
			Mate(rightParent).collidingWithPlayer = false;
			rightParent.x = 415;
			rightParent.y = 120;
			rightParent.facingLeft = true;
			
			descendant.playBirth();
			descendant.eggImage.alpha = 1;
			descendant.x = FP.halfWidth - 16;
			descendant.y = 320;
			
			Main.DescendantHistory.push(leftParent);
			Main.DescendantHistory.push(descendant.copy());
			
			screen = new Image(GFX.DESCENDANT_SCREEN);
			
			
		}
		
		override public function update():void 
		{
			if (descendant.eggImage.alpha > 0)
				descendant.eggImage.alpha -= .01;
			if (Input.pressed("INTERACT") || Input.pressed("ATTACK"))
			{
				descendant.eggImage.alpha = 0;
				descendant
				FP.world = new GameWorld(nextLevel, descendant);
			}
			super.update();
		}
		
		override public function render():void 
		{
			screen.render(FP.buffer, new Point(), new Point());
			leftParent.render();
			rightParent.render();
			Monster(descendant).render();
			super.render();
		}
		
	}

}
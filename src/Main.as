package 
{
	import citrus.core.CitrusEngine;
	import citrus.core.IState;
	import citrus.utils.LevelManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import utils.Stats;
	import space_digger.levels.*;
	
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class Main extends CitrusEngine
	{
		public static const DEBUG:Boolean = false;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			levelManager = new LevelManager(GameLevel);
			levelManager.onLevelChanged.add(onLevelChanged);
			levelManager.levels = 
				[[LevelSpace, "../swf/levels/LevelSpace.swf"],
				[LevelDig, "../swf/levels/Level1.swf"],
				[LevelPlanet, "../swf/levels/LevelPlanet.swf"]];
			levelManager.gotoLevel();
		
			if (Main.DEBUG)
				addChild(new Stats());
		}
		
		private function onLevelChanged(level:GameLevel):void
		{
			state = level;
			
			level.lvlEnded.add(nextLevel);
			level.lvlBack.add(previousLevel);
			level.restartLevel.add(restartLevel);
			level.changeLevel.add(changeLevel);
		}
		
		private function nextLevel():void
		{
			(levelManager.currentLevel as GameLevel).dispose();
			levelManager.nextLevel();
		}
		
		private function previousLevel():void
		{
			(levelManager.currentLevel as GameLevel).dispose();
			levelManager.prevLevel();
		}
		
		private function restartLevel():void
		{
			state = levelManager.currentLevel as IState;
		}
		
		public function changeLevel(levelIndex:int):void
		{
			if (levelIndex != levelManager.currentIndex)
			{
				(levelManager.currentLevel as GameLevel).dispose();
				levelManager.gotoLevel(levelIndex);
			}
		}
	}
}
package 
{
	import citrus.core.CitrusEngine;
	import citrus.core.IState;
	import citrus.utils.LevelManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import utils.Stats;
	import space_digger.levels.*;
	import data.Mine;
	
	import managers.*;
	
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class Main extends CitrusEngine
	{
		public static const DEBUG:Boolean = false;//CONFIG::debug;
		
		private var _currentLevelIndex:int = 0;
		
		public function Main():void 
		{
			if (stage)
				init();
			else 
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			levelManager = new LevelManager(GameLevel);
			levelManager.onLevelChanged.add(onLevelChanged);
			levelManager.levels = 
				[
					[LevelRegister, "../swf/levels/LevelRegister.swf"],
					[LevelSpace, "../swf/levels/LevelSpace.swf"],
					[LevelDig, "../swf/levels/Level1.swf"],
					[LevelDig, "../swf/levels/Level2.swf"],
					[LevelDig, "../swf/levels/Level3.swf"],
					[LevelDig, "../swf/levels/Level4.swf"],
					[LevelDig, "../swf/levels/Level5.swf"],
				];
		
			//if (Main.DEBUG)
			//	addChild(new Stats());

			GameManager.getInstance().needsRegistration.add(goToLevelRegister);
			GameManager.getInstance().ready.add(goToLevelSpace);
			GameManager.getInstance().loggedOut.add(goToLevelRegister);
			GameManager.getInstance().startFailed.add(goToLevelRegister);
			GameManager.getInstance().changeLevelRequest.add(travelToMine);
			GameManager.getInstance().start();
			
			GameManager.getInstance().stateUpdated.add(onStateUpdated);
			GameManager.getInstance().systemUpdated.add(onSystemUpdated);
			GameManager.getInstance().systemChanged.add(onSystemChanged);
			GameManager.getInstance().rankingUpdated.add(onRankingUpdated);
		}
		
		private function goToLevelRegister():void
		{
			changeLevel(1);
		}
		
		private function goToLevelSpace():void
		{
			changeLevel(2);
		}
		
		private function onLevelChanged(level:GameLevel):void
		{
			state = level;
			
			/*level.lvlEnded.add(nextLevel);
			level.lvlBack.add(previousLevel);	
			level.restartLevel.add(restartLevel);
			level.changeLevel.add(changeLevel);*/
			
			onStateUpdated();
			onSystemUpdated();
			onSystemChanged();
			onRankingUpdated();
		}
		
		protected function travelToMine(mine:Mine):void
		{
			DataManager.getInstance().currentMine = mine;
			
			changeLevel(GameManager.getInstance().getClientMapIndexFromServerMapId(mine.map));
		}
		
		/*private function nextLevel():void
		{
			(levelManager.currentLevel as GameLevel).dispose();
			levelManager.nextLevel();
		}
		
		private function previousLevel():void
		{
			(levelManager.currentLevel as GameLevel).dispose();
			levelManager.prevLevel();
		}*/
		
		private function restartLevel():void
		{
			state = levelManager.currentLevel as IState;
		}
		
		public function changeLevel(levelIndex:int):void
		{
			if (levelIndex != _currentLevelIndex)
			{
				levelManager.gotoLevel(levelIndex);
				_currentLevelIndex = levelIndex;
			}
		}
		
		protected function onStateUpdated():void
		{
			var levelSpace:LevelSpace = state as LevelSpace;
			
			if (levelSpace){
				levelSpace.setCompanyData();
				levelSpace.setOngoingOperations();
				
				if(levelSpace.recentActivityScroller)
					levelSpace.setRecentActivity();
			}
		}
		
		protected function onSystemUpdated():void
		{
			var levelSpace:LevelSpace = state as LevelSpace;
			
			if (levelSpace){
				levelSpace.setSystemData();
				if (levelSpace.popupPlanet && levelSpace.contains(levelSpace.popupPlanet))
					levelSpace.setPlanetPopupData(levelSpace.popupPlanet.planetIndex);
			}
		}
		
		protected function onSystemChanged():void
		{
			var levelSpace:LevelSpace = state as LevelSpace;
			
			if (levelSpace){
				levelSpace.setSystemData();
			}
		}
		
		protected function onRankingUpdated():void
		{
			var levelSpace:LevelSpace = state as LevelSpace;
			
			if (levelSpace){
				if (levelSpace.popupRanking && levelSpace.contains(levelSpace.popupRanking))
					levelSpace.setRankingPopupData();
			}
		}
	}
}
package 
{
	import citrus.core.CitrusEngine;
	import citrus.core.IState;
	import citrus.utils.LevelManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import space_digger.popups.PopupGeneric;
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
		public static const DEBUG:Boolean = CONFIG::debug;
		
		public static var currentLevelIndex:int;
		public static var loadingClip:LoadingIcon;
		private var _genericPopup:PopupGeneric;
		
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
					[LevelDig, "../swf/levels/Level6.swf"],
					[LevelDig, "../swf/levels/Level7.swf"],
					[LevelDig, "../swf/levels/Level8.swf"],
					[LevelDig, "../swf/levels/Level9.swf"],
					[LevelDig, "../swf/levels/Level10.swf"],
					[LevelDig, "../swf/levels/Level11.swf"],
					[LevelDig, "../swf/levels/Level12.swf"],
					[LevelDig, "../swf/levels/Level13.swf"],
					[LevelDig, "../swf/levels/Level14.swf"],
					[LevelDig, "../swf/levels/Level15.swf"],
					[LevelDig, "../swf/levels/Level16.swf"],
					[LevelDig, "../swf/levels/Level17.swf"],
					[LevelDig, "../swf/levels/Level18.swf"],
					[LevelDig, "../swf/levels/Level19.swf"],
					[LevelDig, "../swf/levels/Level20.swf"],
					[LevelDig, "../swf/levels/Level21.swf"],
					[LevelDig, "../swf/levels/Level22.swf"],
					[LevelDig, "../swf/levels/Level23.swf"],
					[LevelDig, "../swf/levels/Level24.swf"],
					[LevelDig, "../swf/levels/Level25.swf"],
					
					[LevelDigOffline, "../swf/levels/Level1.swf"],
					[LevelDigOffline, "../swf/levels/Level2.swf"],
					[LevelDigOffline, "../swf/levels/Level3.swf"],
					[LevelDigOffline, "../swf/levels/Level4.swf"],
					[LevelDigOffline, "../swf/levels/Level5.swf"],
					[LevelDigOffline, "../swf/levels/Level6.swf"],
					[LevelDigOffline, "../swf/levels/Level7.swf"],
					[LevelDigOffline, "../swf/levels/Level8.swf"],
					[LevelDigOffline, "../swf/levels/Level9.swf"],
					[LevelDigOffline, "../swf/levels/Level10.swf"],
					[LevelDigOffline, "../swf/levels/Level11.swf"],
					[LevelDigOffline, "../swf/levels/Level12.swf"],
					[LevelDigOffline, "../swf/levels/Level13.swf"],
					[LevelDigOffline, "../swf/levels/Level14.swf"],
					[LevelDigOffline, "../swf/levels/Level15.swf"],
					[LevelDigOffline, "../swf/levels/Level16.swf"],
					[LevelDigOffline, "../swf/levels/Level17.swf"],
					[LevelDigOffline, "../swf/levels/Level18.swf"],
					[LevelDigOffline, "../swf/levels/Level19.swf"],
					[LevelDigOffline, "../swf/levels/Level20.swf"],
					[LevelDigOffline, "../swf/levels/Level21.swf"],
					[LevelDigOffline, "../swf/levels/Level22.swf"],
					[LevelDigOffline, "../swf/levels/Level23.swf"],
					[LevelDigOffline, "../swf/levels/Level24.swf"],
					[LevelDigOffline, "../swf/levels/Level25.swf"],
				];
		
			//if (Main.DEBUG)
			//	addChild(new Stats());

			GameManager.getInstance().needsRegistration.add(goToLevelRegister);
			GameManager.getInstance().ready.add(goToLevelSpace);
			GameManager.getInstance().loggedOut.add(goToLevelRegister);
			GameManager.getInstance().startFailed.add(goToLevelRegister);
			GameManager.getInstance().changeLevelRequest.add(travelToMine);
			GameManager.getInstance().changeOfflineRequest.add(travelToOfflineMine);
			GameManager.getInstance().start();
			
			GameManager.getInstance().stateUpdated.add(onStateUpdated);
			GameManager.getInstance().systemUpdated.add(onSystemUpdated);
			GameManager.getInstance().systemChanged.add(onSystemChanged);
			GameManager.getInstance().rankingUpdated.add(onRankingUpdated);
			
			GameManager.getInstance().displayPopup.add(openGenericPopup);
			
			GameManager.getInstance().enableView.add(enableLevel);
			GameManager.getInstance().disableView.add(disableLevel);
			
			loadingClip = new LoadingIcon();
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
			level.restartLevel.add(restartLevel);*/
			level.changeLevel.add(changeLevel);
			
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
		
		protected var offlineLevel:int = 1;
		
		private function travelToOfflineMine():void
		{
			var numberOfLevels:int = 25;
			var randomLevel:int = Math.ceil(Math.random()*numberOfLevels);
			
			// Uncomment to get ordered offline levels
			//randomLevel = offlineLevel;
			//offlineLevel = offlineLevel + 1 > 25 ? 1 : offlineLevel + 1;
			//trace("current offline level",offlineLevel);
			
			changeLevel(numberOfLevels + 2 + randomLevel);
		}
		
		private function restartLevel():void
		{
			state = levelManager.currentLevel as IState;
		}
		
		public function changeLevel(levelIndex:int):void
		{
			if (levelIndex != currentLevelIndex)
			{
				levelManager.gotoLevel(levelIndex);
				currentLevelIndex = levelIndex;
			}
		}
		
		protected function onStateUpdated():void
		{
			var levelSpace:LevelSpace = state as LevelSpace;
			
			if (levelSpace){
				levelSpace.setCompanyData();
				
				if(levelSpace.ongoingOpsScroller)
					levelSpace.setOngoingOperations();
				
				if(levelSpace.recentActivityScroller)
					levelSpace.setRecentActivity();
					
				if (levelSpace.popupPlanet)
					levelSpace.setPlanetPopupData(levelSpace.popupPlanet.planetIndex);
			}
		}
		
		protected function onSystemUpdated():void
		{
			var levelSpace:LevelSpace = state as LevelSpace;
			
			if (levelSpace){
				levelSpace.setSystemData(false);
				
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
		
		protected function openGenericPopup(message:String, buttonLabel:String, closeCallback:Function):void
		{
			_genericPopup = new PopupGeneric(message, buttonLabel, closeCallback);
			addChild(_genericPopup);
			
			_genericPopup.x = (stage.stageWidth - _genericPopup.width) * 0.5;
			_genericPopup.y = (stage.stageHeight - _genericPopup.height) * 0.5;
			
			_genericPopup.closePopup.add(closeGenericPopup);
		}
		
		protected function closeGenericPopup():void
		{
			if(_genericPopup.closeCallback != null) _genericPopup.closeCallback();
			_genericPopup.dispose();
			
			removeChild(_genericPopup);
		}
		
		protected function enableLevel():void
		{
			if (state is GameLevel)
				(state as GameLevel).enableInput();
			
			if(stage.contains(loadingClip))
				stage.removeChild(loadingClip);
				
			
		}
		
		protected function disableLevel():void
		{
			if (state is GameLevel)
				(state as GameLevel).disableInput();
				
			var clipWidth:Number = loadingClip.width;
			var clipHeight:Number = loadingClip.height;
			
			loadingClip.x =  width - clipWidth*0.5 - 25;
			loadingClip.y = clipHeight * 0.5 + 25;
			
			stage.addChildAt(loadingClip, stage.numChildren);
		}
	}
}
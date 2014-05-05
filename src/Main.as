package 
{
	import citrus.core.CitrusEngine;
	import citrus.core.IState;
	import citrus.utils.LevelManager;
	import data.Mine;
	import data.Planet;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.utils.Timer;
	import managers.*;
	import space_digger.debug.ErrorController;
	import space_digger.levels.LevelDig;
	import space_digger.levels.LevelDigOffline;
	import space_digger.levels.LevelRegister;
	import space_digger.levels.Levels;
	import space_digger.levels.LevelSpace;
	import space_digger.popups.PopupGeneric;
	import space_digger.popups.PopupTutorial;
	import utils.Stats;
	
	
	
	
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class Main extends CitrusEngine
	{
		public static const DEBUG:Boolean = CONFIG::debug;
		public static const SPLASH_SCREEN_DURATION_IN_SECS:Number = 1;
		
		public static var currentLevelIndex:int;
		public static var loadingClip:LoadingIcon;
		private var _genericPopup:PopupGeneric;
		private var _tutorialPopup:PopupTutorial;
		private var _popupModalBg:Sprite;
		private var _splashScreen:AssetSplashScreen;
		private var _splashScreenTimer:Timer;
		
		//keeps track of the uncaughtErrors
		private var _errorController:ErrorController;

		public function Main():void 
		{
			if (stage)
				init();
			else 
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		override protected function handleStageActivated(e:Event):void 
		{
			
		}
		override protected function handleStageDeactivated(e:Event):void 
		{
			
		}
		
		private function init(e:Event = null):void
		{
			_errorController = new ErrorController();
			
			loaderInfo.uncaughtErrorEvents.addEventListener(
				UncaughtErrorEvent.UNCAUGHT_ERROR, 
				_errorController.uncaughtError
			);
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			levelManager = new LevelManager(SDState);
			levelManager.onLevelChanged.add(onLevelChanged);
			levelManager.levels = 
				[
					[LevelRegister, "../swf/levels/LevelRegister.swf"],
					[LevelSpace, "../swf/levels/LevelSpace.swf"]
				];
			
			var i:int;
			for (i = 0; i < Levels.nMaps; ++i)
				levelManager.levels.push([LevelDig, Levels.tiledMap(i)]);
			for (i = 0; i < Levels.nMaps; ++i)
				levelManager.levels.push([LevelDigOffline, Levels.tiledMap(i)]);
			
			if (Main.DEBUG)
				addChild(new Stats());

			GameManager.getInstance().needsRegistration.add(goToLevelRegister);
			GameManager.getInstance().ready.add(goToLevelSpace);
			GameManager.getInstance().loggedOut.add(goToLevelRegister);
			GameManager.getInstance().startFailed.add(goToLevelRegister);
			GameManager.getInstance().changeLevelRequest.add(travelToMine);
			GameManager.getInstance().changeOfflineRequest.add(travelToOfflineMine);
			
			GameManager.getInstance().stateUpdated.add(onStateUpdated);
			GameManager.getInstance().systemUpdated.add(onSystemUpdated);
			GameManager.getInstance().systemChanged.add(onSystemChanged);
			GameManager.getInstance().rankingUpdated.add(onRankingUpdated);
			
			GameManager.getInstance().displayPopup.add(openGenericPopup);
			GameManager.getInstance().displayTutorialPopup.add(openTutorialPopup);
			
			GameManager.getInstance().enableView.add(enableLevel);
			GameManager.getInstance().disableView.add(disableLevel);
			
			loadingClip = new LoadingIcon();
			
			_splashScreen = new AssetSplashScreen();
			addChild(_splashScreen);

			SoundManager.getInstance().init();
			onStartGame();
			
			//_splashScreenTimer = new Timer(SPLASH_SCREEN_DURATION_IN_SECS * 1000, 1);
			//_splashScreenTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onStartGame, false, 0, true);
			//_splashScreenTimer.start();
			
			_popupModalBg = new Sprite();
			_popupModalBg.graphics.beginFill(0x000000, 0.85);
			_popupModalBg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_popupModalBg.graphics.endFill();
			
			enableLoading();
		}
		
		private function onStartGame(e:TimerEvent = null):void
		{
			if (e) _splashScreenTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onStartGame);
			
			GameManager.getInstance().start();
		}
		
		private function goToLevelRegister():void
		{
			changeLevel(1);
		}
		
		private function goToLevelSpace():void
		{
			changeLevel(2);
		}
		
		private function onLevelChanged(level:SDState):void
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
		
		protected function travelToMine(planet:Planet, mine:Mine):void
		{
			enableLoading();
			
			DataManager.getInstance().currentPlanet = planet;
			DataManager.getInstance().currentMine = mine;
			
			changeLevel(GameManager.getInstance().getClientMapIndexFromServerMapId(mine.map));
		}
		
		protected var offlineLevel:int = 21;
		
		private function travelToOfflineMine():void
		{
			var numberOfLevels:int = Levels.nMaps;
			var randomLevel:int = Math.ceil(Math.random()*numberOfLevels);
			
			// Uncomment to get ordered offline levels
			randomLevel = offlineLevel;
			offlineLevel = offlineLevel + 1 > numberOfLevels ? 1 : offlineLevel + 1;
			trace("current offline level",offlineLevel);
			
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
				
				if (contains(_splashScreen))
				{
					disableLoading();
					removeChild(_splashScreen);
				}
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
		
		protected function enableLevel():void
		{
			if (state is SDState)
				(state as SDState).enableInput();
			
			disableLoading();
		}
		
		protected function disableLevel():void
		{
			if (state is SDState)
				(state as SDState).disableInput();
			
			enableLoading();
		}
		
		protected function enableLoading():void
		{
			var clipWidth:Number = loadingClip.width;
			var clipHeight:Number = loadingClip.height;
			
			loadingClip.x =  width - clipWidth*0.5 - 25;
			loadingClip.y = clipHeight * 0.5 + 25;
			
			stage.addChildAt(loadingClip, stage.numChildren);
		}
		
		protected function disableLoading():void
		{
			if(stage.contains(loadingClip))
				stage.removeChild(loadingClip);
		}
		
		protected function openGenericPopup(message:String, 
											type:String,
											buttonAcceptLabel:String, 
											buttonCancelLabel:String, 
											acceptCallback:Function,
											cancelCallback:Function):void
		{
			_genericPopup = new PopupGeneric(message, type, buttonAcceptLabel, buttonCancelLabel, acceptCallback, cancelCallback);
			
			addChild(_popupModalBg);
			addChild(_genericPopup);
			
			_genericPopup.x = (stage.stageWidth - _genericPopup.width) * 0.5;
			_genericPopup.y = (stage.stageHeight - _genericPopup.height) * 0.5;
			
			_genericPopup.acceptPopup.add(acceptGenericPopup);
			_genericPopup.cancelPopup.add(cancelGenericPopup);
		}
		
		protected function acceptGenericPopup():void
		{
			if(_genericPopup.acceptCallback != null) _genericPopup.acceptCallback();
			closeGenericPopup();
		}
		
		protected function cancelGenericPopup():void
		{
			if(_genericPopup.cancelCallback != null) _genericPopup.cancelCallback();
			closeGenericPopup();
		}
		
		protected function closeGenericPopup():void
		{
			_genericPopup.dispose();
			
			removeChild(_popupModalBg);
			removeChild(_genericPopup);
		}
		
		public function openTutorialPopup(state:String):void
		{
			_tutorialPopup = new PopupTutorial(state);
			_tutorialPopup.closePopup.add(closeTutorialPopup);
			_tutorialPopup.x = (stage.stageWidth - _tutorialPopup.width) * 0.5;
			_tutorialPopup.y = (stage.stageHeight - _tutorialPopup.height) * 0.5;
			
			if (!contains(_tutorialPopup))
			{
				addChild(_popupModalBg);
				addChild(_tutorialPopup);
			}
		}
		
		public function closeTutorialPopup():void
		{
			if (contains(_tutorialPopup))
			{
				removeChild(_tutorialPopup);
				removeChild(_popupModalBg);
			}
		}
	}
}
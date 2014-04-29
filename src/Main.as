package 
{
	import citrus.core.CitrusEngine;
	import citrus.core.IState;
	import citrus.sounds.CitrusSoundGroup;
	import citrus.sounds.CitrusSoundInstance;
	import citrus.events.CitrusSoundEvent;
	import citrus.utils.LevelManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import space_digger.popups.PopupGeneric;
	import space_digger.popups.PopupTutorial;
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
		public static const SPLASH_SCREEN_DURATION_IN_SECS:Number = 1;
		
		public static var currentLevelIndex:int;
		public static var loadingClip:LoadingIcon;
		private var _genericPopup:PopupGeneric;
		private var _tutorialPopup:PopupTutorial;
		private var _tutorialPopupModal:Sprite;
		private var _splashScreen:AssetSplashScreen;
		private var _splashScreenTimer:Timer;
		
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

			//offset the sounds (less gap in the looping sound)
			CitrusSoundInstance.startPositionOffset = 80;

			//sound added with asset manager
			sound.addSound("BasementFloor", { sound:"../res/sounds/basement_floor.mp3" ,permanent:true, volume:0.4 , loops:int.MAX_VALUE , group:CitrusSoundGroup.BGM } );
			sound.addSound("Hypnothis", { sound:"../res/sounds/hypnothis.mp3" ,permanent:true, volume:0.4 , loops:int.MAX_VALUE , group:CitrusSoundGroup.BGM } );

			//sounds added with url
			sound.addSound("Aterrizaje", { sound:"../res/sounds/aterrizaje.mp3" , group:CitrusSoundGroup.SFX } );
			sound.addSound("BreakBlock", { sound:"../res/sounds/break_block.mp3" , group:CitrusSoundGroup.SFX } );
			sound.addSound("Death", { sound:"../res/sounds/death.mp3" , group:CitrusSoundGroup.SFX } );
			sound.addSound("Deploy", { sound:"../res/sounds/deploy.mp3" , group:CitrusSoundGroup.SFX } );
			sound.addSound("Despegue", { sound:"../res/sounds/despegue.mp3" , group:CitrusSoundGroup.SFX } );
			sound.addSound("DestroySeam", { sound:"../res/sounds/destroy_seam.mp3" , group:CitrusSoundGroup.SFX } );
			sound.addSound("GetHit", { sound:"../res/sounds/get_hit.mp3" , group:CitrusSoundGroup.SFX } );
			sound.addSound("HitEnemy", { sound:"../res/sounds/hit_enemy.mp3" , group:CitrusSoundGroup.SFX } );
			sound.addSound("JetPack", { sound:"../res/sounds/jetpack.mp3" , permanent:true, volume:0.2 , loops:int.MAX_VALUE , group:CitrusSoundGroup.SFX } );

			sound.getGroup(CitrusSoundGroup.SFX).addEventListener(CitrusSoundEvent.ALL_SOUNDS_LOADED, function(e:CitrusSoundEvent):void
			{
				e.currentTarget.removeEventListener(CitrusSoundEvent.ALL_SOUNDS_LOADED,arguments.callee);
				trace("SOUND EFFECTS ARE PRELOADED");

				//state = new AdvancedSoundsState();
				onStartGame();
			});

			sound.getGroup(CitrusSoundGroup.SFX).volume = 0.5;
			sound.getGroup(CitrusSoundGroup.SFX).preloadSounds();

			
			//_splashScreenTimer = new Timer(SPLASH_SCREEN_DURATION_IN_SECS * 1000, 1);
			//_splashScreenTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onStartGame, false, 0, true);
			//_splashScreenTimer.start();
			
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
			/*randomLevel = offlineLevel;
			offlineLevel = offlineLevel + 1 > 25 ? 1 : offlineLevel + 1;
			trace("current offline level",offlineLevel);*/
			
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
			
			disableLoading();
		}
		
		protected function disableLevel():void
		{
			if (state is GameLevel)
				(state as GameLevel).disableInput();
			
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
		
		public function openTutorialPopup(state:String):void
		{
			_tutorialPopup = new PopupTutorial(state);
			_tutorialPopup.closePopup.add(closeTutorialPopup);
			_tutorialPopup.x = (stage.stageWidth - _tutorialPopup.width) * 0.5;
			_tutorialPopup.y = (stage.stageHeight - _tutorialPopup.height) * 0.5;
			_tutorialPopupModal = new Sprite();
			_tutorialPopupModal.graphics.beginFill(0x000000, 0.85);
			_tutorialPopupModal.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_tutorialPopupModal.graphics.endFill();
			
			if (!contains(_tutorialPopup))
			{
				addChild(_tutorialPopupModal);
				addChild(_tutorialPopup);
			}
		}
		
		public function closeTutorialPopup():void
		{
			if (contains(_tutorialPopup))
			{
				removeChild(_tutorialPopup);
				removeChild(_tutorialPopupModal);
			}
		}
	}
}
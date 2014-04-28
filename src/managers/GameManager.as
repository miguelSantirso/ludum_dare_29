package managers 
{
	import data.DiggingSession;
	import data.Mine;
	import data.System;
	import org.osflash.signals.Signal;
	import utils.ServerTime;
	import com.greensock.TweenLite;
	
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class GameManager 
	{
		private static var instance:GameManager;
		private static var instantiated:Boolean = false;
		
		public var changeLevelRequest:Signal;
		public var changeOfflineRequest:Signal;
		
		public var ready:Signal;
		public var startFailed:Signal;
		public var needsRegistration:Signal;
		public var loggedOut:Signal;
		public var displayPopup:Signal;
		
		public var stateUpdated:Signal;
		public var systemUpdated:Signal;
		public var systemChanged:Signal;
		public var rankingUpdated:Signal;
		
		public function GameManager() 
		{
			if (instantiated) {
				instantiated = false;
				
				changeLevelRequest = new Signal();
				changeOfflineRequest = new Signal();
				
				ready = new Signal();
				startFailed = new Signal();
				needsRegistration = new Signal();
				loggedOut = new Signal();
				displayPopup = new Signal();
				
				stateUpdated = new Signal();
				systemUpdated = new Signal();
				systemChanged = new Signal();
				rankingUpdated = new Signal();
				
				RemoteManager.getInstance().authorizationFailed.add(reset);
			}else {
				throw new Error("Use getInstance()");
			}
		}
		
		public static function getInstance():GameManager
		{
			if (!instance) {
				instantiated = true;
				instance = new GameManager();
			}
			return instance;
		}
		
		public function start():void
		{
			RemoteManager.getInstance().getCore(
				DataManager.getInstance().core, 
				function():void{
					if (SessionManager.getInstance().alreadyRegistered) {
						updateState( 
							function():void { 
								RemoteManager.getInstance().getSystem(DataManager.getInstance().mySystem, setReady, startFailed.dispatch); 
							},
							startFailed.dispatch);
					}else {
						requestRegistration();
					}
				},
				startFailed.dispatch
			);	
		}
		
		protected function setReady():void
		{
			// We are ready to play
			ready.dispatch();
			
			// set timer to update state
			TweenLite.delayedCall(DataManager.getInstance().core.stateRefreshTime, updateState, [onStateUpdated, onStateUpdated]);
			
			// set timer to update system
			TweenLite.delayedCall(DataManager.getInstance().core.systemRefreshTime, updateSystem, [onSystemUpdated, onSystemUpdated]);
		}
		
		protected function onStateUpdated():void
		{
			stateUpdated.dispatch();
			
			TweenLite.delayedCall(DataManager.getInstance().core.stateRefreshTime, updateState, [onStateUpdated, onStateUpdated]);
		}
		
		protected function onSystemUpdated():void
		{
			systemUpdated.dispatch();
			
			TweenLite.delayedCall(DataManager.getInstance().core.systemRefreshTime, updateSystem, [onSystemUpdated, onSystemUpdated]);
		}
		
		protected function requestRegistration():void
		{
			needsRegistration.dispatch();
		}
		
		protected function reset():void
		{
			TweenLite.killDelayedCallsTo(updateState);
			TweenLite.killDelayedCallsTo(updateSystem);
			
			RemoteManager.getInstance().logout(onLoggedOut, onLoggedOut);	
		}
		
		protected function onLoggedOut():void
		{
			SessionManager.getInstance().clearRegistration();
			loggedOut.dispatch();
			
			DataManager.getInstance().reset();
			RemoteManager.getInstance().reset();
		}
		
		public function register(companyName:String, color1:uint, color2:uint):void
		{
			RemoteManager.getInstance().register(companyName, color1, color2, function(data:Object):void { SessionManager.getInstance().storeRegistration(data); start(); } );
		}
		
		public function logout():void
		{
			RemoteManager.getInstance().logout(onLoggedOut,onLoggedOut);
		}
		
		public function updateState(successCallback:Function = null, faultCallback:Function = null):void
		{
			RemoteManager.getInstance().getState(DataManager.getInstance().myState, successCallback, faultCallback);
		}
		
		public function updateSystem(successCallback:Function = null, faultCallback:Function = null):void
		{
			RemoteManager.getInstance().getSystem(DataManager.getInstance().mySystem, successCallback, faultCallback);
		}
		
		public function land(mine:Mine,successCallback:Function = null, faultCallback:Function = null):void
		{
			RemoteManager.getInstance().land(mine.id, mine,successCallback,faultCallback);
		}
		
		public function play(stopwatchCallback:Function, faultCallback:Function = null):void
		{
			RemoteManager.getInstance().play(stopwatchCallback,faultCallback);
		}
		
		public function takeOff(diggingSession:DiggingSession,successCallback:Function = null, faultCallback:Function = null):void
		{
			RemoteManager.getInstance().takeOff(diggingSession,successCallback,faultCallback);
		}
		
		public function jump():void
		{
			RemoteManager.getInstance().jump(DataManager.getInstance().mySystem, systemChanged.dispatch);
		}
		
		public function getRanking():void
		{
			RemoteManager.getInstance().ranking(
				function(data:Object):void {
					DataManager.getInstance().populateRanking(data);
					rankingUpdated.dispatch();
				}
			);
		}
		
		public function changeLevel(selectedMine:Mine):void
		{
			changeLevelRequest.dispatch(selectedMine);// getClientMapIndexFromServerMapId(selectedMine.map));
		}
		
		public function displayMessagePopUp(message:String, buttonLabel:String = "Close", closeCallback:Function = null):void
		{
			displayPopup.dispatch(message, buttonLabel, closeCallback);
		}
		
		public function getClientMapIndexFromServerMapId(serverMapId:int):int
		{
			return serverMapId + 2;
		}
		
		public function changeToOffline():void
		{
			changeOfflineRequest.dispatch();
		}
		
		public function testRemoteOperations():void
		{
			//RemoteManager.getInstance().logout();
			//RemoteManager.getInstance().register("Team " + (new Date()).time, 255, 255);
			//RemoteManager.getInstance().getSystem();
			//RemoteManager.getInstance().getCore();
		}
	}

}
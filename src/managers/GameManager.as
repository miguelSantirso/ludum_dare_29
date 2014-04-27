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
		
		public var ready:Signal;
		public var startFailed:Signal;
		public var needsRegistration:Signal;
		public var loggedOut:Signal;
		
		public var systemChanged:Signal;
		public var stateUpdated:Signal;
		public var rankingUpdated:Signal;
		
		public function GameManager() 
		{
			if (instantiated) {
				instantiated = false;
				
				ready = new Signal();
				startFailed = new Signal();
				needsRegistration = new Signal();
				loggedOut = new Signal();
				
				// TODO dispatch these
				systemChanged = new Signal();
				stateUpdated = new Signal();
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
						updateState( function():void { RemoteManager.getInstance().getSystem(setReady, startFailed.dispatch);} ,startFailed.dispatch);
					}else {
						requestRegistration();
					}
				}
			);	
		}
		
		protected function setReady():void
		{
			// set timer to update state
			TweenLite.delayedCall(DataManager.getInstance().core.stateRefreshTime, updateState,
				[	
					function():void {
						TweenLite.delayedCall(DataManager.getInstance().core.stateRefreshTime, updateState, [stateUpdated.dispatch]);
						stateUpdated.dispatch();
					}
				]
			); 
			
			ready.dispatch();
			// We are ready to play
		}
		
		protected function requestRegistration():void
		{
			needsRegistration.dispatch();
		}
		
		protected function reset():void
		{
			TweenLite.killDelayedCallsTo(updateState);
			
			RemoteManager.getInstance().logout(onLoggedOut, onLoggedOut);	
		}
		
		protected function onLoggedOut():void
		{
			SessionManager.getInstance().clearRegistration();
			loggedOut.dispatch();
			
			DataManager.getInstance().reset();
			RemoteManager.getInstance().reset();
			
			requestRegistration();
		}
		
		public function register(companyName:String, color1:uint, color2:uint):void
		{
			RemoteManager.getInstance().register(companyName, color1, color2, function(data:Object):void { SessionManager.getInstance().storeRegistration(data); start(); } );
		}
		
		public function logout():void
		{
			RemoteManager.getInstance().logout();
		}
		
		public function updateState(successCallback:Function = null, faultCallback:Function = null):void
		{
			RemoteManager.getInstance().getState(DataManager.getInstance().myState, successCallback, faultCallback);
		}
		
		public function land(mine:Mine):void
		{
			RemoteManager.getInstance().land(mine.id, mine); // TODO set the success callback to go to the Mine view 
		}
		
		public function play(stopwatchCallback:Function, faultCallback:Function = null):void
		{
			RemoteManager.getInstance().play(stopwatchCallback,faultCallback);
		}
		
		public function takeOff(diggingSession:DiggingSession):void
		{
			RemoteManager.getInstance().takeOff(diggingSession); // TODO set the success callback to go back to System view
		}
		
		public function jump(system:System):void // dispatchs the systemChange Signal
		{
			RemoteManager.getInstance().jump(system, systemChanged.dispatch);
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
		
		public function testRemoteOperations():void
		{
			//RemoteManager.getInstance().logout();
			//RemoteManager.getInstance().register("Team " + (new Date()).time, 255, 255);
			//RemoteManager.getInstance().getSystem();
			//RemoteManager.getInstance().getCore();
		}
	}

}
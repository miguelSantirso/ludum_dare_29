package managers 
{
	import org.osflash.signals.Signal;
	import utils.ServerTime;
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
		
		public function GameManager() 
		{
			if (instantiated) {
				instantiated = false;
				
				ready = new Signal();
				startFailed = new Signal();
				needsRegistration = new Signal();
				loggedOut = new Signal();
				
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
				function():void{
					if (SessionManager.getInstance().alreadyRegistered) {
						RemoteManager.getInstance().getState(
							function():void {
								RemoteManager.getInstance().getSystem(setReady, startFailed.dispatch);
							}
						,startFailed.dispatch);
					}else {
						requestRegistration();
					}
				});	
		}
		
		protected function setReady():void
		{
			ready.dispatch();
			// We are ready to play
		}
		
		protected function requestRegistration():void
		{
			needsRegistration.dispatch();
		}
		
		protected function reset():void
		{
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
		
		public function testRemoteOperations():void
		{
			//RemoteManager.getInstance().logout();
			//RemoteManager.getInstance().register("Team " + (new Date()).time, 255, 255);
			//RemoteManager.getInstance().getSystem();
			//RemoteManager.getInstance().getCore();
		}
	}

}
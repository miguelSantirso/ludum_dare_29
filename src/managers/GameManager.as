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
		public var needsRegistration:Signal;
		
		public function GameManager() 
		{
			if (instantiated) {
				instantiated = false;
				
				ready = new Signal();
				needsRegistration = new Signal();
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
						RemoteManager.getInstance().getSystem(setReady);
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
		
		public function getMyState():void 
		{	
			RemoteManager.getInstance().getState(
				function(data:Object):void{
					DataManager.getInstance().populateMyState(data);
					ServerTime.updateDeltaTime(data.time);
				});
		}
		
		public function testRemoteOperations():void
		{
			//RemoteManager.getInstance().logout();
			//RemoteManager.getInstance().register("Team " + (new Date()).time, 255, 255);
			getMyState();
			//RemoteManager.getInstance().getSystem();
			//RemoteManager.getInstance().getCore();
		}
	}

}
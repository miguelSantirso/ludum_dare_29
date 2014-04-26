package managers 
{
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class SessionManager 
	{
		private static var instance:SessionManager;
		private static var instantiated:Boolean = false;
		
		private var _registrationInfo:SharedObject;
		
		public function SessionManager() 
		{
			if (instantiated) {
				instantiated = false;
				
				_registrationInfo = SharedObject.getLocal("registration");
			}else {
				throw new Error("Use getInstance()");
			}
		}
		
		public static function getInstance():SessionManager
		{
			if (!instance) {
				instantiated = true;
				instance = new SessionManager();
			}
			return instance;
		}
		
		public function get alreadyRegistered():Boolean
		{
			_registrationInfo = SharedObject.getLocal("registration");
			
			return _registrationInfo && _registrationInfo.data.username != undefined && _registrationInfo.data.password != undefined;
		}
		
		public function get registrationInfo():SharedObject
		{
			return _registrationInfo;
		}
		
		public function storeRegistration(regObject:Object):void
		{
			_registrationInfo = SharedObject.getLocal("session");
			
			_registrationInfo.data.username = regObject.username;
			_registrationInfo.data.password = regObject.password;
			_registrationInfo.flush();
		}
		
		public function clearRegistration():void
		{
			_registrationInfo.clear();
			_registrationInfo.flush();
		}
	}

}
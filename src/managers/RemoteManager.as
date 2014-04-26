package managers 
{
	import infrastructure.RemoteOperation;
	import infrastructure.RemoteURL;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class RemoteManager 
	{
		public static const LOGIN:String = "login";
		public static const REGISTER:String = "registerOperation";
		public static const LOGOUT:String = "logout";
		public static const CORE:String = "coreOperation";
		public static const SYSTEM:String = "system";
		public static const LAND:String = "land";
		public static const TAKE_OFF:String = "takeoff";
		public static const PLANT:String = "plant";
		public static const STATE:String = "state";
		public static const LOG:String = "log";
		public static const RANKING:String = "ranking";
		
		private static var instance:RemoteManager;
		private static var instantiated:Boolean = false;
		
		protected static var _queuedOperations:Vector.<RemoteOperation> = new Vector.<RemoteOperation>();
		protected static var _currentRemoteOperation:RemoteOperation;
		
		public function RemoteManager() 
		{
			if (instantiated) {
				instantiated = false;
			}else {
				throw new Error("Use getInstance()");
			}
		}
		
		public static function getInstance():RemoteManager
		{
			if (!instance) {
				instantiated = true;
				instance = new RemoteManager();
			}
			return instance;
		}
		
		protected function sendOperation(
			tag:String, 
			url:String, 
			method:String = "POST", 
			object:Object = null, 
			populateStructures:Array = null,
			successCallback:Function = null,
			faultCallback:Function = null,
			highPriority:Boolean = false):void
		{
			var remoteOperation:RemoteOperation = new RemoteOperation(tag, url, method, object, populateStructures, successCallback, faultCallback);
													
			queueOperation(remoteOperation, highPriority);
			
			if (!_currentRemoteOperation)
				sendNextOperation();
		}
		
		protected function sendRemoteOperation(operation:RemoteOperation):void
		{
			_currentRemoteOperation = operation;
			
			operation.successSignal.add(onRemoteOperationSuccess);
			operation.faultSignal.add(onRemoteOperationFault);
			
			operation.send();
		}
		
		protected function queueOperation(operation:RemoteOperation, inFront:Boolean = true):void
		{
			if (inFront)
				_queuedOperations.unshift(operation);
			else
				_queuedOperations.push(operation);
		}
		
		protected function sendNextOperation():void
		{
			if (_queuedOperations.length > 0 && !_currentRemoteOperation)
				sendRemoteOperation(_queuedOperations.shift());
		}
		
		protected function onRemoteOperationSuccess(operation:RemoteOperation):void
		{
			_currentRemoteOperation.successSignal.remove(onRemoteOperationSuccess);
			_currentRemoteOperation.faultSignal.remove(onRemoteOperationFault);
			
			_currentRemoteOperation.dispose();
			_currentRemoteOperation = null;
			
			sendNextOperation();
		}
		
		protected function onRemoteOperationFault(operation:RemoteOperation):void
		{
			_currentRemoteOperation.successSignal.remove(onRemoteOperationSuccess);
			_currentRemoteOperation.faultSignal.remove(onRemoteOperationFault);
			
			switch(operation.httpStatusCode) {
				case RemoteOperation.STATUS_UNAUTHORIZED : // not logged
					queueOperation(_currentRemoteOperation, true);
					login();
					break;
				case RemoteOperation.STATUS_INVALID :
					_currentRemoteOperation.dispose();
					_currentRemoteOperation = null;
					// show popup with error
					trace(operation.errorMessage);
					break;
				case RemoteOperation.STATUS_BAD_URL :
					_currentRemoteOperation.dispose();
					_currentRemoteOperation = null;
					// show popup with don't hack my shit
					break;
				case RemoteOperation.STATUS_SERVER_ERROR :
					_currentRemoteOperation.dispose();
					_currentRemoteOperation = null;
					// show popup with server is down
					break;
				default:
					_currentRemoteOperation.dispose();
					_currentRemoteOperation = null;
			
					break;
			}
			
			// TODO fail mechanism
			sendNextOperation();
		}
		
		public function login(successCallback:Function = null, faultCallback:Function = null):void
		{
			var requestObject:Object = { username: SessionManager.getInstance().registrationInfo.data.username,
										password: SessionManager.getInstance().registrationInfo.data.password};
			
			sendOperation(LOGIN, RemoteURL.LOGIN, RemoteOperation.TYPE_POST, requestObject, null, successCallback, faultCallback, true);
		}
		
		public function register(companyName:String, color1:uint, color2:uint, succesCallback:Function = null, faultCallback:Function = null):void
		{
			var requestObject:Object = { name: companyName, color1: color1, color2: color2 };
			
			sendOperation(REGISTER, RemoteURL.REGISTER, RemoteOperation.TYPE_POST, requestObject, null, succesCallback, faultCallback);
		}
		
		public function logout(successCallback:Function = null, faultCallback:Function = null):void
		{
			sendOperation(LOGOUT,RemoteURL.LOGOUT,RemoteOperation.TYPE_POST,null,null,successCallback,faultCallback);
		}
		
		public function getCore(successCallback:Function = null, faultCallback:Function = null ):void
		{
			sendOperation(CORE, RemoteURL.CORE, RemoteOperation.TYPE_POST, null,null,successCallback,faultCallback);
		}
		
		public function getState(successCallback:Function = null, faultCallback:Function = null ):void
		{
			sendOperation(STATE, RemoteURL.STATE, RemoteOperation.TYPE_POST, null,null,successCallback,faultCallback);
		}
		
		public function getSystem(successCallback:Function = null, faultCallback:Function = null):void
		{
			sendOperation(SYSTEM, RemoteURL.SYSTEM, RemoteOperation.TYPE_POST, null, null, successCallback,faultCallback);
		}
	}

}
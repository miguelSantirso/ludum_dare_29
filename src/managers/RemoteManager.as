package managers 
{
	import data.DiggingSession;
	import data.Mine;
	import infrastructure.RemoteOperation;
	import infrastructure.RemoteURL;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class RemoteManager 
	{
		public static const LOGIN:String = "loginOperation";
		public static const REGISTER:String = "registerOperation";
		public static const LOGOUT:String = "logoutOperation";
		public static const CORE:String = "coreOperation";
		public static const SYSTEM:String = "systemOperation";
		public static const LAND:String = "landOperation";
		public static const PLAY:String = "playOperation";
		public static const TAKE_OFF:String = "takeoffOperation";
		public static const STATE:String = "stateOperation";
		public static const RANKING:String = "rankingOperation";
		public static const JUMP:String = "jumpOperation";
		
		private static var instance:RemoteManager;
		private static var instantiated:Boolean = false;
		
		protected var _queuedOperations:Vector.<RemoteOperation> = new Vector.<RemoteOperation>();
		protected var _currentRemoteOperation:RemoteOperation;
		
		public var authorizationFailed:Signal;
		
		public function RemoteManager() 
		{
			if (instantiated) {
				instantiated = false;
				
				authorizationFailed = new Signal();
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
		
		public function reset():void
		{
			for each(var op:RemoteOperation in _queuedOperations)
				op.dispose();
				
			_queuedOperations.splice(0, _queuedOperations.length);
			
			if (_currentRemoteOperation) _currentRemoteOperation.dispose();
			_currentRemoteOperation = null;
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
			
			if (operation.tag == LOGIN) {
				// this dispatches a signal for game manager to delete all operations
				_currentRemoteOperation = null;
				onLoginFault();
				return;
			}
			
			switch(operation.httpStatusCode) {
				case RemoteOperation.STATUS_UNAUTHORIZED : // not logged					
					if (operation.tag == LOGOUT && operation.tag != REGISTER) {
						queueOperation(_currentRemoteOperation, true);
						_currentRemoteOperation = null;
						login();
					}else {
						_currentRemoteOperation = null;
					}
					
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
			sendOperation(CORE, RemoteURL.CORE, RemoteOperation.TYPE_POST, null,[DataManager.getInstance().core],successCallback,faultCallback);
		}
		
		public function getState(successCallback:Function = null, faultCallback:Function = null ):void
		{
			sendOperation(STATE, RemoteURL.STATE, RemoteOperation.TYPE_POST, null,[DataManager.getInstance().myState],successCallback,faultCallback);
		}
		
		public function getSystem(successCallback:Function = null, faultCallback:Function = null):void
		{
			sendOperation(SYSTEM, RemoteURL.SYSTEM, RemoteOperation.TYPE_POST, null, [DataManager.getInstance().mySystem], successCallback,faultCallback);
		}
		
		// TODO chdck these operations
		public function land(mineId:int, mine:Mine,successCallback:Function = null, faultCallback:Function = null):void
		{
			var requestObject:Object = { mine_id: mineId };
			
			sendOperation(LAND, RemoteURL.LAND, RemoteOperation.TYPE_POST, requestObject, [mine], successCallback, faultCallback);
		}
		
		public function play(successCallback:Function = null, faultCallback:Function = null):void
		{
			sendOperation(LAND, RemoteURL.LAND, RemoteOperation.TYPE_POST, null, null, successCallback, faultCallback);
		}
		
		public function takeOff(diggingSession:DiggingSession, successCallback:Function = null, faultCallback:Function = null):void
		{
			var requestObject:Object = { "seams_activated": diggingSession.activatedSeams, "takeoff": true };
			
			if (diggingSession.death){
				requestObject["death"] = true;
				requestObject["x"] = diggingSession.death.x;
				requestObject["y"] = diggingSession.death.y;
			}
			
			sendOperation(TAKE_OFF, RemoteURL.TAKE_OFF, RemoteOperation.TYPE_POST, requestObject, null, successCallback, faultCallback);
		}
		
		protected function onLoginFault():void
		{
			authorizationFailed.dispatch();
		}
	}

}
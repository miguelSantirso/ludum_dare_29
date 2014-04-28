package managers 
{
	import data.CompanyState;
	import data.Core;
	import data.DiggingSession;
	import data.Mine;
	import data.System;
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
		}
		
		protected function sendOperation(
			tag:String, 
			url:String, 
			method:String = "POST", 
			object:Object = null, 
			populateStructures:Array = null,
			successCallback:Function = null,
			faultCallback:Function = null,
			disablesView:Boolean = false,
			highPriority:Boolean = false,
			earlySuccessDispatch:Boolean = false):void
		{
			var remoteOperation:RemoteOperation = 
				new RemoteOperation(tag, url, method, object, populateStructures, successCallback, faultCallback, disablesView,earlySuccessDispatch);
													
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
		
			if (operation.disablesView)
				GameManager.getInstance().disableInterface();
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
			if (operation.disablesView)
				GameManager.getInstance().enableInterface();
				
			_currentRemoteOperation.successSignal.remove(onRemoteOperationSuccess);
			_currentRemoteOperation.faultSignal.remove(onRemoteOperationFault);
			
			_currentRemoteOperation.dispose();
			_currentRemoteOperation = null;
			
			sendNextOperation();
		}
		
		protected function onRemoteOperationFault(operation:RemoteOperation):void
		{
			if (operation.disablesView)
				GameManager.getInstance().enableInterface();
				
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
					// show popup with error
					if(operation.errorMessage)
						GameManager.getInstance().displayMessagePopUp(operation.errorMessage);
					
					_currentRemoteOperation.dispose();
					_currentRemoteOperation = null;
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
					
					GameManager.getInstance().displayMessagePopUp(operation.errorMessage);
					break;
				default:
					GameManager.getInstance().displayMessagePopUp("You seem to lack internet connection at the moment. You can play an Offline Training mission in the meantime");
					
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
			
			sendOperation(LOGIN, RemoteURL.LOGIN, RemoteOperation.TYPE_POST, requestObject, null, successCallback, faultCallback, true, true);
		}
		
		public function register(companyName:String, color1:uint, color2:uint, succesCallback:Function = null, faultCallback:Function = null):void
		{
			var requestObject:Object = { name: companyName, color1: color1, color2: color2 };
			
			sendOperation(REGISTER, RemoteURL.REGISTER, RemoteOperation.TYPE_POST, requestObject, null, succesCallback, faultCallback,true);
		}
		
		public function logout(successCallback:Function = null, faultCallback:Function = null):void
		{
			sendOperation(LOGOUT,RemoteURL.LOGOUT,RemoteOperation.TYPE_POST,null,null,successCallback,faultCallback,true,true);
		}
		
		public function getCore(core:Core, successCallback:Function = null, faultCallback:Function = null ):void
		{
			sendOperation(CORE, RemoteURL.CORE, RemoteOperation.TYPE_POST, null,[core],successCallback,faultCallback,true);
		}
		
		public function getState(state:CompanyState, successCallback:Function = null, faultCallback:Function = null ):void
		{
			sendOperation(STATE, RemoteURL.STATE, RemoteOperation.TYPE_POST, null,[state],successCallback,faultCallback,false);
		}
		
		public function getSystem(system:System, successCallback:Function = null, faultCallback:Function = null, disableView:Boolean = false):void
		{
			sendOperation(SYSTEM, RemoteURL.SYSTEM, RemoteOperation.TYPE_POST, null, [system], successCallback,faultCallback,disableView);
		}
		
		public function land(mineId:int, mine:Mine,successCallback:Function = null, faultCallback:Function = null):void
		{
			var requestObject:Object = { mine: mineId };
			
			sendOperation(LAND, RemoteURL.LAND, RemoteOperation.TYPE_POST, requestObject, [mine], successCallback, faultCallback,true);
		}
		
		public function play(successCallback:Function = null, faultCallback:Function = null):void
		{
			sendOperation(PLAY, RemoteURL.PLAY, RemoteOperation.TYPE_POST, null, null, successCallback, faultCallback,true);
		}
		
		public function takeOff(diggingSession:DiggingSession, successCallback:Function = null, faultCallback:Function = null):void
		{
			var requestObject:Object = { "takeoff": true };
			
			if (diggingSession.activatedSeams.length > 0) {
				requestObject["seams_activated"] = diggingSession.activatedSeams;
			}
			
			if (diggingSession.death){
				requestObject["death"] = true;
				requestObject["x"] = diggingSession.death.x;
				requestObject["y"] = diggingSession.death.y;
			}
			
			sendOperation(TAKE_OFF, RemoteURL.TAKE_OFF, RemoteOperation.TYPE_POST, requestObject, null, successCallback, faultCallback,true);
		}
		
		public function jump(system:System, planetId:int = 0, successCallback:Function = null, faultCallback:Function = null):void
		{
			var requestObject:Object = { jump: true };
										
			if (planetId > 0)
				requestObject["planet"] = planetId;
			
			sendOperation(JUMP, RemoteURL.JUMP, RemoteOperation.TYPE_POST, requestObject, [system], successCallback, faultCallback,true);
		}
		
		public function ranking(rankingFillerCallback:Function, faultCallback:Function = null):void
		{
			sendOperation(RANKING, RemoteURL.RANKING, RemoteOperation.TYPE_POST, null, null, rankingFillerCallback, faultCallback,false);
		}
		
		protected function onLoginFault():void
		{
			authorizationFailed.dispatch();
		}
	}

}
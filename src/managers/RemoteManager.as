package managers 
{
	import infrastructure.RemoteOperation;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class RemoteManager 
	{
		public static const SETTINGS:String = "settingsOperation";
		
		private static var instance:DataManager;
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
		
		public static function sendOperation(
			tag:String, 
			url:String, 
			method:String = "POST", 
			object:Object, 
			populateStructures:Array = null,
			populateCallback:Function = null,
			successCallback:Function = null,
			faultCallback:Function = null,
			errorCallback:Function = null):void
		{
			var removeOperation:RemoteOperation = new RemoteOperation(tag, url, method, object,
													populateStructures, populateStructures, 
													successCallback, faultCallback, errorCallback);
													
			queueOperation();
			
			if (!_currentRemoteOperation)
				sendNextOperation();
		}
		
		protected static function sendRemoteOperation(operation:RemoteOperation):void
		{
			_currentRemoteOperation = operation;
			
			operation.successSignal.add(onRemoteOperationSuccess);
			operation.successSignal.add(onRemoteOperationFault);
			
			operation.send();
		}
		
		protected static function queueOperation(operation:RemoteOperation):void
		{
			_queuedOperations.push(operation);
		}
		
		protected static function sendNextOperation():void
		{
			if (_queuedOperations.length > 0 && !_currentRemoteOperation)
				sendRemoteOperation(_queuedOperations.shift());
		}
		
		public static function getSettings():void
		{
			sendRemoteOperation();
		}
		
		protected static function onRemoteOperationSuccess():void
		{
			
		}
		
		protected static function onRemoteOperationFault():void
		{
			
		}
	}

}
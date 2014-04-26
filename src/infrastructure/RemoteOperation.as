package infrastructure
{
	import flash.net.URLLoader;
	import org.osflash.signals.Signal;
	
	public class RemoteOperation extends EventDispatcher
	{
		public static var LOCAL:Boolean = true;
		
		public static const localURL:String = "views/";
		public static const serverURL:String = "102.168.99.133/space/";
		
		protected var _tag:String;
		protected var _url:String;
		protected var _loader:URLLoader;
		protected var _requestObject:Object;
		protected var _successCallback:Function;
		protected var _faultCallback:Function;
		protected var _errorCallback:Function;
		protected var _populateStructures:Array; // IPopulatable items
		protected var _populateCallback:Function;
		
		public var successSignal:Signal;
		public var faultSignal:Signal;
		
		public function RemoteOperation(tag:String,
										url:String, 
										method:String,
										object:Object = null, 
										populateStructures:Array = null,
										populateCallback:Function = null,
										successCallback:Function = null,
										faultCallback:Function = null,
										errorCallback:Function = null,
										disablesView:Boolean = true)
		{
			successSignal = new Signal();
			faultSignal = new Signal();
			
			if(object != null && method == "GET")
				trace("WARNING - ServerOperation with request object should use the POST method.");
			
			_loader = new URLLoader();	
			_loader.addEventListener(Event.COMPLETE, onSuccessHandler, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onFaultHandler);

			if(!tag)
				_tag = "anonymous";
			else
				_tag = tag;
			
			_url = url;
			
			// TODO MIGRATION
			_service.url = !LOCAL ? serverURL : localURL;
			
			_service.method = method;
			_populateStructures = populateStructures;
			_populateCallback = populateCallback;
			_successCallback = successCallback;
			_faultCallback = faultCallback;
			_errorCallback = errorCallback;
			_requestObject = object;
		}
		
		public function send():void
		{
			_service.send(_requestObject);
		}
		
		public function cancel():void
		{
			//if(_service)
			//	_service.cancel();
			
			_successCallback = null;
			_faultCallback = null;
			_errorCallback = null;
		}
		
		public function dispose():void
		{
			_tag = null;
			_url = null;
			_service.removeEventListener(ResultEvent.RESULT, onSuccessHandler);
			_service.removeEventListener(FaultEvent.FAULT, onFaultHandler);
			_service.clearResult();
			_service.disconnect();
			_service = null;	
			_successCallback = null;
			_faultCallback = null;
			_errorCallback = null;
			_populateStructures = null;
			_populateCallback = null;
		}
		
		private function onSuccessHandler(event:ResultEvent):void
		{
			
			/*var xmlList:XMLList = XML(event.result).view;
			var xmlListColl:XMLListCollection = new XMLListCollection(xmlList);
			var text:String = xmlListColl.getItemAt(0).match;*/
			
			var serverData:Object = event.result;
			
			if(!dataIsWellFormed(serverData))
			{
				onMalformedData(event);
				return;
			}
			
			if(isLogin(serverData))
			{
				consoleShow(" OPERATION_LOGIN");
				// Login handling
				dispatchEvent(new ServerOperationEvent(ServerOperationEvent.OPERATION_LOGIN));
				return;
			}
			
			//the server cannot perform the action.
			if(isError(serverData))
			{
				var errorEvent:ServerOperationEvent = new ServerOperationEvent(ServerOperationEvent.OPERATION_ERROR);
				var code:String = errorCode(serverData);
				
				consoleShow(" OPERATION_ERROR "+code);
				
				// Error handling
				if(_errorCallback != null){
					if(_errorCallback.length > 0)
						_errorCallback(_requestObject);
					else
						_errorCallback();
				}
				
				if(LanguageManager.get().getErrorObject(_url,code) != null)
					code = _url+"_"+code;
				
				errorEvent.errorCode = code;						
				dispatchEvent(errorEvent);
			}
			
			
			//onData well constructed
			consoleShow(" OPERATION_SUCCESS ");
		
			if(_populateStructures != null)
			{
				for each (var str:IPopulatable in _populateStructures) 
				{
					if(str)
						str.populate(serverData["view"]);
				}
			}
			
			if(_populateCallback != null)
				_populateCallback(serverData["view"]);
			
			if(RemoteOperation.defaultPopulateCallback != null && serverData["view"])
				RemoteOperation.defaultPopulateCallback(serverData["view"]);
			
			if(_successCallback != null)
			{
				if(_successCallback.length > 0)
					_successCallback(_requestObject);
				else
					_successCallback();
			}
			
			dispatchEvent(new ServerOperationEvent(ServerOperationEvent.OPERATION_SUCCESS));
					
		}
		
		private function consoleShow(info:String):void
		{
			CONFIG::DEBUG
			{
				ClientManager.addConsoleMessage(_tag+" OPERATION_LOGIN");
			}
		}
		
		private function onFaultHandler(event:FaultEvent):void
		{
			// Fault handling
			/*if(!retryResponse())
				return;*/
			
			failedResponse();
			
			CONFIG::DEBUG
			{
				ClientManager.addConsoleMessage(_tag+" OPERATION_FAULT");
			}
			
			dispatchEvent(new ServerOperationEvent(ServerOperationEvent.OPERATION_FAULT));
		}
		
		
		/**
		 *  resend the request for certain times before complete fail.
		 */
	/*	private function retryResponse():Boolean
		{
			if(_resendStatus < RESEND_TIMES_FOR_FAIL)
			{
				_resendStatus++;
				send();
				return false;
			}
			
			failedResponse();
			return true;
		}*/
		
		/**
		 * 	Standard behaviour on failed response
		 * 
		 */
		private function failedResponse():void
		{
			
			if(_faultCallback != null){
				if(_faultCallback.length > 0)
					_faultCallback(_requestObject);
				else
					_faultCallback();
			}
			
		}
		
		private function dataIsWellFormed(data:Object):Boolean
		{
			return data.hasOwnProperty("view");
		}
		
		public static function isError(data:Object):Boolean
		{
			return data["view"]["name"] == "error";
		}
		
		private function errorCode(data:Object):String
		{
			return data["view"]["error"].code;
		}
		
		/* GETTERS */
		public function get tag():String
		{
			return _tag;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get method():String
		{
			return _service.method;
		}
		
		public function get populateStructures():Array
		{
			return _populateStructures;
		}
		
		public function get populateCallback():Function
		{
			return _populateCallback;
		}
		
		public function get successCallback():Function
		{
			return _successCallback;
		}
		
		public function get faultCallback():Function
		{
			return _faultCallback;
		}
		
		public function get errorCallback():Function
		{
			return _errorCallback;
		}
		
		public function get requestObject():Object
		{
			return _requestObject;
		}
	}
}
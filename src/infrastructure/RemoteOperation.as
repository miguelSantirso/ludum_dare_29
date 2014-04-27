package infrastructure
{
	import away3d.core.base.IRenderable;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import org.osflash.signals.Signal;
	import infrastructure.interfaces.IPopulatable;
	
	public class RemoteOperation extends EventDispatcher
	{
		public static const TYPE_GET:String = "get";
		public static const TYPE_POST:String = "post";
		public static const STATUS_SUCCESS:int = 200;
		public static const STATUS_INVALID:int = 400;
		public static const STATUS_UNAUTHORIZED:int = 401;
		public static const STATUS_BAD_URL:int = 404;
		public static const STATUS_SERVER_ERROR:int = 500;
		
		public static var LOCAL:Boolean = false;
		
		public static const LOCAL_URL:String = "views/";
		public static const SERVER_URL:String = 
			//"http://192.168.99.133/space/";
			"http://space.basedos.com/";
		
		protected var _tag:String;
		protected var _url:String;
		protected var _method:String
		protected var _loader:URLLoader;
		protected var _requestObject:Object;
		protected var _populateStructures:Array;
		protected var _successCallback:Function;
		protected var _faultCallback:Function;
		
		protected var _httpStatusCode:int;
		protected var _errorMessage:String;
		
		public var successSignal:Signal;
		public var faultSignal:Signal;
		
		public function RemoteOperation(tag:String,
										url:String, 
										method:String,
										object:Object = null, 
										populateStructures:Array = null,
										successCallback:Function = null,
										faultCallback:Function = null)
		{
			successSignal = new Signal();
			faultSignal = new Signal();
			
			_tag = tag;
			
			if(object != null && method == "GET")
				trace("WARNING - ServerOperation with request object should use the POST method.");
			
			_loader = new URLLoader();	
			_loader.addEventListener(Event.COMPLETE, onSuccessHandler, false, 0, true);
			_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onFaultHandler, false, 0, true);
			
			_url = url;
			_method = method;
			_populateStructures = populateStructures;
			_successCallback = successCallback;
			_faultCallback = faultCallback;
			_requestObject = object;
		}
		
		public function send():void
		{
			var request:URLRequest = new URLRequest((!LOCAL ? SERVER_URL : LOCAL_URL) + url + "/");
			request.method = _method;
			
			var variables:URLVariables = new URLVariables();
			
			if(_requestObject){
				for(var id:String in _requestObject) {
				  var value:Object = _requestObject[id];
				  variables[id] = value;
				  trace(id + " = " + value);
				}
				request.data = variables;
			}

			_loader.load(request);
		}
		
		public function cancel():void
		{
			_loader.close();
			
			_successCallback = null;
			_faultCallback = null;
		}
		
		public function dispose():void
		{
			successSignal.removeAll();
			successSignal = null;
			faultSignal.removeAll();
			faultSignal = null;
		
			_tag = null;
			_url = null;
			_method = null;
			_loader.removeEventListener(Event.COMPLETE, onSuccessHandler);
			_loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onFaultHandler);
			_loader.close();
			_loader = null;
			
			_successCallback = null;
			_faultCallback = null; 
			_populateStructures = null;
			
			_errorMessage = null;
		}
		
		private function onHttpStatus(event:HTTPStatusEvent):void
		{
			trace("HTTP status code", event.status);
			
			_httpStatusCode = event.status;
		}
		
		private function onSuccessHandler(event:Event):void
		{
			trace("OPERATION",_tag,"success");
			
			if (_httpStatusCode == STATUS_SUCCESS) {
				var jsonObject:Object;
				if (_loader.data && _loader.data != "") {
					try{
						jsonObject = JSON.parse(_loader.data as String);
						
						if(jsonObject){
							for(var id:String in jsonObject) {
							  var value:Object = jsonObject[id];
							  //trace(id + " = " + value);
							}
						}
					}catch (e:Error) {
						trace("JSON ", e.message);
					}
				}
				// populate the structures
				if(_populateStructures != null){
					for each (var structure:IPopulatable in _populateStructures) 
					{
						if(structure)
							structure.populate(jsonObject);
					}
				}
				// execute the callback
				if(_successCallback != null){
					if(jsonObject && _successCallback.length > 0)
						_successCallback(jsonObject);
					else
						_successCallback();
				}
			}
			successSignal.dispatch(this);		
		}
		
		private function onFaultHandler(event:IOErrorEvent):void
		{
			trace("OPERATION",_tag,"fault");
			
			if (_httpStatusCode == STATUS_INVALID) {
				trace("Invalid operation:", event.text);
				try{
					var errorObject:Object = JSON.parse(_loader.data as String);
					
					if(errorObject){
						for(var id:String in errorObject) {
						  var value:Object = errorObject[id];
						  
						  if(id == "error") 
							_errorMessage = value as String;
						}
					}
				}catch (e:Error) {
					trace("JSON ", e.message);
				}
			}else if (_httpStatusCode == STATUS_UNAUTHORIZED) {
				trace("Unauthorized:", event.text);
			}else if (_httpStatusCode == STATUS_BAD_URL) {
				trace("Bad URL:", event.text);
			}else if (_httpStatusCode == STATUS_SERVER_ERROR) {
				trace("Server failed: ", event.text);
			}
			
			if(_faultCallback != null)
				_faultCallback();
			
			faultSignal.dispatch(this);
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
		
		public function get populateStructures():Array
		{
			return _populateStructures;
		}
		
		public function get successCallback():Function
		{
			return _successCallback;
		}
		
		public function get faultCallback():Function
		{
			return _faultCallback;
		}
		
		public function get requestObject():Object
		{
			return _requestObject;
		}
		
		public function get httpStatusCode():int
		{
			return _httpStatusCode;
		}
		
		public function get errorMessage():String
		{
			return _errorMessage;
		}
	}
}
package space_digger.debug 
{
	import flash.events.ErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import managers.AnalyticsManager;
	
	/**
	 * This class manages the errors in the application.
	 * The errors are send to GA so we can track them.
	 */
	public class ErrorController
	{
		public function ErrorController():void
		{
		}
		
		public function uncaughtError(event:UncaughtErrorEvent):void
		{
			var errorInfo:String;
			
			if (event.error is Error)
			{
				var error:Error = event.error as Error;
				errorInfo = "Error: "+error.name+" "+error.getStackTrace();
			}
			else if (event.error is ErrorEvent)
			{
				var errorEvent:ErrorEvent = event.error as ErrorEvent;
				errorInfo = "Error event caught: "+errorEvent.text;
			}else
			{
				errorInfo = "Unknown Error: "+ event.error.toString();
			}
			
			AnalyticsManager.getInstance().triggerErrorEvent(errorInfo);
			
			event.preventDefault();
		}
	}
}

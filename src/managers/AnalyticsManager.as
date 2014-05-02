package managers 
{
	import com.gameanalytics.GALogEvent;
    import com.gameanalytics.GameAnalytics;
    import com.gameanalytics.constants.GAErrorSeverity;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AnalyticsManager 
	{
		private static const SECRET_KEY:String = "54ef2fae3e552e671df2e2103c48b3c82fb98bbb";
		private static const GAME_KEY:String = "d56ec6c81877d6426dade43ab5244b8f";
		private static const GAME_VERSION:String = "1.0.0";
		
		private static var instance:AnalyticsManager;
		private static var instantiated:Boolean = false;
		
		public function AnalyticsManager() 
		{
			if (instantiated) {
				instantiated = false;
			}else {
				throw new Error("Use getInstance()");
			}
		}
		
		public static function getInstance():AnalyticsManager
		{
			if (!instance) {
				instantiated = true;
				instance = new AnalyticsManager();
			}
			return instance;
		}
		
		public function init(userId:String, sessionId:String = null):void
		{
			GameAnalytics.init(SECRET_KEY, GAME_KEY, GAME_VERSION, sessionId, userId);
			GameAnalytics.DEBUG_MODE = true;
			GameAnalytics.getLogEvents(onLogEvent);
			//GameAnalytics.catchUnhandledExceptions(loaderInfo, true);
		}
		
		private function onLogEvent(e:GALogEvent):void
		{
			trace(e.text);
		}

		public function triggerErrorEvent(message:String, severity:String = GAErrorSeverity.ERROR, 
										  area:String = null, x:Number = NaN, y:Number = NaN, 
										  z:Number = NaN):void
		{
				GameAnalytics.newErrorEvent(message, severity, area, x, y, z);
		}
		
		public function triggerDesignEvent(eventId:String, value:Number, area:String = null,
										   x:Number = NaN, y:Number = NaN, z:Number = NaN):void
		{
			GameAnalytics.newDesignEvent(eventId, value, area, x, y, z);
		}
	}

}
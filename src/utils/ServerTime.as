package utils 
{
	import infrastructure.RemoteOperation;
	import utils.ServerTime
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class ServerTime 
	{
		public static var clientDeltaTime:Number;
		
		public function ServerTime() 
		{
			
		}
		
		public static function updateDeltaTime(serverTime:String):void
		{
			var clientTime:Date = new Date();
			
			var serverTimeInSeconds:Number = Number(serverTime);
			
			clientDeltaTime = s2ms(serverTimeInSeconds) - clientTime.time;
		}
			
		public static function getDateFromServerTime(serverDateSeconds:*):Date
		{
			var date:Date = new Date();
			var dateNumberSeconds:Number;  

			if(serverDateSeconds is Number)
				dateNumberSeconds = serverDateSeconds;
			else if(serverDateSeconds is String)
				dateNumberSeconds = Number(serverDateSeconds);
			else
				return null;
			
			// TEMP
			if(RemoteOperation.LOCAL)
				date.time = date.time + Math.round(10*60*1000*Math.random());
			else
				date.time = s2ms(dateNumberSeconds) - clientDeltaTime;
			
			return date;
		}
		
		protected static function s2ms(seconds:Number):Number
		{
			return seconds*1000;
		}
	}

}
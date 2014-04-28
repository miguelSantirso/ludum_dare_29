package space_digger 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class OngoingOpEvent extends Event
	{
		public static const VISIT_PLANET:String = "visitPlanet";
		
		private var _planetID:int;

		public function OngoingOpEvent(planetID:int, type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			
			_planetID = planetID;
		}	
		
		public function set planetID(value:int):void
		{
			_planetID = value;
		}
		
		public function get planetID():int
		{
			return _planetID;
		}
	}
}
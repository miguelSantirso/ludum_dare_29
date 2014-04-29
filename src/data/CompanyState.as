package data 
{
	import flash.events.Event;
	import infrastructure.interfaces.IPopulatable;
	import utils.ServerTime;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class CompanyState implements IPopulatable 
	{
		protected var _company:Company;
		protected var _workingSeams:Vector.<SeamData>;
		protected var _events:Vector.<String>;
		
		public function CompanyState(data:Object = null) 
		{
			_workingSeams = new Vector.<SeamData>();
			_events = new Vector.<String>();
			
			if (data)
				populate(data);
		}
		
		public function populate(data:Object):void 
		{
			if (data["time"])
				ServerTime.updateDeltaTime(data["time"]);
			
			if(data["company"]){
				_company = new Company(data["company"]);
			}
				
			if (data["seams_working"])
				populateWorkingSeams(data["seams_working"]);
				
			if (data["events"])
				populateEvents(data["events"]);
		}
		
		public function reset():void 
		{
			_company = null;
			
			_workingSeams.splice(0, _workingSeams.length);
			_events.splice(0, _events.length);
		}
		
		protected function populateWorkingSeams(data:Object):void
		{
			if (!data)
				return;
				
			var seamsArray:Array = data as Array ? data as Array : [data];
			var tempSeam:SeamData;
			
			_workingSeams.splice(0, _workingSeams.length);
			
			if (seamsArray)
			{
				for each(var seamObject:Object in seamsArray) {
					tempSeam = new SeamData(seamObject);
					
					if(!tempSeam.empty())
						_workingSeams.push(tempSeam);
				}
			}
		}
		
		protected function populateEvents(data:Object):void
		{
			if (!data)
				return;
				
			var eventsArray:Array = data as Array ? data as Array : [data];
			var tempEvent:String;
			
			for each(var eventObject:Object in eventsArray) {
				tempEvent = eventObject as String;
				
				if(tempEvent && tempEvent != "")
					_events.push(tempEvent);
			}
		}
		
		public function get company():Company 
		{
			return _company;
		}
		
		public function get events():Vector.<String> 
		{
			return _events;
		}
		
		public function get workingSeams():Vector.<SeamData> 
		{
			return _workingSeams;
		}
	}

}
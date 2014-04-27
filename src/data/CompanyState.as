package data 
{
	import utils.ServerTime;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class CompanyState implements IPopulatable 
	{
		protected var _company:Company;
		protected var _workingSeams:Vector.<Seam>;
		protected var _events:Vector.<String>;
		
		public function CompanyState() 
		{
			_workingSeams = new Vector.<Seam>();
			_events = new Vector.<String>();
		}
		
		public function populate(data:Object):void 
		{
			if (data["time"])
				ServerTime.updateDeltaTime(data.time);
			
			if(data["company"]){
				_company = new Company(); 
				_company.populate(data["company"]);
			}
				
			if (data["working_seams"])
				populateWorkingSeams(data["working_seams"]);
				
			if (data["events"])
				populateEvents(data["events"]);
		}
		
		public function reset():void 
		{
			_company = null;
			
			_workingSeams.splice(0, _workingSeams.length);
			_events.splice(0, _events.length);
		}
	}

}
package data 
{
	import infrastructure.interfaces.IPopulatable;
	import utils.ServerTime;
	
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class Seam implements IPopulatable 
	{
		protected var _id:int;
		protected var _state:SeamState;
		protected var _owner:Company;
		protected var _plantingDate:Date;
		protected var _planet:int;
		protected var _planetName:String;
		protected var _extractionRate:int;
		protected var _recentGain:int;
		
		public function Seam() 
		{
			
		}
		
		/* INTERFACE infrastructure.interfaces.IPopulatable */
		
		public function populate(data:Object):void 
		{
			if(data["id"])
				_id = data["id"];
			
			if(data["state"])	
				_state = data["state"];
				
			if(data["owner"])	
				_state = data["owner"];
				
			if(data["planting_date"])	
				_plantingDate = ServerTime.getDateFromServerTime(data["planting_date"]);
			
			if(data["planet"])
				_planet = data["planet"];
			
			if(data["planet_name"])
				_planetName = data["planet_name"];
			
			if(data["extraction_rate"])
				_planetName = data["extraction_rate"];
				
			if (data["recent_gain"])
				_recentGain = data["recent_gain"];
		}
		
		public function reset():void 
		{
			_id = 0;
			_state = null;
			_owner = null;
			_plantingDate = null;
			_planet = 0;
			_planetName = null;
			_extractionRate = 0;
			_recentGain = 0;
		}
		
		public function empty():Boolean
		{
			return _id <= 0;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get state():SeamState 
		{
			return _state;
		}
		
		public function get plantingDate():Date 
		{
			return _plantingDate;
		}
		
		public function get planet():int 
		{
			return _planet;
		}
		
		public function get planetName():String 
		{
			return _planetName;
		}
		
		public function get extractionRate():int 
		{
			return _extractionRate;
		}
		
		public function get recentGain():int 
		{
			return _recentGain;
		}
	}

}
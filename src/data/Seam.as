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
		protected var _plantingDate:Date;
		protected var _planet:int;
		protected var _planetName:String; 
		
		public function Seam() 
		{
			
		}
		
		/* INTERFACE infrastructure.interfaces.IPopulatable */
		
		public function populate(data:Object):void 
		{
			_id = data.id;
			_state = data.state;
			_plantingDate = ServerTime.getDateFromServerTime(data.planting_date);
			_planet = data.planet;
			_planetName = data.planet_name;
		}
		
		public function reset():void 
		{
			_id = 0;
			_state = null;
			_plantingDate = null;
			_planet = 0;
			_planetName = null;
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
	}

}
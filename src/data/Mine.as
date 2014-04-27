package data 
{
	import infrastructure.interfaces.IPopulatable;
	
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class Mine implements IPopulatable 
	{
		protected var _id:int;
		protected var _occupant:Company;
		protected var _map:int;
		protected var _seams:Vector.<Seam>;
		
		public function Mine() 
		{
			_seams = new Vector.<Seam>();
		}
		
		/* INTERFACE infrastructure.interfaces.IPopulatable */
		
		public function populate(data:Object):void 
		{
			if(data["id"])
				_id = data.["id"];
			
			if(data["map"])
				_map = data["map"];
			
			if(data["occupant"]){ 
				_occupant = new Company();
				_occupant.populate(data["occupant"]);
			}else{
				_occupant = null;
			}
			populateSeams(data["seams"]);
		}
		
		public function reset():void 
		{
			_id = 0;
			_map = 0;
			_occupant = null;
			_seams.splice(0, _seams.length);
		}
		
		protected function populateSeams(data:Object):void
		{
			// TODO
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get occupant():Company 
		{
			return _occupant;
		}
		
		public function get map():int 
		{
			return _map;
		}
		
		public function get seams():Vector.<Seam> 
		{
			return _seams;
		}
	}

}
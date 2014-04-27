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
		protected var _deaths:Vector.<Death>;
		
		public function Mine(data:Object = null) 
		{
			_seams = new Vector.<Seam>();
			_deaths = new Vector.<Death>();
			
			if (data)
				populate(data);
		}
		
		public function populate(data:Object):void 
		{
			if(data["id"])
				_id = data["id"];
			
			if(data["map"])
				_map = data["map"];
			
			if(data["occupant"]){ 
				_occupant = new Company(data["occupant"]);
			}else{
				_occupant = null;
			}
			populateSeams(data["seams"]);
			populateDeaths(data["deaths"]);
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
			if (!data)
				return;
				
			var seamArray:Array = data as Array ? data as Array : [data];
			var tempSeam:Seam;
			
			for each(var seamObject:Object in seamArray) {
				tempSeam = new Seam(seamObject);
				
				if(!tempSeam.empty())
					_seams.push(tempSeam);
			}
		}
		
		protected function populateDeaths(data:Object):void
		{
			if (!data)
				return;
				
			var deathArray:Array = data as Array ? data as Array : [data];
			var tempDeath:Death;
			
			for each(var deathObject:Object in deathArray) {
				tempDeath = new Death(deathObject);
				
				if(!tempDeath.empty())
					_deaths.push(tempDeath);
			}
		}
		
		public function empty():Boolean
		{
			return _id <= 0;
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
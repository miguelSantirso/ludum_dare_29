package data 
{
	import infrastructure.interfaces.IPopulatable;
	
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class System implements IPopulatable 
	{
		protected var _id:int;
		protected var _name:String;
		protected var _planets:Vector.<Planet>;

		public function System(data:Object = null) 
		{
			_planets = new Vector.<Planet>();
			
			if (data)
				populate(data);
		}
		
		public function populate(data:Object):void 
		{
			if(data["id"])
				_id = data["id"];
			
			if(data["name"])
				_name = data["name"];
			
			if(data["planets"])
				populatePlanets(data["planets"]);
		}
		
		public function reset():void 
		{
			_id = 0;
			_name = null;
			_planets.splice(0, _planets.length);
		}
		
		protected function populatePlanets(data:Object):void
		{
			if (!data)
				return;
				
			var planetArray:Array = data as Array ? data as Array : [data];
			var tempPlanet:Planet;
			
			_planets.splice(0, _planets.length);
			
			for each(var planetObject:Object in planetArray) {
				tempPlanet = new Planet();
				tempPlanet.populate(planetObject);
				
				if(!tempPlanet.empty())
					_planets.push(tempPlanet);
			}
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get planets():Vector.<Planet> 
		{
			return _planets;
		}
	}

}
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

		public function System() 
		{
			_planets = new Vector.<Planet>();
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
			// TODO
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
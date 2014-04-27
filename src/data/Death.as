package data 
{
	import infrastructure.interfaces.IPopulatable;
	
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class Death implements IPopulatable 
	{
		protected var _company:Company;
		protected var _x:int;
		protected var _y:int;
		
		public function Death(data:Object = null) 
		{
			if (data)
				populate(data);
		}
		
		/* INTERFACE infrastructure.interfaces.IPopulatable */
		
		public function populate(data:Object):void 
		{
			if (data["company"])
				_company = new Company(data["company"]);
			
			if (data["x"])
				_x = data["x"] as int;
				
			if (data["y"])
				_y = data["y"] as int;
		}
		
		public function reset():void 
		{
			_company = null;
			_x = 0;
			_y = 0;
		}
		
		public function empty():Boolean
		{
			return _company == null;
		}
		
		public function get company():Company 
		{
			return _company;
		}
		
		public function get x():int 
		{
			return _x;
		}
		
		public function get y():int 
		{
			return _y;
		}
		
	}

}
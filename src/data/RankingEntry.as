package data 
{
	import infrastructure.interfaces.IPopulatable;
	
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class RankingEntry implements IPopulatable 
	{
		protected var _position:int;
		protected var _company:Company;
		
		public function RankingEntry(data:Object = null) 
		{
			if (data)
				populate(data);
		}
		
		public function populate(data:Object):void 
		{
			// data is an object of the type [position, company]
			_company = new Company();
			_company.populate(data["company"]);
			
			_position = data["position"];
		}
		
		public function reset():void 
		{
			_position = 0;
			_company = null;
		}
		
		public function empty():Boolean
		{
			return _position <= 0 || !_company;
		}
		
		public function get position():int 
		{
			return _position;
		}
		
		public function get company():Company 
		{
			return _company;
		}
	}

}
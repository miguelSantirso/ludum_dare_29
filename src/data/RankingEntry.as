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
		
		public function RankingEntry() 
		{
			
		}
		
		public function populate(data:Object):void 
		{
			// data is an array of the type [position, company]
			var entry:Array = data ? data as Array : null;
			
			if (entry && entry.length == 2) {
				position = entry[0] as int;
				_company = new Company();
				_company.populate(entry[1]);
			}
		}
		
		public function reset():void 
		{
			_position = 0;
			_company = null;
		}
		
		public function empty():Boolean
		{
			return _position > 0 && _company != null;
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
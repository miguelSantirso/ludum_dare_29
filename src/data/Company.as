package data 
{
	import infrastructure.interfaces.IPopulatable;
	
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class Company implements IPopulatable 
	{
		protected var _id:int;
		protected var _name:String;
		protected var _workers:int;
		protected var _score:int;
		protected var _color1:uint;
		protected var _color2:uint;
		
		public function Company(data:Object = null) 
		{
			if (data)
				populate(data);
		}
		
		public function populate(data:Object):void 
		{
			if(data["id"])
				_id = data["id"];
				
			if(data["name"])
				_name = data["name"];
			
			if(data["workers"])
				_name = data["workers"];
			
			if(data["score"])
				_name = data["score"];
				
			if(data["color1"])
				_color1 = data["color1"];
				
			if(data["color2"])
				_color2 = data["color2"];
		}
		
		public function reset():void 
		{
			_id = 0;
			_name = null;
			_color1 = 0;
			_color2 = 0;
		}
		public function get id():int
		{
			return _id;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get color1():uint 
		{
			return _color1;
		}
		
		public function get color2():uint 
		{
			return _color2;
		}
		
		public function get workers():int 
		{
			return _workers;
		}
		
		public function get score():int 
		{
			return _score;
		}
	}

}
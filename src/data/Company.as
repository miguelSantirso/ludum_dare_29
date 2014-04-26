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
		protected var _color1:uint;
		protected var _color2:uint;
		
		public function Company() 
		{
			
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
		
		/* INTERFACE infrastructure.interfaces.IPopulatable */
		
		public function populate(data:Object):void 
		{
			_id = data["id"];
			_name = data["name"];
			_color1 = data["color1"];
			_color2 = data["color2"];
		}
		
		public function reset():void 
		{
			_id = 0;
			_name = null;
			_color1 = 0;
			_color2 = 0;
		}
		
	}

}
package data 
{
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class Core implements IPopulatable 
	{
		protected var _machineLifetime:int;
		
		public function Core() 
		{
			
		}
		
		public function populate(data:Object):void 
		{
			_machineLifetime = data.machine_lifetime;
		}
		
		public function reset():void 
		{
			_machineLifetime = 0;
		}
		
		public function get machineLifetime():int 
		{
			return _machineLifetime;
		}
		
	}

}
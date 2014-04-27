package data 
{
	import infrastructure.interfaces.IPopulatable;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class Core implements IPopulatable 
	{
		protected var _stateRefreshTime:int;
		protected var _machineLifetime:int;
		
		public function Core(data:Object = null) 
		{
			if (data)
				populate(data);
		}
		
		public function populate(data:Object):void 
		{
			if (data["state_refresh"])
				_stateRefreshTime = data["state_refresh"];
			else
				_stateRefreshTime = 60; // 1 minute

			if(data["machine_lifetime"])
				_machineLifetime = data["machine_lifetime"];
		}
		
		public function reset():void 
		{
			_machineLifetime = 0;
		}
		
		public function get machineLifetime():int 
		{
			return _machineLifetime;
		}
		
		public function get stateRefreshTime():int 
		{
			return _stateRefreshTime;
		}
		
	}

}
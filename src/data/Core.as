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
		protected var _systemRefreshTime:int;
		protected var _machineLifetime:int;
		
		protected var _companySuffixes:Vector.<String>;
		
		public function Core(data:Object = null) 
		{
			_companySuffixes = new Vector.<String>();
			
			if (data)
				populate(data);
		}
		
		public function populate(data:Object):void 
		{
			if (data["company_suffixes"])
				populateCompanySuffixes(data["company_suffixes"]);
				
			if (data["state_refresh"])
				_stateRefreshTime = data["state_refresh"];
			else
				_stateRefreshTime = 60; // 1 minute
				
			if (data["system_refresh"])
				_systemRefreshTime = data["system_refresh"];
			else
				_systemRefreshTime = 60; // 1 minute

			if(data["machine_lifetime"])
				_machineLifetime = data["machine_lifetime"];
				
			if(_stateRefreshTime < 20)	
				_stateRefreshTime = 20; // 1 minute
				
			if(_systemRefreshTime < 20)	
				_systemRefreshTime = 20; // 1 minute
		}
		
		public function reset():void 
		{
			_machineLifetime = 0;
		}
		
		protected function populateCompanySuffixes(data:Object):void
		{
			if (!data)
				return;
				
			var suffixesArray:Array = data as Array ? data as Array : [data];
			
			_companySuffixes.splice(0, _companySuffixes.length);

			for each(var tempSuffix:String in suffixesArray) {				
				if(tempSuffix != "")
					_companySuffixes.push(tempSuffix);
			}
		}
		
		public function get machineLifetime():int 
		{
			return _machineLifetime;
		}
		
		public function get stateRefreshTime():int 
		{
			return _stateRefreshTime;
		}
		
		public function get systemRefreshTime():int 
		{
			return _systemRefreshTime;
		}
		
		public function get companySuffixes():Vector.<String> 
		{
			return _companySuffixes;
		}
		
	}

}
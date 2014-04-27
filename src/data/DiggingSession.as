package data 
{
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class DiggingSession 
	{
		protected var _activatedSeams:Array;
		protected var _death:Death;

		public function DiggingSession() 
		{
			_activatedSeams = new Array;
			_death = null;
		}
		
		public function death(deathObject:Death):void
		{
			if (deathObject)
				_death = deathObject;
		}
		
		public function deploySeamMachine(seamId:int):void
		{
			for each(var s:int in _activatedSeams) {
				if (s == seamId)
					return;
			}
			_activatedSeams.push(seamId);
		}
		
		public function destroySeamMachine(seamId:int):void
		{
			for (var i:int = _activatedSeams.length - 1; i >= 0; i--) {
				if (_activatedSeams[i] == seamId)
					_activatedSeams.splice(i, 1);
				return;
			} 
		}
		
		public function get activatedSeams():Array
		{
			return _activatedSeams;
		}
	}

}
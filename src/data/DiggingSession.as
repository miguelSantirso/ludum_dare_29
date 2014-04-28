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
		
		public var mine:Mine;

		public function DiggingSession() 
		{
			_activatedSeams = new Array;
			_death = null;
		}
		
		public function died(coordX:int, coordY:int):void
		{
			var deathObject:Death = new Death({x: coordX, y: coordY});
			
			_death = deathObject;
		}
		
		public function deploySeamMachine(seamIndex:int):Boolean
		{
			if (!mine)
				throw new Error("You didn't set the mine object!");
				
			if (seamIndex >= 0 && seamIndex < mine.seams.length) {				
				if (_activatedSeams.indexOf(mine.seams[seamIndex]) >= 0) 
					return false;
		
				_activatedSeams.push(mine.seams[seamIndex].id);
				
				return true;
			}else
				return false;
		}
		
		public function destroySeamMachine(seamIndex:int):Boolean
		{
			if (!mine)
				throw new Error("You didn't set the mine object!");
			
			if (seamIndex >= 0 && seamIndex < mine.seams.length) {
				var index:int = _activatedSeams.indexOf(mine.seams[seamIndex].id);
				
				if (index >= 0){
					_activatedSeams.splice(index, 1);
					return true;
				}else
					return false;
			}else
				return false;	
		}
		
		public function get activatedSeams():Array
		{
			return _activatedSeams;
		}
		
		public function get death():Death 
		{
			return _death;
		}
	}

}
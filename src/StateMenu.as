package  
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Miguel
	 */
	public class StateMenu extends SDState 
	{
		protected var level:MovieClip;
		
		public function StateMenu(_level:MovieClip) 
		{
			super();
			
			level = _level;
		}
		
	}

}
package space_digger 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author ...
	 */
	public class GameplayHud extends GameHud
	{
		
		public function GameplayHud() 
		{
			seamHint.visible = false;
			nLifes = 3;
		}
		
		
		public function set nLifes(value:int):void
		{
			value = Math.max(0, value);
			value = Math.min(3, value);
			lifes.gotoAndStop("l" + value);
		}
		
	}

}
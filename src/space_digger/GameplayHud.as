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
		}
		
		
		public function onSeamEntered():void
		{
			seamHint.visible = true;
		}
		public function onSeamExited():void
		{
			seamHint.visible = false;
		}
		
	}

}
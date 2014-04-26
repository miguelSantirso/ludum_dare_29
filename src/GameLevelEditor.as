package  
{
	import citrus.core.CitrusEngine;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import levels.*;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class GameLevelEditor extends CitrusEngine
	{
		public function GameLevelEditor() 
		{
			// setup
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCurrentLevelLoaded);
			loader.load(new URLRequest("../levels/Level1.swf")); 
		}

		protected function onCurrentLevelLoaded(e:Event):void
		{
			state = new Level1(e.target.loader.content);
			
			e.target.removeEventListener(Event.COMPLETE, onCurrentLevelLoaded);
			e.target.loader.unloadAndStop();
		}
	}

}
package  
{
	import citrus.core.CitrusEngine;
	import citrus.core.State;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class GameLevelManager extends CitrusEngine
	{
		public function GameLevelManager() 
		{
			// setup
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCurrentLevelLoaded);
			loader.load(new URLRequest("../swf/levels/Level1.swf")); 
		}

		protected function onCurrentLevelLoaded(e:Event):void
		{
			state = new GameLevel(e.target.loader.content);
			
			e.target.removeEventListener(Event.COMPLETE, onCurrentLevelLoaded);
			e.target.loader.unloadAndStop();
		}
		
		public function update():void
		{
			(state as GameLevel).refreshView();
		}
	}

}
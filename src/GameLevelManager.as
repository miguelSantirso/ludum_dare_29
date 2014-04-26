package  
{
	import citrus.core.CitrusEngine;
	import citrus.core.State;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import citrus.utils.LevelManager;
	import flash.utils.getDefinitionByName;
	import space_digger.levels.*;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class GameLevelManager extends CitrusEngine
	{
		public static const LEVEL_SPACE:String = "LevelSpace";
		public static const LEVEL_PLANET:String = "LevelPlanet";
		public static const LEVEL_DIG:String = "Level1";
		
		private var _currentLevelName:String;

		public function GameLevelManager(firstLevel:String = LEVEL_DIG) 
		{
			changeLevel(firstLevel);
		}
		
		public function changeLevel(level:String):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCurrentLevelLoaded);
			loader.load(new URLRequest("../swf/levels/" + level + ".swf"));
			_currentLevelName = level;
		}

		protected function onCurrentLevelLoaded(e:Event):void
		{
			switch(_currentLevelName)
			{
				case LEVEL_SPACE:
					state = new LevelSpace(e.target.loader.content);
					break;
					
				case LEVEL_PLANET:
					state = new LevelPlanet(e.target.loader.content);
					break;
					
				case LEVEL_DIG:
					state = new LevelDig(e.target.loader.content);
					break;
			}
			
			e.target.removeEventListener(Event.COMPLETE, onCurrentLevelLoaded);
			e.target.loader.unloadAndStop();
		}
		
		public function update():void
		{
			//(state as GameLevel).refreshView();
		}
	}

}
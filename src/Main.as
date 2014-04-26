package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import utils.Stats;
	
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class Main extends Sprite 
	{
		public static const DEBUG:Boolean = true;
		
		protected static var levelEditor:GameLevelEditor;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			levelEditor = new GameLevelEditor();
			addChild(levelEditor);
			
			if (Main.DEBUG)
				addChild(new Stats());
		}
	}
	
}
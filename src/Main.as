package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import utils.ProfileTools;
	
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class Main extends Sprite 
	{
		protected static var levelEditor:GameLevelEditor;
		private var _profileTools:ProfileTools;
		
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
			
			_profileTools = new ProfileTools();
			addChild(_profileTools);
			
			stage.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void
		{
			_profileTools.update();
		}
	}
	
}
package space_digger.levels 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import managers.RemoteManager;
	import managers.GameManager;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class LevelRegister extends GameLevel
	{
		public function LevelRegister(_level:MovieClip) 
		{
			super(_level);
			
			addChild(level);
		}
		
		public override function initialize():void
		{
			super.initialize();
			
			level.button_debug_dig.visible =
			level.button_debug_space.visible = Main.DEBUG;
			
			setActionListeners();
		}
		
		public override function update(timeDelta:Number):void
		{
			super.update(timeDelta);
		}
		
		public override function dispose():void
		{
			removeActionListeners();
			
			super.dispose();
		}
		
		public function get companyNameInput():String
		{
			return level.input_company_name.text;
		}
		
		public function get companyTypeInput():String
		{
			return level.input_company_type.text;
		}
		
		protected function setActionListeners():void
		{
			level.button_start.addEventListener(MouseEvent.CLICK, onStartButtonHandler);
			
			if (Main.DEBUG)
			{
				level.button_debug_dig.addEventListener(MouseEvent.CLICK, onDebugButtonDigHandler);
				level.button_debug_space.addEventListener(MouseEvent.CLICK, onDebugButtonSpaceHandler);
			}
		}
		
		protected function removeActionListeners():void
		{
			level.button_start.removeEventListener(MouseEvent.CLICK, onStartButtonHandler);
		}
		
		// ACTION HANDLERS:
		private function onStartButtonHandler(e:MouseEvent):void
		{
			GameManager.getInstance().register(companyNameInput + " " + companyTypeInput, 0x000000, 0x000000);
		}
		
		private function onDebugButtonDigHandler(e:MouseEvent = null):void
		{
			changeLevel.dispatch(3);
		}
		
		private function onDebugButtonSpaceHandler(e:MouseEvent = null):void
		{
			changeLevel.dispatch(2);
		}
	}
}
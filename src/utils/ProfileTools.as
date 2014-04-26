package utils 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class ProfileTools extends MovieClip
	{
		private var _memoryHintEnabled:Boolean;
		private var _fpsHintEnabled:Boolean;
		private var _memoryHintPanel:Sprite;
		private var _fpsHintPanel:Sprite;
		
		public function ProfileTools() 
		{
			super();
			
			_memoryHintPanel = new Sprite();
			_fpsHintPanel = new Sprite();
			
			_fpsHintPanel.graphics.beginFill(0xff0000, 1);
			_fpsHintPanel.graphics.drawRect(0, 0, 50, 50);
			_fpsHintPanel.graphics.endFill();
			
			addChild(_fpsHintPanel);
		}
		
		public function set enableMemoryHint(value:Boolean):void
		{
			_memoryHintEnabled = value;
		}
		
		public function set enableFPSHint(value:Boolean):void
		{
			_fpsHintEnabled = value;
		}
		
		public function update():void
		{
			if (_memoryHintEnabled) refreshMemoryHint();
			if (_fpsHintEnabled) refreshFPSHint();
		}
		
		protected function refreshMemoryHint():void
		{
			
		}
		
		protected function refreshFPSHint():void
		{
			
		}
	}

}
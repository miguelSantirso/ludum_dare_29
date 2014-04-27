package space_digger.popups 
{
	import flash.display.Sprite;
	import utils.Text;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class PopupGeneric extends Sprite
	{
		public static const EVENT_CLOSE:String = "eventClose";
		private var _asset:AssetPopupGeneric;
		
		public function PopupGeneric(message:String = "", buttonLabel:String = "CLOSE") 
		{
			_asset = new AssetPopupGeneric();
			
			addChild(_asset);
			
			init();
		}
		
		public function init():void
		{
			_asset.button_close.addEventListener(MouseEvent.CLICK, onButtonCloseHandler);
		}
		
		public function dispose():void
		{
			_asset.button_close.removeEventListener(MouseEvent.CLICK, onButtonCloseHandler);
			
			removeChild(_asset);
		}
		
		public function set message(text:String):void
		{
			_asset.label_message = text;
			Text.truncateText(_asset.label_message, "...");
		}
		
		public function set buttonLabel(text:String):void
		{
			_asset.button_generic.label_text.text = text;
			Text.truncateText(_asset.button_generic.label_text);
		}
		
		private function onButtonCloseHandler(e:MouseEvent):void
		{
			dispatchEvent(new Event(EVENT_CLOSE));
		}
	}
}
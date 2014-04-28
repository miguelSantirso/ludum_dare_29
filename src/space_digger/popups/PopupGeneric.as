package space_digger.popups 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.osflash.signals.Signal;
	import utils.Text;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class PopupGeneric extends Sprite
	{
		public var closePopup:Signal;
		private var _asset:AssetPopupGeneric;
		protected var _overlaid:Boolean;
		protected var _closeCallback:Function;
		
		public function PopupGeneric(message:String = "", buttonLabel:String = "CLOSE", closeCallback:Function = null, overlaid:Boolean = false) 
		{
			_asset = new AssetPopupGeneric();
			closePopup = new Signal();
			
			addChild(_asset);
			
			_asset.label_message.text = message;
			_asset.button_generic.label_text.text = buttonLabel;
			
			if(message != "") _asset.label_message.replaceText(0, 1, message.charAt(0).toUpperCase());
			
			Text.truncateMultilineText(_asset.label_message, 3, "...");
			Text.truncateText(_asset.button_generic.label_text);
			
			_closeCallback = closeCallback;
			_overlaid = overlaid;
			
			init();
		}
		
		public function init():void
		{
			_asset.button_generic.addEventListener(MouseEvent.CLICK, onButtonCloseHandler);
		}
		
		public function dispose():void
		{
			_asset.button_generic.removeEventListener(MouseEvent.CLICK, onButtonCloseHandler);
			
			closePopup.removeAll();
			closePopup = null;
			
			removeChild(_asset);
		}
		
		public function get closeCallback():Function
		{
			return _closeCallback;
		}
		
		public function get overlaid():Boolean
		{
			return _overlaid;
		}
		
		public function set message(text:String):void
		{
			_asset.label_message.text = text;
			Text.truncateText(_asset.label_message, "...");
		}
		
		public function set buttonLabel(text:String):void
		{
			_asset.button_generic.label_text.text = text;
			Text.truncateText(_asset.button_generic.label_text);
		}
		
		private function onButtonCloseHandler(e:MouseEvent):void
		{
			closePopup.dispatch();
		}
	}
}
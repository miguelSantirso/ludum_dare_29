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
		public static const TYPE_MONO:String = "mono";
		public static const TYPE_DUAL:String = "dual";
		
		public var acceptPopup:Signal;
		public var cancelPopup:Signal
		private var _asset:AssetPopupGeneric;
		private var _type:String;
		protected var _acceptCallback:Function;
		protected var _cancelCallback:Function;
		
		public function PopupGeneric(message:String = "", 
									type:String = TYPE_MONO, 
									buttonAcceptLabel:String = "CLOSE", 
									buttonCancelLabel:String = "CANCEL",
									acceptCallback:Function = null,
									cancelCallback:Function = null) 
		{
			_asset = new AssetPopupGeneric();
			acceptPopup = new Signal();
			cancelPopup = new Signal();
			
			addChild(_asset);
			
			_asset.gotoAndStop(type);
			_asset.label_message.text = message;
			
			if (type == TYPE_MONO)
			{
				_asset.button_accept.label_text.text = buttonAcceptLabel;
				Text.truncateText(_asset.button_accept.label_text);
				
				_type = type;
			}
			else if (type == TYPE_DUAL)
			{
				_asset.button_accept.label_text.text = buttonAcceptLabel;
				_asset.button_cancel.label_text.text = buttonCancelLabel;
				
				Text.truncateText(_asset.button_accept.label_text);
				Text.truncateText(_asset.button_cancel.label_text);
				
				_type = type;
			}
			else return;
			
			if(message != "") _asset.label_message.replaceText(0, 1, message.charAt(0).toUpperCase());
			
			Text.truncateMultilineText(_asset.label_message, 3, "...");
			
			_acceptCallback = acceptCallback;
			_cancelCallback = cancelCallback;
			
			init();
		}
		
		public function init():void
		{
			_asset.button_accept.addEventListener(MouseEvent.CLICK, onButtonAcceptHandler, false, 0, true);
			if(_type == TYPE_DUAL) _asset.button_cancel.addEventListener(MouseEvent.CLICK, onButtonCancelHandler, false, 0, true);
		}
		
		public function dispose():void
		{
			_asset.button_accept.removeEventListener(MouseEvent.CLICK, onButtonAcceptHandler);
			if(_type == TYPE_DUAL) _asset.button_cancel.removeEventListener(MouseEvent.CLICK, onButtonCancelHandler);
			
			acceptPopup.removeAll();
			cancelPopup.removeAll();
			
			acceptPopup = null;
			cancelPopup = null;
			
			removeChild(_asset);
		}
		
		public function get acceptCallback():Function
		{
			return _acceptCallback;
		}
		
		public function get cancelCallback():Function
		{
			return _cancelCallback;
		}
		
		public function set message(text:String):void
		{
			_asset.label_message.text = text;
			Text.truncateText(_asset.label_message, "...");
		}
		
		public function set buttonAcceptLabel(text:String):void
		{
			_asset.button_accept.label_text.text = text;
			Text.truncateText(_asset.button_accept.label_text);
		}
		
		public function set buttonCancelLabel(text:String):void
		{
			_asset.button_cancel.label_text.text = text;
			Text.truncateText(_asset.button_cancel.label_text);
		}
		
		private function onButtonAcceptHandler(e:MouseEvent):void
		{
			acceptPopup.dispatch();
		}
		
		private function onButtonCancelHandler(e:MouseEvent):void
		{
			cancelPopup.dispatch();
		}
	}
}
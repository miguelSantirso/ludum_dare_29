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
	public class PopupSettings extends Sprite
	{
		public var closePopup:Signal;
		private var _asset:AssetPopupGeneric;
		protected var _closeCallback:Function;
		
		public function PopupSettings() 
		{
			_asset = new AssetPopupSettings();
			closePopup = new Signal();
			
			addChild(_asset);
			
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
		
		private function onButtonCloseHandler(e:MouseEvent):void
		{
			closePopup.dispatch();
		}
	}
}
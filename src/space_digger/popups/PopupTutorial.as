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
	public class PopupTutorial extends Sprite
	{
		public static const STATE_SPACE:String = "state_space";
		public static const STATE_DIG:String = "state_dig";
		
		public var closePopup:Signal;
		private var _asset:AssetPopupGeneric;
		protected var _closeCallback:Function;
		
		public function PopupTutorial(state:String) 
		{
			_asset = new AssetPopupGeneric();
			closePopup = new Signal();
			
			addChild(_asset);
			
			_asset.gotoAndStop(state);
			
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
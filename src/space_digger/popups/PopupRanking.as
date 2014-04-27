package space_digger.popups 
{
	import data.RankingEntry;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import utils.scroller.Scroller;
	import utils.Text;
	import space_digger.RankingPositionIR;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class PopupRanking extends Sprite
	{
		public static const EVENT_CLOSE:String = "eventClose";
		private var _asset:AssetPopupRanking;
		protected var rankingScroller:Scroller;
		
		public function PopupRanking(message:String = "", buttonLabel:String = "CLOSE") 
		{
			_asset = new AssetPopupRanking();
			
			addChild(_asset);
			
			init();
		}
		
		public function init():void
		{
			rankingScroller = new Scroller(false, 8.9, RankingPositionIR, 0);
			rankingScroller.init();
			_asset.slot_ranking_list.addChild(rankingScroller);
			
			_asset.button_close.addEventListener(MouseEvent.CLICK, onButtonCloseHandler);
		}
		
		public function dispose():void
		{
			_asset.button_close.removeEventListener(MouseEvent.CLICK, onButtonCloseHandler);
	
			_asset.slot_ranking_list.removeChild(rankingScroller);
			
			rankingScroller.dispose();
			rankingScroller = null;
			
			removeChild(_asset);
		}
		
		public function set ranking(values:Vector.<RankingEntry>):void
		{
			var scrollerDataProvider:Array = new Array();
			
			for (var i:int = 0; i < values.length; i++)
			{
				scrollerDataProvider.push(values[i]);
			}
			
			rankingScroller.dataProvider = scrollerDataProvider;
		}
		
		private function onButtonCloseHandler(e:MouseEvent):void
		{
			dispatchEvent(new Event(EVENT_CLOSE));
		}
	}
}
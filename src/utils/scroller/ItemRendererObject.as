package utils.scroller 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Albert Badosa Solé
	 */
	public class ItemRendererObject extends Sprite
	{
		protected var _asset:MovieClip;
		protected var _data:Object;

		public function ItemRendererObject() 
		{
		}

		public function init(event:Event = null):void
		{
		}

		public function update(event:Event = null):void
		{
		}

		public function dispose(event:Event = null):void
		{
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

		public function set asset(mc:MovieClip):void
		{
			_asset = mc;
		}

		public function get data():Object
		{
			return _data;
		}

		public function get asset():*
		{
			return _asset;
		}
	}
}
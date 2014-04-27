package space_digger 
{
	import flash.events.Event;
	import utils.scroller.ItemRendererObject;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class ActivityIR extends ItemRendererObject
	{
		public function ActivityIR() 
		{
			asset = new IRRecentActivity();
			
			addChild(asset);
		}
		
		public override function init(event:Event = null):void
		{
			super.init();
		}

		public override function update(event:Event = null):void
		{
			super.update();
		}

		public override function dispose(event:Event = null):void
		{
			super.dispose();
		}

		public override function set data(value:Object):void
		{
			super.data = value;

			//asset.label_message.text = value.message;
		}

		public override function get asset():*
		{
			return super.asset as IRRecentActivity;
		}
	}

}
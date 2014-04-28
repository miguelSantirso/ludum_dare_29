package space_digger.item_renderers 
{
	import flash.events.Event;
	import utils.scroller.ItemRendererObject;
	import utils.Text;
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

		public override function set dataValue(value:Object):void
		{
			super.dataValue = value;

			asset.label_description.text = value;			
			Text.truncateMultilineText(asset.label_description, 3, "...");
		}

		public override function get asset():*
		{
			return super.asset as IRRecentActivity;
		}
	}

}
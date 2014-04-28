package space_digger.item_renderers 
{
	import flash.events.Event;
	import utils.scroller.ItemRendererObject;
	import utils.Text;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class OperatingCompanyIR extends ItemRendererObject
	{
		public function OperatingCompanyIR() 
		{
			asset = new IROperatingCompany();
			
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

			asset.label_company_name.text = value;	
			Text.truncateText(asset.label_company_name);
		}

		public override function get asset():*
		{
			return super.asset as IROperatingCompany;
		}
	}

}
package space_digger 
{
	import data.SeamData;
	import flash.events.Event;
	import utils.scroller.ItemRendererObject;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class OperationIR extends ItemRendererObject
	{
		public function OperationIR() 
		{
			asset = new IROngoingOp();
			
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

			/*asset.label_name.text = (value as SeamData).planetName;
			asset.label_gold_per_hour.text = (value as SeamData).extractionRate + " gold/h";
			asset.label_num_machines.text = 3;// (value as SeamData).*/
		}

		public override function get asset():*
		{
			return super.asset as IROngoingOp;
		}
	}

}
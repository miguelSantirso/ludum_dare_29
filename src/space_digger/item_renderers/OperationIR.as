package space_digger.item_renderers 
{
	import away3d.events.MouseEvent3D;
	import data.SeamData;
	import flash.events.Event;
	import org.osflash.signals.Signal;
	import space_digger.OngoingOpEvent;
	import utils.scroller.ItemRendererObject;
	import flash.events.MouseEvent;
	import managers.DataManager;
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
			
			init();
		}
		
		public override function init(event:Event = null):void
		{
			super.init();
			
			asset.button_visit.addEventListener(MouseEvent.CLICK, onVisitPlanetClick, false, 0, true);
		}

		public override function update(event:Event = null):void
		{
			super.update();
		}

		public override function dispose(event:Event = null):void
		{
			super.dispose();
			
			asset.button_visit.removeEventListener(MouseEvent.CLICK, onVisitPlanetClick);
		}

		public override function set dataValue(value:Object):void
		{
			super.dataValue = value;

			asset.label_name.text = value["planetName"];
			asset.label_gold_per_hour.text = value["extractionRate"].toString() + " gold/s";
			asset.label_num_machines.text = value["machines"].toString() + " extracting machines";
			
			asset.button_visit.visible = !DataManager.getInstance().isPlanetInCurrentSystem(value["planetID"]);
		}

		public override function get asset():*
		{
			return super.asset as IROngoingOp;
		}
		
		private function onVisitPlanetClick(e:MouseEvent):void
		{
			dispatchEvent(new OngoingOpEvent(data["planetID"], OngoingOpEvent.VISIT_PLANET, true));
		}
	}

}
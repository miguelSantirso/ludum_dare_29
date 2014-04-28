package space_digger.item_renderers 
{
	import flash.events.Event;
	import utils.scroller.ItemRendererObject;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class RankingPositionIR extends ItemRendererObject
	{
		public function RankingPositionIR() 
		{
			asset = new IRRankingPosition();
			
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

			asset.label_company_position.text = "#" + value.position.toString();
			asset.label_company_name.text = value.company.name;
			asset.label_company_gold.text = value.company.score.toString();
		}

		public override function get asset():*
		{
			return super.asset as IRRankingPosition;
		}
	}

}
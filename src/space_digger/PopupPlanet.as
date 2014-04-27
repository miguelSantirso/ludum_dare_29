package space_digger 
{
	import away3d.events.MouseEvent3D;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import utils.Text;
	import data.PlanetRichness;
	import managers.DataManager;
	import data.PlanetRichness;
	import data.PlanetToxicity;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class PopupPlanet extends Sprite
	{
		public static const EVENT_CLOSE:String = "eventClose";
		private var _asset:AssetPopupPlanet;
		
		public function PopupPlanet() 
		{
			_asset = new AssetPopupPlanet();
			
			addChild(_asset);
			
			init();
		}
		
		public function init():void
		{
			var sectorMC:MovieClip;
			
			for (var i:int = 0; i < 6; i++)
			{
				sectorMC = _asset.planet_sectors.getChildByName("sector_" + i) as MovieClip;
				sectorMC.gotoAndStop(1);
				sectorMC.addEventListener(MouseEvent.MOUSE_OVER, highlightSector);
				sectorMC.addEventListener(MouseEvent.MOUSE_OUT, dehighlightSector);
			}
			
			_asset.button_close.addEventListener(MouseEvent.CLICK, onButtonCloseHandler);
		}
		
		public function dispose():void
		{
			var sectorMC:MovieClip;
			
			for (var i:int = 0; i < 6; i++)
			{
				sectorMC = _asset.planet_sectors.getChildByName("sector_" + i) as MovieClip;
				sectorMC.removeEventListener(MouseEvent.MOUSE_OVER, highlightSector);
				sectorMC.removeEventListener(MouseEvent.MOUSE_OUT, dehighlightSector);
			}
			
			removeChild(_asset);
		}
		
		public function set planetName(text:String):void
		{
			_asset.label_planet_name.text = text;
			Text.truncateText(_asset.label_planet_name);
		}
		
		public function set planetToxicity(value:int):void
		{
			if (value < 0) value = 0;
			
			var toxicityValue:String;
			
			switch(value)
			{
				case PlanetToxicity.LOW:
					toxicityValue = "low";
					break;
					
				case PlanetToxicity.MEDIUM:
					toxicityValue = "med";
					break;
					
				case PlanetToxicity.HIGH:
				default:
					toxicityValue = "high";
					break;
			}
			
			_asset.label_toxicity.text = toxicityValue;
		}
		
		public function set planetRichness(value:int):void
		{
			if (value < 0) value = 0;
			
			var richnessValue:String;
			
			switch(value)
			{
				case PlanetRichness.POOR:
					richnessValue = "poor";
					break;
					
				case PlanetRichness.RICH:
				default:
					richnessValue = "rich";
					break;
			}
				
			_asset.label_richness.text = richnessValue;
			_asset.label_richness_level_value.text = richnessValue;
		}
		
		public function set planetVisitedTimes(value:int):void
		{
			_asset.label_visited_value.text = value.toString();
		}
		
		public function set occupied(value:Boolean):void
		{
			
		}
		
		private function highlightSector(e:MouseEvent):void
		{
			(e.currentTarget as MovieClip).gotoAndStop(2);
		}
		
		private function dehighlightSector(e:MouseEvent):void
		{
			(e.currentTarget as MovieClip).gotoAndStop(1);
		}
		
		private function onButtonCloseHandler(e:MouseEvent):void
		{
			dispatchEvent(new Event(EVENT_CLOSE));
		}
	}
}
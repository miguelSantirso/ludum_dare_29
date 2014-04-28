package space_digger.popups 
{
	import away3d.events.MouseEvent3D;
	import data.Mine;
	import data.Planet;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import utils.scroller.Scroller;
	import utils.Text;
	import data.PlanetRichness;
	import managers.DataManager;
	import data.PlanetRichness;
	import data.PlanetToxicity;
	import managers.GameManager;
	import space_digger.item_renderers.OperatingCompanyIR;
	
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class PopupPlanet extends Sprite
	{
		public static const EVENT_CLOSE:String = "eventClose"; // cambiar por Signal
		private var _asset:AssetPopupPlanet;
		private var _planet:Planet;
		private var _operatingCompaniesScroller:Scroller;
		
		public var planetIndex:int;
		
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
				sectorMC.addEventListener(MouseEvent.CLICK, onClickMineHandler);
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
				sectorMC.removeEventListener(MouseEvent.CLICK, onClickMineHandler);
			}
			
			_asset.button_close.removeEventListener(MouseEvent.CLICK, onButtonCloseHandler);
			
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
		
		public function set planetCompanies(values:Array):void
		{
			if (values.length > 0)
			{
				_operatingCompaniesScroller = new Scroller(false, 6, OperatingCompanyIR, 0, values);
				_operatingCompaniesScroller.init();
				_operatingCompaniesScroller.enableInteractions = false;
				_asset.slot_companies_list.addChild(_operatingCompaniesScroller);
			}
			
			_asset.label_no_companies.visible = values.length == 0;
		}
		
		public function set planet(value:Planet):void
		{
			_planet = value;
			
			var operatingCompanies:Array = new Array();
			for each(var mine:Mine in _planet.mines)
			{
				if (mine.occupant) operatingCompanies.push(mine.occupant.name);
			}
			
			planetName = _planet.name;
			planetToxicity = _planet.toxicity;
			planetRichness = _planet.richness;
			planetCompanies = operatingCompanies;
		}

		private function highlightSector(e:MouseEvent):void
		{
			var sectorMC:MovieClip = e.currentTarget as MovieClip;
			var mineIndex:int = int( (e.currentTarget as MovieClip).name.charAt((e.currentTarget as MovieClip).name.length - 1));
			sectorMC.gotoAndStop(2);
			
			var numOfSeams:int = _planet.mines[mineIndex].seams.length;
			_asset.label_richness_level_value.text = numOfSeams < 5 ? "poor" : "rich";
			
			var numOfDeaths:int = _planet.mines[mineIndex].deaths.length;
			_asset.label_deaths_value.text = numOfDeaths.toString();
			
			_asset.label_richness_level.visible = true;
			_asset.label_richness_level_value.visible = true;
			_asset.label_deaths.visible = true;
			_asset.label_deaths_value.visible = true;
			_asset.label_occupied.visible =
				_asset.label_occupied_company.visible = _planet.mines[mineIndex].occupant != null;
			_asset.label_free.visible = _planet.mines[mineIndex].occupant == null;
			
			if (_planet.mines[mineIndex].occupant != null)
			{
				_asset.label_occupied_company.text = _planet.mines[mineIndex].occupant.name;
				Text.truncateText(_asset.label_occupied_company);
			}
		}
		
		private function dehighlightSector(e:MouseEvent):void
		{
			(e.currentTarget as MovieClip).gotoAndStop(1);
			
			_asset.label_richness_level.visible = false;
			_asset.label_richness_level_value.visible = false;
			_asset.label_deaths.visible = false;
			_asset.label_deaths_value.visible = false;
			_asset.label_occupied.visible = _asset.label_occupied_company.visible = false;
			_asset.label_free.visible = false;
		}
		
		private function onClickMineHandler(e:MouseEvent):void
		{
			var mineIndex:int = int( (e.currentTarget as MovieClip).name.charAt((e.currentTarget as MovieClip).name.length - 1));
			
			var selectedMine:Mine = _planet.mines[mineIndex];
			
			if (selectedMine.occupant == null)
			{
				GameManager.getInstance().land(selectedMine, 
					function():void {
						GameManager.getInstance().changeLevel(selectedMine);
					});
			}
			else
			{
				GameManager.getInstance().displayMessagePopUp("This mine is currently being digged by '" + selectedMine.occupant.name + "'!");
			}
		}
		
		private function onButtonCloseHandler(e:MouseEvent):void
		{
			dispatchEvent(new Event(EVENT_CLOSE));
		}
	}
}
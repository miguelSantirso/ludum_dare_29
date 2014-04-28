package space_digger.levels 
{
	import away3d.events.MouseEvent3D;
	import data.Planet;
	import data.SeamData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	import flash.events.MouseEvent;
	import space_digger.popups.PopupPlanet;
	import space_digger.popups.PopupRanking;
	import space_digger.Seam;
	import utils.Text;
	import managers.DataManager;
	import managers.GameManager;
	import utils.scroller.Scroller;
	import space_digger.item_renderers.OperationIR;
	import space_digger.item_renderers.ActivityIR;
	import data.PlanetToxicity;
	import data.PlanetRichness;
	import space_digger.OngoingOpEvent;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class LevelSpace extends GameLevel
	{
		protected var _recentActivityScroller:Scroller;
		protected var _ongoingOpsScroller:Scroller;
		protected var _popupPlanet:PopupPlanet;
		protected var _popupRanking:PopupRanking;
		private var popupModal:Sprite;
		
		public function LevelSpace(_level:MovieClip) 
		{
			super(_level);
			
			addChild(level);
		}
		
		public override function initialize():void
		{
			super.initialize();
			
			level.button_logout.addEventListener(MouseEvent.CLICK, logout);
			level.button_jump.addEventListener(MouseEvent.CLICK, jumpToAnotherSystem,false,0,true);
			
			_recentActivityScroller = new Scroller(false, 4.2, ActivityIR, 5);
			_recentActivityScroller.init();
			level.slot_activity_list.addChild(_recentActivityScroller);
			
			_ongoingOpsScroller = new Scroller(false, 3.8, OperationIR);
			_ongoingOpsScroller.init();
			level.slot_ongoing_list.addChild(_ongoingOpsScroller);
			
			_popupPlanet = new PopupPlanet();
			_popupPlanet.x = (stage.stageWidth - _popupPlanet.width) * 0.5;
			_popupPlanet.y = (stage.stageHeight - _popupPlanet.height) * 0.5;
			_popupPlanet.addEventListener(PopupPlanet.EVENT_CLOSE, closePlanetPopup);
			
			_popupRanking = new PopupRanking();
			_popupRanking.x = (stage.stageWidth - _popupRanking.width) * 0.5;
			_popupRanking.y = (stage.stageHeight - _popupRanking.height) * 0.5;
			_popupRanking.addEventListener(PopupRanking.EVENT_CLOSE, closeRankingPopup);
			
			popupModal = new Sprite();
			popupModal.graphics.beginFill(0x000000, 0.85);
			popupModal.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			popupModal.graphics.endFill();
			
			setCompanyData();
			setSystemData();
			setOngoingOperations();
			setRecentActivity();
			
			level.button_logout.addEventListener(MouseEvent.CLICK, logout);
			level.button_view_ranking.addEventListener(MouseEvent.CLICK, setRankingPopupData);
		}
		
		public override function update(timeDelta:Number):void
		{
			super.update(timeDelta);
		}
		
		public override function dispose():void
		{
			level.button_logout.removeEventListener(MouseEvent.CLICK, logout);
			level.button_jump.removeEventListener(MouseEvent.CLICK, jumpToAnotherSystem);
			
			level.slot_activity_list.removeChild(_recentActivityScroller);
			level.slot_ongoing_list.removeChild(_ongoingOpsScroller);
			removeChild(_popupPlanet);
			
			_popupPlanet.dispose();
			_popupRanking.dispose();
			
			_ongoingOpsScroller.dispose();
			_recentActivityScroller.dispose();
			
			_ongoingOpsScroller = null;
			_recentActivityScroller = null;
			
			super.dispose();
		}
		
		private function logout(e:MouseEvent):void
		{
			GameManager.getInstance().logout();
		}
		
		protected function jumpToAnotherSystem(e:MouseEvent):void
		{
			GameManager.getInstance().jump();
		}
		
		private function onUpdateMyCompanyRank():void
		{
			level.label_company_rank.text = "#" + DataManager.getInstance().getCompanyRank(DataManager.getInstance().myState.company.id);
		}
		
		private function onVisitOngoingPlanet(e:OngoingOpEvent):void
		{
			/*var planetIndex:int = -1;
			
			for (var i:int = 0; i < DataManager.getInstance().mySystem.planets.length; i++)
			{
				if (DataManager.getInstance().mySystem.planets[i].id == e.planetID)
				{
					planetIndex = i;
					break;
				}
			}*/
			
			//if (planetIndex > -1)
			//	openPlanetPopup(null, planetIndex);
		}
		
		public function setCompanyData():void
		{
			level.label_company_name.text = DataManager.getInstance().myState.company.name.toUpperCase();
			level.label_company_gold.text = DataManager.getInstance().myState.company.score.toString();
			level.label_company_rank.text = ""; // set later when the ranking is loaded
			level.badge_workers.label_num.text = DataManager.getInstance().myState.company.workers.toString();
			
			Text.truncateText(level.label_company_name);
			Text.truncateText(level.label_company_gold);
			Text.truncateText(level.label_company_rank);
			
			GameManager.getInstance().rankingUpdated.add(onUpdateMyCompanyRank);
			GameManager.getInstance().getRanking();
		}
		
		public function setSystemData():void
		{
			var currentPlanetMC:MovieClip;
			
			for (var i:int = 0; i < 5; i++)
			{
				var iconIndex:int = 1 + Math.round(Math.random() * 4);
				var iconRadius:int = 32 + Math.round(Math.random() * 64);
				var toxicityValue:String;
				var richnessValue:String;
				
				currentPlanetMC = level.getChildByName("planet_" + i) as MovieClip;
				currentPlanetMC.icon_planet.gotoAndStop(iconIndex);
				currentPlanetMC.icon_planet.width = currentPlanetMC.icon_planet.height = iconRadius;
				currentPlanetMC.label_name.text = DataManager.getInstance().mySystem.planets[i].name;
				
				switch(DataManager.getInstance().mySystem.planets[i].toxicity)
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

				switch(DataManager.getInstance().mySystem.planets[i].richness)
				{
					case PlanetRichness.POOR:
						richnessValue = "poor";
						break;
						
					case PlanetRichness.RICH:
					default:
						richnessValue = "rich";
						break;
				}
				
				currentPlanetMC.label_toxicity.text = toxicityValue;
				currentPlanetMC.label_richness.text = richnessValue;
				
				Text.truncateText(currentPlanetMC.label_name);
				
				currentPlanetMC.addEventListener(MouseEvent.CLICK, openPlanetPopup);
			}
		}
		
		public function setOngoingOperations():void
		{
			var goldPerPlanet:Array = new Array();
			var goldPerPlanetObject:Object;
			var existed:Boolean;
			
			for each(var seam:SeamData in DataManager.getInstance().myState.workingSeams)
			{
				existed = false;
				
				for each(var gpp:Object in goldPerPlanet)
				{
					if (gpp["planetID"] == seam.planet)
					{
						gpp["extractionRate"] += seam.extractionRate;
						gpp["machines"]++;
						gpp["lastDate"] = seam.plantingDate;
						
						existed = true;
						
						break;
					}
				}
				
				if (!existed)
				{
					goldPerPlanetObject = new Object();
					goldPerPlanetObject["planetName"] = seam.planetName;
					goldPerPlanetObject["planetID"] = seam.planet;
					goldPerPlanetObject["lastDate"] = seam.plantingDate;
					goldPerPlanetObject["extractionRate"] = seam.extractionRate;
					goldPerPlanetObject["machines"] = 1;
					
					goldPerPlanet.push(goldPerPlanetObject);
				}
			}
			
			_ongoingOpsScroller.dataProvider = goldPerPlanet;
			_ongoingOpsScroller.addEventListener(OngoingOpEvent.VISIT_PLANET, onVisitOngoingPlanet);
		}
		
		public function setRecentActivity():void
		{
			var eventsDataProvider:Array = new Array();
			
			for each(var activityEvent:String in DataManager.getInstance().myState.events)
			{
				eventsDataProvider.push(activityEvent);
			}
			
			_recentActivityScroller.dataProvider = eventsDataProvider;
		}
		
		public function setPlanetPopupData(planetIndex:int):void
		{
			if (planetIndex < 0) planetIndex = 0;
			else if (planetIndex > 4) planetIndex = 4;
			
			var selectedPlanet:Planet;
			
			if (contains(_popupPlanet))
			{
				selectedPlanet = DataManager.getInstance().mySystem.planets[planetIndex];
				_popupPlanet.planetIndex = planetIndex;
				_popupPlanet.planet = selectedPlanet;
			}
		}
		
		public function setRankingPopupData(e:Event = null):void
		{
			if (!contains(_popupRanking))
			{
				GameManager.getInstance().rankingUpdated.add(setRankingPopupDataReady);
				GameManager.getInstance().getRanking();
			}
		}
		
		public function setRankingPopupDataReady():void
		{
			GameManager.getInstance().rankingUpdated.remove(setRankingPopupDataReady);
			
			_popupRanking.ranking = DataManager.getInstance().ranking;
			openRankingPopup();
		}
		
		public function openPlanetPopup(e:MouseEvent = null, forcePlanetIndex:int = -1):void
		{
			if (!contains(_popupPlanet))
			{
				addChild(popupModal);
				addChild(_popupPlanet);
				
				var planetIndex:int = forcePlanetIndex > -1 
					? forcePlanetIndex 
					: e.currentTarget.name.charAt(e.currentTarget.name.length - 1);

				setPlanetPopupData(planetIndex);
			}
		}
		
		public function closePlanetPopup(e:Event = null):void
		{
			if (contains(_popupPlanet))
			{
				removeChild(popupModal);
				removeChild(_popupPlanet);
			}
		}
		
		public function openRankingPopup(e:MouseEvent = null):void
		{
			if (!contains(_popupRanking))
			{
				addChild(popupModal);
				addChild(_popupRanking);
				
				setRankingPopupData();
			}
		}
		
		public function closeRankingPopup(e:Event = null):void
		{
			if (contains(_popupRanking))
			{
				removeChild(popupModal);
				removeChild(_popupRanking);
			}
		}
		
		public function get popupPlanet():PopupPlanet 
		{
			return _popupPlanet;
		}
		
		public function get recentActivityScroller():Scroller 
		{
			return _recentActivityScroller;
		}
		
		public function get popupRanking():PopupRanking 
		{
			return _popupRanking;
		}
		
		public function get ongoingOpsScroller():Scroller 
		{
			return _ongoingOpsScroller;
		}
	}
}
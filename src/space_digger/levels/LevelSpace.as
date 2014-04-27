package space_digger.levels 
{
	import away3d.events.MouseEvent3D;
	import data.Planet;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	import flash.events.MouseEvent;
	import space_digger.popups.PopupPlanet;
	import utils.Text;
	import managers.DataManager;
	import managers.GameManager;
	import utils.scroller.Scroller;
	import space_digger.OperationIR;
	import space_digger.ActivityIR;
	import data.PlanetToxicity;
	import data.PlanetRichness;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class LevelSpace extends GameLevel
	{
		protected var recentActivityScroller:Scroller;
		protected var ongoingOpsScroller:Scroller;
		protected var popupPlanet:PopupPlanet;
		private var popupPlanetModal:Sprite;
		
		public function LevelSpace(_level:MovieClip) 
		{
			super(_level);
			
			addChild(level);
		}
		
		public override function initialize():void
		{
			super.initialize();
			
			setCompanyData();
			setSystemData();
			setOngoingOperations();
			setRecentActivity();
			
			level.button_logout.addEventListener(MouseEvent.CLICK, logout);
			
			// TEMP:
			var temp:Array = new Array();
			var tempObj:Object;
			
			for (var i:int = 0; i < 50; i++)
			{
				tempObj = new Object()
				tempObj["message"] = "IR " + i.toString();
				temp.push(tempObj);
			}
			
			recentActivityScroller = new Scroller(false, 6, ActivityIR, 0, temp);
			recentActivityScroller.init();
			level.slot_activity_list.addChild(recentActivityScroller);
			
			ongoingOpsScroller = new Scroller(false, 3.8, OperationIR, 0, temp);
			ongoingOpsScroller.init();
			level.slot_ongoing_list.addChild(ongoingOpsScroller);
			
			popupPlanet = new PopupPlanet();
			popupPlanet.x = (stage.stageWidth - popupPlanet.width) * 0.5;
			popupPlanet.y = (stage.stageHeight - popupPlanet.height) * 0.5;
			popupPlanet.addEventListener(PopupPlanet.EVENT_CLOSE, closePlanetPopup);
			popupPlanetModal = new Sprite();
			popupPlanetModal.graphics.beginFill(0x000000, 0.85);
			popupPlanetModal.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			popupPlanetModal.graphics.endFill();
		}
		
		public override function update(timeDelta:Number):void
		{
			super.update(timeDelta);
		}
		
		public override function dispose():void
		{
			level.slot_activity_list.removeChild(recentActivityScroller);
			level.slot_ongoing_list.removeChild(ongoingOpsScroller);
			removeChild(popupPlanet);
			
			popupPlanet.dispose();
			
			super.dispose();
		}
		
		private function logout(e:MouseEvent):void
		{
			GameManager.getInstance().logout();
		}
		
		public function setCompanyData():void
		{
			level.label_company_name.text = DataManager.getInstance().myState.company.name.toUpperCase();
			level.label_company_gold.text = DataManager.getInstance().myState.company.score.toString();
			level.label_company_rank.text = "#99"; // TO-DO
			level.badge_workers.label_num.text = DataManager.getInstance().myState.company.workers.toString();
			
			Text.truncateText(level.label_company_name);
			Text.truncateText(level.label_company_gold);
			Text.truncateText(level.label_company_rank);
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
			//
		}
		
		public function setRecentActivity():void
		{
			//
		}
		
		public function setPlanetPopupData(planetIndex:int):void
		{
			if (planetIndex < 0) planetIndex = 0;
			else if (planetIndex > 4) planetIndex = 4;
			
			var selectedPlanet:Planet;
			
			if (contains(popupPlanet))
			{
				selectedPlanet = DataManager.getInstance().mySystem.planets[planetIndex];
				popupPlanet.planet = selectedPlanet;
			}
		}
		
		public function openPlanetPopup(e:MouseEvent):void
		{
			if (!contains(popupPlanet))
			{
				addChild(popupPlanetModal);
				addChild(popupPlanet);
				
				var planetIndex:int = e.currentTarget.name.charAt(e.currentTarget.name.length - 1);

				setPlanetPopupData(planetIndex);
			}
		}
		
		public function closePlanetPopup(e:Event = null):void
		{
			if (contains(popupPlanet))
			{
				removeChild(popupPlanetModal);
				removeChild(popupPlanet);
			}
		}
	}
}
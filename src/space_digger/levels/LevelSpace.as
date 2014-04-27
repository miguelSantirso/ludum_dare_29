package space_digger.levels 
{
	import flash.display.MovieClip;
	import org.osflash.signals.Signal;
	import flash.events.MouseEvent;
	import utils.Text;
	import managers.DataManager;
	import managers.GameManager;
	import utils.scroller.Scroller;
	import space_digger.OperationIR;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class LevelSpace extends GameLevel
	{
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
			
			level.button_logout.addEventListener(MouseEvent.CLICK, logout);
			
			// TEMP
			var temp:Array = new Array();
			var tempObj:Object;
			
			for (var i:int = 0; i < 50; i++)
			{
				tempObj = new Object()
				tempObj["message"] = "IR " + i.toString();
				temp.push(tempObj);
			}
			
			var scroller:Scroller = new Scroller(true, 50, OperationIR, 10, temp);
			
			addChild(scroller);
		}
		
		public override function update(timeDelta:Number):void
		{
			super.update(timeDelta);
		}
		
		public override function dispose():void
		{
			super.dispose();
		}
		
		private function test(e:MouseEvent):void
		{
			changeLevel.dispatch(4); // TEMP!
		}
		
		private function logout(e:MouseEvent):void
		{
			GameManager.getInstance().logout();
		}
		
		public function setCompanyData():void
		{
			/*level.label_company_name.text = DataManager.getInstance().myState.company.name.toUpperCase();
			level.label_company_gold.text = DataManager.getInstance().myState.company.score.toString();
			level.label_company_rank.text = "#99"; // TO-DO
			
			Text.truncateText(level.label_company_name);
			Text.truncateText(level.label_company_gold);
			Text.truncateText(level.label_company_rank);*/
		}
		
		public function setSystemData():void
		{
			var currentPlanetMC:MovieClip;
			
			for (var i:int = 0; i < 5; i++)
			{
				var iconIndex:int = 1 + Math.round(Math.random() * 4);
				var iconRadius:int = 32 + Math.round(Math.random() * 64);

				currentPlanetMC = level.getChildByName("planet_" + i) as MovieClip;
				currentPlanetMC.icon_planet.gotoAndStop(iconIndex);
				currentPlanetMC.icon_planet.width = currentPlanetMC.icon_planet.height = iconRadius;
				currentPlanetMC.label_name.text = DataManager.getInstance().mySystem.planets[i].name;
				currentPlanetMC.label_toxicity.text = DataManager.getInstance().mySystem.planets[i].toxicity.toString() + "%";
				currentPlanetMC.label_richness.text = DataManager.getInstance().mySystem.planets[i].richness.toString() + "%";
				
				Text.truncateText(currentPlanetMC.label_name);
				
				currentPlanetMC.addEventListener(MouseEvent.CLICK, test);
			}
		}
		
		/*public function setPlanetData(index:int, name:String, toxicity:Number, richness:Number):void
		{
			if (index < 0) index = 0;
			if (index > 5) index = 4;
			
			//var planetAsset:MovieClip = level.getChildByName("planet_" + index);
			//planetAsset.
		}*/
	}
}
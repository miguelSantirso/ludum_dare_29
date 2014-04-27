package space_digger.levels 
{
	import flash.display.MovieClip;
	import org.osflash.signals.Signal;
	import flash.events.MouseEvent;
	import utils.Text;
	import managers.DataManager;
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
			
			level.planet_0.addEventListener(MouseEvent.CLICK, test);
			level.planet_1.addEventListener(MouseEvent.CLICK, test);
			level.planet_2.addEventListener(MouseEvent.CLICK, test);
			level.planet_3.addEventListener(MouseEvent.CLICK, test);
			level.planet_4.addEventListener(MouseEvent.CLICK, test);
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
		
		public function setCompanyData():void
		{
			level.label_company_name.text = DataManager.getInstance().myState.company.name.toUpperCase();
			level.label_company_gold.text = DataManager.getInstance().myState.company.score.toString();
			level.label_company_rank.text = "#4578"; //+ DataManager.getInstance().myState.company.
			
			Text.truncateText(level.label_company_name);
			Text.truncateText(level.label_company_gold);
			Text.truncateText(level.label_company_rank);
		}
		
		public function setPlanetData(index:int, name:String, toxicity:Number, richness:Number):void
		{
			if (index < 0) index = 0;
			if (index > 5) index = 4;
			
			//var planetAsset:MovieClip = level.getChildByName("planet_" + index);
			//planetAsset.
		}
	}
}
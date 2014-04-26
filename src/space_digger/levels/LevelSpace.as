package space_digger.levels 
{
	import flash.display.MovieClip;
	import org.osflash.signals.Signal;
	import flash.events.MouseEvent;
	import utils.Text;
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
			
			level.button_test.addEventListener(MouseEvent.CLICK, test);
			
			// TESTING:
			companyName = "APETECAUNJASJDASJDAJSDsdasdasdasd";
			companyType = "SL";
			companyGold = 9999;
			companyRank = 9999;
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
			changeLevel.dispatch(2); // TEMP!
		}
		
		public function set companyName(name:String):void
		{
			level.label_company_name.text = name;
			Text.truncateText(level.label_company_name);
		}
		
		public function set companyType(type:String):void
		{
			level.label_company_name.text += " " + type;
		}
		
		public function set companyGold(value:Number):void
		{
			level.label_company_gold.text = value.toString();
			Text.truncateText(level.label_company_gold);
		}
		
		public function set companyRank(value:Number):void
		{
			level.label_company_rank.text = "#" + value.toString();
			Text.truncateText(level.label_company_rank);
		}
	}
}
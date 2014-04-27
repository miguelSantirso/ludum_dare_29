package space_digger 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import utils.Text;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class PopupPlanet extends Sprite
	{
		private var _asset:AssetPopupPlanet;
		
		public function PopupPlanet() 
		{
			_asset = new AssetPopupPlanet();
			
			addChild(_asset);
		}
		
		public function set planetName(text:String):void
		{
			_asset.label_planet_name.text = text;
			Text.truncateText(_asset.label_planet_name);
		}
		
		public function set planetToxicity(value:Number):void
		{
			if (value < 0) value = 0;
			
			_asset.label_toxicity.text = value.toString() + "%";
		}
		
		public function set planetRichness(value:Number):void
		{
			if (value < 0) value = 0;
			
			_asset.label_richness.text = value.toString() + "%";
			
			var richnessLevel:String;
			if (value >= 0 && value < 25)
				richnessLevel = "poor";
			else if (value >= 25 && value < 50)
				richnessLevel = "average";
			else if (value >= 50 && value < 75)
				richnessLevel = "rich";
			else
				richnessLevel = "prosperous";
				
			_asset.label_richness_level_value.text = richnessLevel;
		}
		
		public function set planetVisitedTimes(value:int):void
		{
			
		}
		
		public function set occupied(value:Boolean):void
		{
			
		}
	}
}
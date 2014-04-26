package space_digger.levels 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class LevelPlanet extends GameLevel
	{
		public function LevelPlanet(_level:MovieClip) 
		{
			super(_level);
			level = _level;
		}
		
		public override function initialize():void
		{
			super.initialize();
		}
		
		public override function update(timeDelta:Number):void
		{
			super.update(timeDelta);
		}
	}
}
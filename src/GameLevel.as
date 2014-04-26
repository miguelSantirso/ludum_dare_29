package
{
	import citrus.core.CitrusObject;
	import citrus.core.State;
	import citrus.math.MathVector;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import traps.TrapSpikes;
	
	import space_digger.PlayerCharacter;
	
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class GameLevel extends State
	{
		protected var level:MovieClip;
		
		public function GameLevel(_level:MovieClip) 
		{
			super();
			level = _level;
		}
		
		override public function initialize():void
		{
			super.initialize();
		}
		
		public override function update(timeDelta:Number):void
		{
			super.update(timeDelta);
		}
	}
}
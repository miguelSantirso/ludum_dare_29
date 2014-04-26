package
{
	import citrus.core.CitrusObject;
	import citrus.core.State;
	import citrus.math.MathVector;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	import traps.TrapSpikes;
	import citrus.utils.objectmakers.ObjectMaker2D;
	import citrus.physics.box2d.Box2D;
	
	import space_digger.PlayerCharacter;
	
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class GameLevel extends State
	{
		protected var level:MovieClip;
		public var lvlEnded:Signal;
		public var lvlBack:Signal;
		public var restartLevel:Signal;
		public var changeLevel:Signal;
		
		public function GameLevel(_level:MovieClip) 
		{
			super();
			
			level = _level;
			lvlEnded = new Signal();
			lvlBack = new Signal();
			restartLevel = new Signal();
			changeLevel = new Signal();
		}
		
		override public function initialize():void
		{
			super.initialize();

			var physics:Box2D = new Box2D("physics");
			physics.timeStep = 1 / 15.0;
			physics.visible = Main.DEBUG;
			add(physics);
			
			ObjectMaker2D.FromMovieClip(level);
		}
		
		public override function update(timeDelta:Number):void
		{
			super.update(timeDelta);
		}
		
		public function dispose():void
		{
			removeChild(level);
		}
	}
}
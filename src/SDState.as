package
{
	import citrus.core.CitrusObject;
	import citrus.core.State;
	import citrus.math.MathVector;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	import citrus.utils.objectmakers.ObjectMaker2D;
	import citrus.physics.box2d.Box2D;
	
	import space_digger.PlayerCharacter;
	
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class SDState extends State
	{
		public var lvlEnded:Signal;
		public var lvlBack:Signal;
		public var restartLevel:Signal;
		public var changeLevel:Signal;
		
		public function SDState() 
		{
			super();
			
			lvlEnded = new Signal();
			lvlBack = new Signal();
			restartLevel = new Signal();
			changeLevel = new Signal();
		}
		
		public function enableInput():void
		{
			mouseEnabled = true;
			mouseChildren = true;
			//_input.enabled = true;
		}
		
		public function disableInput():void
		{
			mouseEnabled = false;
			mouseChildren = false;
			//_input.enabled = false;
		}
	}
}
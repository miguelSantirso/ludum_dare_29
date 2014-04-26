package levels 
{
	import citrus.core.State;
	import citrus.physics.box2d.Box2D;
	import flash.display.MovieClip;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.platformer.box2d.Coin;
	import citrus.objects.platformer.box2d.Cannon;
	import citrus.utils.objectmakers.ObjectMaker2D;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class Level2 extends State
	{
		protected var level:MovieClip;
		
		public function Level2(_level:MovieClip) 
		{
			super();
			level = _level;
			
			var objectsUsed:Array = [Hero, Platform, Coin, Cannon];
		}
		
		override public function initialize():void
		{
			/*super.initialize()
	 
			var physics:Box2D = new Box2D("physics");
			physics.timeStep = 1 / 30.0;
			physics.visible = true;
			add(physics);
	 
			ObjectMaker2D.FromMovieClip(level);*/
			
			// prueba para obtener objetos de la escena:
			//var hero:Hero = getObjectByName("hero") as Hero;
			//hero.acceleration = 0.2;
		}
	}

}
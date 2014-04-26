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
	
	import space_digger.PlayerCharacter;
	
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class Level1 extends State
	{
		protected var level:MovieClip;
		
		public function Level1(_level:MovieClip) 
		{
			super();
			level = _level;
			
			var objectsUsed:Array = [Hero, Platform, Coin, Cannon, PlayerCharacter];
		}
		
		override public function initialize():void
		{
			super.initialize()
	 
			var physics:Box2D = new Box2D("physics");
			physics.timeStep = 1 / 15.0;
			physics.visible = true;
			add(physics);
	 
			ObjectMaker2D.FromMovieClip(level);
			
			addChild(level);
			
			// prueba para obtener objetos de la escena:
			//var hero:Hero = getObjectByName("hero") as Hero;
			//hero.acceleration = 0.2;
		}
	}

}
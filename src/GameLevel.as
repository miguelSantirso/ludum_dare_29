package
{
	import citrus.core.State;
	import citrus.objects.platformer.box2d.Sensor;
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
	public class GameLevel extends State
	{
		protected var level:MovieClip;
		protected var sensors:Array;
		
		public static const SPIKES:String = "spikes";
		
		public function GameLevel(_level:MovieClip) 
		{
			super();
			level = _level;
			
			var objectsUsed:Array = [Hero, Platform, Coin, Cannon, PlayerCharacter];
		}
		
		override public function initialize():void
		{
			super.initialize();
	 
			var physics:Box2D = new Box2D("physics");
			physics.timeStep = 1 / 15.0;
			physics.visible = false;
			add(physics);
	 
			ObjectMaker2D.FromMovieClip(level);
			
			refreshView();
		}
		
		public function refreshView():void
		{
			if (level)
			{
				var child:MovieClip;
				var sensor:Sensor;
				
				while (level.numChildren > 0)
				{
					child = level.getChildAt(0) as MovieClip;
					level.removeChildAt(0);
					
					if (child)
					{
						if ((child.x > -child.width * 0.5 && child.x < stage.stageWidth + child.width * 0.5) &&
							(child.y > -child.height * 0.5 && child.y < stage.stageHeight + child.height * 0.5))
							addChild(child);
							
						if (child.name.indexOf(SPIKES) > -1)
						{
							//sensor = getObjectByName("") as Sensor;
							//sensor = ge
							//sensors.push(child);
						}
					}
				}
			}
		}
	}
}
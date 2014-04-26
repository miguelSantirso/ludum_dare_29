package
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
	public class GameLevel extends State
	{
		protected var level:MovieClip;
		
		public function GameLevel(_level:MovieClip) 
		{
			super();
			level = _level;
			
			var objectsUsed:Array = [Hero, Platform, Coin, Cannon];
		}
		
		override public function initialize():void
		{
			super.initialize()
	 
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
				
				while (level.numChildren > 0)
				{
					child = level.getChildAt(0) as MovieClip;
					level.removeChildAt(0);
					
					if (child)
					{
						if ((child.x > -child.width * 0.5 && child.x < stage.stageWidth + child.width * 0.5) &&
							(child.y > -child.height * 0.5 && child.y < stage.stageHeight + child.height * 0.5))
							addChild(child);
					}
				}
			}
		}
	}
}
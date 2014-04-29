package space_digger 
{
	import citrus.objects.CitrusSprite;
	import space_digger.levels.LevelDig;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SpaceShip extends CitrusSprite 
	{
		private var _frameCounter:int = 0;
		public function SpaceShip(name:String, params:Object=null) 
		{
			super(name, params);
			
			updateCallEnabled = true;
			_animation = "enter";
		}
		
		
		override public function update(timeDelta:Number):void 
		{
			super.update(timeDelta);
			
			if (_animation == "enter" && ++_frameCounter >= 121)
			{
				_animation = "idle";
				(_ce.state as LevelDig).startExploration();
			}
			
			if (_animation == "exit" && ++_frameCounter >= 99)
			{
				_animation = "Empty";
				(_ce.state as LevelDig).endMission();
			}
		}
		
		
		public function leave():void
		{
			_animation = "exit";
			_frameCounter = 0;
		}
		
	}

}
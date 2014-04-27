package space_digger 
{
	import citrus.objects.CitrusSprite;
	
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
				_animation = "idle";
		}
		
	}

}
package space_digger 
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class PlayerCharacter extends CustomHero 
	{
		
		private var _nLifes:int = 3;
		
		public function PlayerCharacter(name:String, params:Object=null) 
		{
			super(name, params);
			
			minVelocityY = -10;
			group = 1;
			
			onTakeDamage.add(onDamageTaken);
			
		}
		
		override public function update(timeDelta:Number):void 
		{
			if (_nLifes >= 0)
				super.update(timeDelta);
			
		}
		
		private function onDamageTaken():void
		{
			if (--_nLifes < 0)
			{
				_animation = "defeat";
			}
		}
		
	}

}
package space_digger 
{
	import Box2D.Dynamics.Contacts.b2Contact;
	import flash.utils.setTimeout;
	
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
		
		public function get isDead():Boolean
		{
			return _nLifes < 0;
		}
		
		override public function handleBeginContact(contact:b2Contact):void 
		{
			if (!isDead)
				super.handleBeginContact(contact);
		}
		
		private function onDamageTaken():void
		{
			--_nLifes;
			
			if (isDead)
			{
				_animation = "defeat";
				updateCallEnabled = false;
				setTimeout(function():void {
					_animation = "dead";
				}, 2700);
			}
		}
		
	}

}
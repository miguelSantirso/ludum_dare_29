package space_digger 
{
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.objects.platformer.box2d.Sensor;
	import flash.utils.setTimeout;
	import citrus.physics.box2d.Box2DUtils;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Seam extends Sensor 
	{
		private var _playerInArea:Boolean = false;
		private var _working:Boolean = false;
		private var _serverId:int;
		
		public function Seam(name:String, params:Object=null) 
		{
			super("seam", params);
			
			var nameComponents:Array = name.split('_');
			if (nameComponents.length != 2 || nameComponents[0] != "seam")
			{
				throw new Error("Incorrectly named seam");
			}
			
			_serverId = (nameComponents[1] as int);
		}
		
		override public function update(timeDelta:Number):void 
		{
			super.update(timeDelta);
			
			if (_playerInArea && _ce.input.justDid("attack"))
			{
				_working = true;
				
				_animation = "appears";
				setTimeout(function():void {
					_animation = "idle2";
				}, 2000);
			}
		}
		
		override public function handleBeginContact(contact:b2Contact):void 
		{
			super.handleBeginContact(contact);
			
			if (Box2DUtils.CollisionGetOther(this, contact) is PlayerCharacter) {
				_playerInArea = true;
				updateCallEnabled = true;
				if (!_working) _animation = "glow";
			}
		}
		
		
		override public function handleEndContact(contact:b2Contact):void 
		{
			super.handleEndContact(contact);
			
			if (Box2DUtils.CollisionGetOther(this, contact) is PlayerCharacter)
			{
				_playerInArea = false;
				if (!_working) _animation = "idle";
			}
		}
		
	}

}
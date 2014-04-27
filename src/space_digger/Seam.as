package space_digger 
{
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.objects.platformer.box2d.Sensor;
	import flash.utils.setTimeout;
	import citrus.physics.box2d.Box2DUtils;
	import space_digger.levels.LevelDig;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Seam extends Sensor 
	{
		private static const MAX_LIFES:int = 10;
		
		private var _playerInArea:Boolean = false;
		private var _working:Boolean = false;
		private var _lifes:int = MAX_LIFES;
		private var _levelIndex:int;
		private var _serverId:int;
		
		private var _hack_damageSignalAdded:Boolean = false;
		
		public function Seam(name:String, params:Object=null) 
		{
			super("seam", params);
			
			var nameComponents:Array = name.split('_');
			if (nameComponents.length != 2 || nameComponents[0] != "seam")
			{
				throw new Error("Incorrectly named seam");
			}
			
			_levelIndex = (nameComponents[1] as int);
		}
		
		private function onPlayerDealDamage():void
		{
			if (!_playerInArea) return;
			
			if (_working)
			{
				if (--_lifes < 0)
					breakMachine();
			}
			else appear();
		}
		
		private function breakMachine():void
		{
			_working = false;
			
			(_ce.state as LevelDig).diggingSession.destroySeamMachine(_serverId);
			
			_animation = "defeat";
			setTimeout(function():void {
				_animation = "idle";
			}, 400);
		}
		
		private function appear():void
		{
			_working = true;
			_lifes = MAX_LIFES;
			
			(_ce.state as LevelDig).diggingSession.deploySeamMachine(_serverId);
			
			_animation = "appears";
			setTimeout(function():void {
				_animation = "idle2";
			}, 1900);
		}
		
		override public function handleBeginContact(contact:b2Contact):void 
		{
			super.handleBeginContact(contact);
			
			var player:PlayerCharacter = Box2DUtils.CollisionGetOther(this, contact) as PlayerCharacter;
			if (player)
			{
				if (!_hack_damageSignalAdded)
				{
					player.onGiveDamage.add(onPlayerDealDamage);
					_hack_damageSignalAdded = true;
				}
				
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
package space_digger 
{
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.objects.platformer.box2d.Sensor;
	import data.SeamData;
	import flash.utils.setTimeout;
	import citrus.physics.box2d.Box2DUtils;
	import space_digger.levels.LevelDig;
	import data.SeamState;
	import managers.DataManager;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Seam extends Sensor 
	{
		private static const MAX_LIFES:int = 5;
		
		private var _playerInArea:Boolean = false;
		private var _machineInPlace:Boolean = false;
		private var _lifes:int = MAX_LIFES;
		public function get index():int { return _index; }
		private var _index:int;
		private var _owner:String = "unclaimed";
		
		private var _hack_damageSignalAdded:Boolean = false;
		
		public function get hudRef():GameplayHud
		{
			return (_ce.state as LevelDig).hud;
		}
		
		public function Seam(name:String, params:Object=null) 
		{
			super("seam", params);
			
			/*width = 36;
			height = 67;
			offsetX = 115;
			offsetY = 2;*/
			
			var nameComponents:Array = name.split('_');
			if (nameComponents.length != 2 || nameComponents[0] != "seam")
			{
				throw new Error("Incorrectly named seam");
			}
			
			_index = int(nameComponents[1]);
		}
		
		public function init(seamData:SeamData):void
		{
			_owner = "unclaimed";
			
			if (seamData.state == SeamState.MINING)
			{
				_machineInPlace = true;
				_animation = "idle2";
				_owner = seamData.owner.name;
			}
			else if (seamData.state == SeamState.BROKEN)
			{
				_machineInPlace = true;
				_animation = "stopped";
				_owner = seamData.owner.name;
			}
		}
		
		public function setOwner(owner:String):void
		{
			if (owner)
			{
				
			}
		}
		
		private function onPlayerDealDamage():void
		{
			if (!_playerInArea) return;
			
			if (_machineInPlace)
			{
				if (--_lifes <= 0)
				{
					breakMachine();
				}
				else
					hudRef.showMineralHud(_owner, (_lifes / MAX_LIFES) * 100);
			}
			else 
				appear();
		}

		private function breakMachine():void
		{
			// INSERT_SOUND MAQUINA DESTRUIDA
			_ce.sound.playSound("DestroySeam");
			
			_machineInPlace = false;
			
			(_ce.state as LevelDig).destroySeamMachine(_index);
			
			_animation = "defeat";
			setTimeout(function():void {
				_animation = "idle";
				appear();
			}, 400);
		}
		
		private function appear():void
		{
			_machineInPlace = true;
			_lifes = MAX_LIFES;
			
			(_ce.state as LevelDig).deploySeamMachine(_index);
			
			_owner = DataManager.getInstance().myState.company ? DataManager.getInstance().myState.company.name : "It's 'mine'";
			hudRef.showMineralHud(_owner, (_lifes / MAX_LIFES) * 100);
			hudRef.hideClaimHint();
			
			// INSERT_SOUND MAQUINA DEPLOYADA
			_ce.sound.playSound("Deploy");
			
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
				hudRef.showMineralHud(_owner, (_lifes / MAX_LIFES) * 100);
				if (!_machineInPlace) hudRef.showClaimHint();
				
				if (!_hack_damageSignalAdded)
				{
					player.onGiveDamage.add(onPlayerDealDamage);
					_hack_damageSignalAdded = true;
				}
				
				_playerInArea = true;
				updateCallEnabled = true;
				if (!_machineInPlace) _animation = "glow";
			}
		}
		
		
		override public function handleEndContact(contact:b2Contact):void 
		{
			super.handleEndContact(contact);
			
			if (Box2DUtils.CollisionGetOther(this, contact) is PlayerCharacter)
			{
				if ((_ce.state is LevelDig))
				{
					hudRef.hideClaimHint();
					hudRef.hideMineralHud();
				}
				
				_playerInArea = false;
				if (!_machineInPlace) _animation = "idle";
			}
		}
		
	}

}
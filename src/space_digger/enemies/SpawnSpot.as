package space_digger.enemies 
{
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Enemy;
	import space_digger.enemies.EnemyType;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SpawnSpot extends CitrusSprite
	{
		public var onDeadFoe:Signal = new Signal();
		
		private var _elapsedTime:Number = 0;
		private var _nextSpawnTime:Number = 0;
		private var _enemyType:EnemyType;
		private var _CntFoes:int = 0;
		
		private static const MAX_FOES:int = 5;
		private static const SPAWN_TIME:int = 5;
		
		public function SpawnSpot(name:String, params:Object=null) 
		{
			super("spawn", params);
			
			var nameComponents:Array = name.split('_');
			if (nameComponents.length != 2 || nameComponents[0] != "spawn")
			{
				throw new Error("Incorrectly named spawn");
			}
			
			_serverId = (nameComponents[1] as int);
			
			_enemyType = type;
		}
		
		public function addFoe(foe:Foe):void
		{
			_ce.stage.addChild(foe);
			foe.justHurt.add(removeFoe);
			foe.updateCallEnabled = true;
			
			// Update the spawn spot data
			++_CntFoes;
			_nextSpawnTime = _elapsedTime + SPAWN_TIME;
		}
		
		public function removeFoe():void
		{
			--_CntFoes;
		}
		
		override public function update(timeDelta:Number):void
		{
			_elapsedTime += timeDelta;
			
			if (MAX_FOES <= _CntFoes)
				return;
				
			if (_elapsedTime < _nextSpawnTime)
				return;
			
			switch(_enemyType)
			{
				case EnemyType.PATROL:
				{
					addFoe(new Patrol());
					break;
				}
				case EnemyType.CREEPER:
				{
					addFoe(new Creeper());
					break;
				}
				case EnemyType.SPIKE:
				{
					addFoe(new Spike());
					break;
				}
			}

		}
	}

}
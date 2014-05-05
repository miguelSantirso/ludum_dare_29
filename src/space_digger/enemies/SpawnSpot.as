package space_digger.enemies 
{
	import Box2D.Collision.b2Distance;
	import citrus.objects.CitrusSprite;
	import flash.geom.Point;
	import org.osflash.signals.Signal;
	import space_digger.enemies.EnemyType;
	import space_digger.PlayerCharacter;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SpawnSpot extends CitrusSprite
	{
		public var onDeadFoe:Signal = new Signal();
		
		private var _elapsedTime:Number = 0;
		private var _nextSpawnTime:Number = 0;
		private var _enemyType:int;
		private var _CntFoes:int = 0;
		private var _player:PlayerCharacter;
		private var _player_pos:Point;
		private var _spawnspot_pos:Point;
		
		private static const MAX_FOES:int = 1;
		private static const SPAWN_TIME:int = 5;
		
		public function SpawnSpot(name:String, params:Object=null) 
		{
			super("spawn", params);
			
			view = "hueco";
			group = 0;
			
			var nameComponents:Array = name.split('_');
			if (nameComponents.length != 2 || nameComponents[0] != "spawn")
			{
				throw new Error("Incorrectly named spawn");
			}
			
			updateCallEnabled = true;
			
			_enemyType = EnemyType.fromString(nameComponents[1]);
			
			_player_pos = new Point();
			
			_spawnspot_pos = new Point();
			_spawnspot_pos.x = this.x;
			_spawnspot_pos.y = this.y;
		}
		
		public function addFoe(foe:Foe):void
		{
			_ce.state.add(foe);
			foe.x = x; foe.y = y;
			foe.justHurt.add(removeFoe);
			foe.updateCallEnabled = true;
			
			// Update the spawn spot data
			++_CntFoes;
			_nextSpawnTime = _elapsedTime + SPAWN_TIME;
		}
		
		public function removeFoe():void
		{
			--_CntFoes;
			_elapsedTime = 0;
		}
		
		override public function update(timeDelta:Number):void
		{
			_elapsedTime += timeDelta;
			
			if (MAX_FOES <= _CntFoes)
				return;
				
			if (_nextSpawnTime!= 0 && _elapsedTime < _nextSpawnTime)
				return;

			if (!_player)
			{
				_player = _ce.state.getObjectByName("player_char") as PlayerCharacter;
			}
			
			_player_pos.x = _player.x;
			_player_pos.y = _player.y;
			
			if (Point.distance(_player_pos, _spawnspot_pos) <= 300)
			{
				_nextSpawnTime = _elapsedTime + SPAWN_TIME;
				return;
			}
			
			switch(_enemyType)
			{
				case EnemyType.PATROL:
				{
					addFoe(new Patrol(""));
					break;
				}
				case EnemyType.CREEPER:
				{
					addFoe(new Creeper(""));
					break;
				}
				case EnemyType.SPIKE:
				{
					addFoe(new Spike(""));
					break;
				}
				case EnemyType.FIRE1:
				{
					addFoe(new Fire1(""));
					break;
				}
				case EnemyType.FIRE2:
				{
					addFoe(new Fire2(""));
					break;
				}
				case EnemyType.FOREST1:
				{
					addFoe(new Forest1(""));
					break;
				}
				case EnemyType.FOREST2:
				{
					addFoe(new Forest2(""));
					break;
				}
				case EnemyType.HAPPY1:
				{
					addFoe(new Happy1(""));
					break;
				}
				case EnemyType.HAPPY2:
				{
					addFoe(new Happy2(""));
					break;
				}
				case EnemyType.WATER1:
				{
					addFoe(new Water1(""));
					break;
				}
				case EnemyType.WATER2:
				{
					addFoe(new Water2(""));
					break;
				}
			}

		}
	}

}
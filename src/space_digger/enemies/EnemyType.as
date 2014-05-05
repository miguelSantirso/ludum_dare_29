package space_digger.enemies 
{
	/**
	 * ...
	 * @author ...
	 */
	public class EnemyType 
	{
		public static const PATROL:int = 0;
		public static const CREEPER:int = 1;
		public static const SPIKE:int = 2;
		public static const FIRE1:int = 3;
		public static const FIRE2:int = 4;
		public static const FOREST1:int = 5;
		public static const FOREST2:int = 6;
		public static const HAPPY1:int = 7;
		public static const HAPPY2:int = 8;
		public static const WATER1:int = 9;
		public static const WATER2:int = 10;
		
		public static function fromString(value:String):int
		{
			if (value == 'spike')
				return SPIKE;
			else if (value == 'ice2')
				return CREEPER;
			else if (value == 'fire1')
				return FIRE1;
			else if (value == 'fire2')
				return FIRE2;
			else if (value == 'forest1')
				return FOREST1;
			else if (value == 'forest2')
				return FOREST2;
			else if (value == 'happy1')
				return HAPPY1;
			else if (value == 'happy2')
				return HAPPY2;
			else if (value == 'water1')
				return WATER1;
			else if (value == 'water2')
				return WATER2;
			return PATROL;
		}
	}
}
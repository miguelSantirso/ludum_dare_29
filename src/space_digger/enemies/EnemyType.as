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
		
		public static function fromString(value:String):int
		{
			if (value == 'spike')
				return SPIKE;
			else if (value == 'creeper')
				return CREEPER;
			
			return PATROL;
		}
	}
}
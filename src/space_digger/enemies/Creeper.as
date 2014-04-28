package space_digger.enemies 
{
	import space_digger.levels.LevelDig;

	/**
	 * ...
	 * @author ...
	 */
	public class Creeper extends Patrol
	{
		private static var DETECTION_RANGE:int = 350;
		
		public function Creeper(name:String, params:Object=null) 
		{	
			super(name, params);
			
			view = "IceCreeper";
			height = 63;
			width = 64;
			offsetY = -16;

			(_ce.state as LevelDig).startedDigging.add(onDigStart);
			
			turnAround();
		}

		public function onDigStart(playerX:Number, playerY:Number):void
		{
		}
	}
}
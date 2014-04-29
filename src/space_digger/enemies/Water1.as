package space_digger.enemies 
{
	/**
	 * ...
	 * @author oforcat
	 */
	public class Water1 extends Patrol 
	{
		
		public function Water1(name:String, params:Object=null) 
		{
			super(name, params);
			
			view = "WaterEnemy";
			height = 30;
			width = 30;
			offsetY = -10;
		}
		
	}

}
package space_digger.enemies 
{
	/**
	 * ...
	 * @author oforcat
	 */
	public class Forest1 extends Patrol 
	{
		
		public function Forest1(name:String, params:Object=null) 
		{
			super(name, params);
			
			view = "ForestEnemy";
			height = 30;
			width = 35;
			offsetY = -12;
		}
		
	}

}
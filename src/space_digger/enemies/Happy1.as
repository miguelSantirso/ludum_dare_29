package space_digger.enemies 
{
	/**
	 * ...
	 * @author oforcat
	 */
	public class Happy1 extends Patrol 
	{
		
		public function Happy1(name:String, params:Object=null) 
		{
			super(name, params);
			
			view = "HappyEnemy";
			height = 30;
			width = 30;
			offsetY = -10;
		}
		
	}

}
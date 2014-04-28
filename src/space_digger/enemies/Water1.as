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
			
			view = "HappyEnemy";
			height = 45;
			width = 50;
		}
		
	}

}
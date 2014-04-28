package space_digger.enemies 
{
	/**
	 * ...
	 * @author oforcat
	 */
	public class Fire1 extends Patrol 
	{
		
		public function Fire1(name:String, params:Object=null) 
		{
			super(name, params);
			
			view = "FireEnemy";
			height = 45;
			width = 50;
		}
		
	}

}
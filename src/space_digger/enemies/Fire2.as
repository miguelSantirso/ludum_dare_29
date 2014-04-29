package space_digger.enemies 
{
	/**
	 * ...
	 * @author oforcat
	 */
	public class Fire2 extends Patrol 
	{
		
		public function Fire2(name:String, params:Object=null) 
		{
			super(name, params);
			
			view = "FireCreeper";
			height = 50;
			width = 40;
			offsetY = -25;
			offsetX = -5;
		}
		
	}

}
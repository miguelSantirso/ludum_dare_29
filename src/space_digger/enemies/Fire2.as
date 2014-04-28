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
			height = 63;
			width = 64;
			offsetY = -16;
		}
		
	}

}
package space_digger.enemies 
{
	/**
	 * ...
	 * @author oforcat
	 */
	public class Water2 extends Patrol 
	{
		
		public function Water2(name:String, params:Object=null) 
		{
			super(name, params);
			
			view = "WaterCreeper";
			height = 63;
			width = 60;
			offsetY = -30;
		}
		
	}

}
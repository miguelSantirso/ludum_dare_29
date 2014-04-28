package space_digger.enemies 
{
	/**
	 * ...
	 * @author oforcat
	 */
	public class Happy2 extends Patrol 
	{
		
		public function Happy2(name:String, params:Object=null) 
		{
			super(name, params);
			
			view = "HappyCreeper";
			height = 63;
			width = 64;
			offsetY = -16;
		}
		
	}

}
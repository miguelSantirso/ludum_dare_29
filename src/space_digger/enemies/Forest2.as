package space_digger.enemies 
{
	/**
	 * ...
	 * @author oforcat
	 */
	public class Forest2 extends Creeper 
	{
		
		public function Forest2(name:String, params:Object=null) 
		{
			super(name, params);
			
			view = "ForestCreeper";
			height = 63;
			width = 30;
			offsetX = -10;
			offsetY = -16;
		}
		
	}

}
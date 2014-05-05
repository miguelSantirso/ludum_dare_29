package space_digger.enemies 
{
	/**
	 * ...
	 * @author oforcat
	 */
	public class Happy2 extends Creeper 
	{
		
		public function Happy2(name:String, params:Object=null) 
		{
			super(name, params);
			
			view = "HappyCreeper";
			height = 60;
			width = 40;
			offsetY = -20;
			offsetX = -15;
		}
		
	}

}
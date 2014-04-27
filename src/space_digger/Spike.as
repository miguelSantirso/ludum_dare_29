package space_digger 
{
	import citrus.objects.platformer.box2d.Enemy;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Spike extends Enemy 
	{
		
		public function Spike(name:String, params:Object=null) 
		{
			super(name, params);
			
			speed = 0;
		}
		
	}

}
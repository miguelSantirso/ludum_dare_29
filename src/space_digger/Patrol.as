package space_digger 
{
	import citrus.objects.platformer.box2d.Enemy;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Patrol  extends Enemy
	{
		public function Patrol(name:String, params:Object=null) 
		{
			super(name, params);
			
			speed = 1.0;
		}
	}

}
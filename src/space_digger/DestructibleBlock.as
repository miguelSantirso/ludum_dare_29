package space_digger 
{
	import citrus.objects.platformer.box2d.Platform;
	
	/**
	 * ...
	 * @author ...
	 */
	public class DestructibleBlock extends Platform 
	{
		
		public function DestructibleBlock(name:String, params:Object=null) 
		{
			super(name, params);
			
		}
		
		/**
		 * Override this method to handle the begin contact collision.
		 */
		override public function handleBeginContact(contact:b2Contact):void {
			super.destroy();
		}
	}

}
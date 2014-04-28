package space_digger 
{
	import citrus.objects.platformer.box2d.Platform;
	import flash.utils.setTimeout;
	
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
		
		public function explode():void
		{
			_animation = "explosion";
			
			// INSERT_SOUND BLOQUE DESTRUIDO
			
			setTimeout(function():void {
				die();
			}, 500);
		}
		
		public function die():void
		{
			_animation = "dead";
			
			super.destroy();
		}
	}

}
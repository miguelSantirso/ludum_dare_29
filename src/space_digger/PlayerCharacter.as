package space_digger 
{
	import citrus.objects.platformer.box2d.Hero;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PlayerCharacter extends Hero 
	{
		
		public function PlayerCharacter(name:String, params:Object=null) 
		{
			super(name, params);
			offsetY = -5;
		}
		
	}

}
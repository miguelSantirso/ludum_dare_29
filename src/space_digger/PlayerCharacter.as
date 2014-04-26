package space_digger 
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class PlayerCharacter extends CustomHero 
	{
		
		public function PlayerCharacter(name:String, params:Object=null) 
		{
			super(name, params);
			offsetY = -9;
			
			minVelocityY = -3;
		}
		
	}

}
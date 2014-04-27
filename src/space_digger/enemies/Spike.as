package space_digger.enemies 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Spike extends Foe 
	{
		
		public function Spike(name:String, params:Object=null) 
		{
			super(name, params);
			
			speed = 0;
			enemyKillVelocity = 10000;
		}

		override public function  hurt():void {

			// Hurting spikes is not allowed
		}
	}

}

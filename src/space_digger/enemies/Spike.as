package space_digger.enemies 
{
	import Box2D.Common.Math.b2Vec2;
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
		
		override public function update(timeDelta:Number):void
		{	
			super.update(timeDelta);
			
			var velocity:b2Vec2 = _body.GetLinearVelocity();
			velocity.x =  speed;
		}
	}

}

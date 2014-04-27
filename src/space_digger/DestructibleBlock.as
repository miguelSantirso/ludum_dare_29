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
			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);

			if (_body.GetLinearVelocity().x < 0 && (contact.GetFixtureA() == _rightSensorFixture || contact.GetFixtureB() == _rightSensorFixture))
				return;

			if (_body.GetLinearVelocity().x > 0 && (contact.GetFixtureA() == _leftSensorFixture || contact.GetFixtureB() == _leftSensorFixture))
				return;

			if (contact.GetManifold().m_localPoint) {

				var normalPoint:Point = new Point(contact.GetManifold().m_localPoint.x, contact.GetManifold().m_localPoint.y);
				var collisionAngle:Number = new MathVector(normalPoint.x, normalPoint.y).angle * 180 / Math.PI;

				if (collider is PlayerCharacter)
				{
					super.destroy();
				}
			}
		}
	}

}
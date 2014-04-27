package space_digger 
{
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.math.MathVector;
	import flash.geom.Point;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	
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
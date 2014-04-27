package space_digger 
{
	import Box2D.Collision.b2Manifold;
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
	}

}
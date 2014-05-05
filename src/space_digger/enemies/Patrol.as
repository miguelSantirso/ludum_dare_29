package space_digger.enemies 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.math.MathVector;
	import flash.geom.Point;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	import space_digger.PlayerCharacter;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Patrol extends Foe
	{
		public function Patrol(name:String, params:Object=null) 
		{
			super(name, params);
			
			view = "IceEnemy";
			height = 45;
			width = 50;
			
			speed = 1.0;
		}
		
		override public function update(timeDelta:Number):void
		{	
			super.update(timeDelta);
			
			var position:b2Vec2 = _body.GetPosition();
			
			//Turn around when they pass their left/right bounds
			if ((_inverted && position.x * _box2D.scale < leftBound) || (!_inverted && position.x * _box2D.scale > rightBound))
				turnAround();
			
			var velocity:b2Vec2 = _body.GetLinearVelocity();
			
			if (!_hurt)
				velocity.x = _inverted ? -speed : speed;
			else
				velocity.x = 0;
			
			updateAnimation();
		}
		
		override public function handleBeginContact(contact:b2Contact):void {

			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);
			
			if (_body.GetLinearVelocity().x < 0 && (contact.GetFixtureA() == _rightSensorFixture || contact.GetFixtureB() == _rightSensorFixture))
				return;

			if (_body.GetLinearVelocity().x > 0 && (contact.GetFixtureA() == _leftSensorFixture || contact.GetFixtureB() == _leftSensorFixture))
				return;

			if (contact.GetManifold().m_localPoint) {

				var normalPoint:Point = new Point(contact.GetManifold().m_localPoint.x, contact.GetManifold().m_localPoint.y);
				var collisionAngle:Number = new MathVector(normalPoint.x, normalPoint.y).angle * 180 / Math.PI;

				if ((collider is Platform && collisionAngle != 90))
					turnAround();
				else if (collider is Sensor)
					turnAround();
				else if (collider is Foe)
					turnAround();
				else if (collider is PlayerCharacter)
				{
					var player:PlayerCharacter = _ce.state.getObjectByName("player_char") as PlayerCharacter;
					if (player.isDead)
					{
						turnAround();
					}
				}
			}
		}
	}

}
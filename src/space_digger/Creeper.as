package space_digger 
{
	import adobe.utils.CustomActions;
	import citrus.objects.platformer.box2d.Enemy;
	import space_digger.levels.LevelDig;
	import space_digger.PlayerCharacter;
	import Box2D.Common.Math.b2Math;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Collision.Shapes.b2Shape;
	import citrus.input.controllers.Keyboard;
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
	public class Creeper extends Enemy
	{
		public var inputChannel:uint = 0;
		private var _facingRight:Boolean = true;
		private var _velocity:b2Vec2;
		private static var DETECTION_RANGE:int = 100;
		
		public function Creeper(name:String, params:Object=null) 
		{	
			super(name, params);
		
			_facingRight = (startingDirection == "right") ? true : false;

			(_ce.state as LevelDig).startedDigging.add(onDigStart);
			
			//_ce.input.keyboard.addKeyAction("test", Keyboard.G, inputChannel);
		}
		
		override public function update(timeDelta:Number):void {

			super.update(timeDelta);

			/*
			if (_ce.input.justDid("test", inputChannel))
			{
				onDigStart();
			}
			*/
			/*
			if (_ce.input.hasDone("test"))
			{
				onDigEnd();
			}
			*/
		}
		
		/**
		 * Change enemy's direction
		 */
		override public function  turnAround():void {

			_inverted = !_inverted;
			_facingRight = !_facingRight;
		}
		
		public function chasePlayer(flag:Boolean):void
		{		
			body.SetLinearVelocity(new b2Vec2((flag) ? 3.0 : 0.0, body.GetLinearVelocity().y));
		}
		
		public function onDigStart(playerX:int, playerY:int):void
		{
			var dist:int = playerX * playerX + playerY * playerY;
			
			if (dist < DETECTION_RANGE)
			{
				var dx:Number = playerX - x;
				
				if (dx < 0) 
				{
					if (_facingRight) turnAround();
				}
				else
				{
					if (!_facingRight) turnAround();
				}
				
				chasePlayer(true);
			}
		}
		
		public function onDigEnd():void
		{
			//chasePlayer(false);
		}
		
		override public function handleBeginContact(contact:b2Contact):void {

			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);

			if (collider is _enemyClass && collider.body.GetLinearVelocity().y > enemyKillVelocity)
				hurt();

			if (_body.GetLinearVelocity().x < 0 && (contact.GetFixtureA() == _rightSensorFixture || contact.GetFixtureB() == _rightSensorFixture))
				return;

			if (_body.GetLinearVelocity().x > 0 && (contact.GetFixtureA() == _leftSensorFixture || contact.GetFixtureB() == _leftSensorFixture))
				return;

			if (contact.GetManifold().m_localPoint) {

				var normalPoint:Point = new Point(contact.GetManifold().m_localPoint.x, contact.GetManifold().m_localPoint.y);
				var collisionAngle:Number = new MathVector(normalPoint.x, normalPoint.y).angle * 180 / Math.PI;

				if ((collider is Platform && collisionAngle != 90))
					chasePlayer(false);
				else if (collider is Enemy)
					turnAround();
			}
		}
	}

}
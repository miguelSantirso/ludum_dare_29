package space_digger.enemies 
{
	import adobe.utils.CustomActions;
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
	import space_digger.PlayerCharacter;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Creeper extends Foe
	{
		public var inputChannel:uint = 0;
		private var _facingRight:Boolean = true;
		private var _chasing:Boolean = false;
		private var _chasingTarget:b2Vec2 = new b2Vec2();
		private var _player:PlayerCharacter = null;
		
		private static var DETECTION_RANGE:int = 350;
		
		public function Creeper(name:String, params:Object=null) 
		{	
			super(name, params);
			
			view = "IceCreeper";
			height = 63;
			width = 64;
			offsetY = -16;
		
			_facingRight = (startingDirection == "right") ? true : false;

			(_ce.state as LevelDig).startedDigging.add(onDigStart);
			//_ce.input.keyboard.addKeyAction("test", Keyboard.G, inputChannel);
			
			chasePlayer(false);
			
			_player = _ce.state.getObjectByName("player_char") as PlayerCharacter;
		}

		public function chasePlayer(flag:Boolean):void
		{		
			if (!flag)
				_animation = "idle";
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if (_chasing)
			{
				if ((this.x < _chasingTarget.x && !_facingRight) || (_chasingTarget.x < this.x && _facingRight))
				{
					turnAround();
				}
				
				_animation = "walk";
			}
			else
			{
				stop();
			}
		}

		public function walk():void
		{
			body.SetLinearVelocity(new b2Vec2(3.0, body.GetLinearVelocity().y));
			
			_animation = "walk";			
		}
		public function stop():void
		{
			body.SetLinearVelocity(new b2Vec2(0.0, body.GetLinearVelocity().y));
			
			_animation = "idle";
		}
		
		override public function  turnAround():void
		{
			_inverted = !_inverted;
			_facingRight = !_facingRight;
		}
		
		public function onDigStart(playerX:Number, playerY:Number):void
		{
			// Start chasing the player
			_chasing = true;
			
			_chasingTarget.x = playerX;
			_chasingTarget.y = playerY;
		}
		
		override public function handleBeginContact(contact:b2Contact):void 
		{
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
					stop();
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
		
		/*
		override public function update(timeDelta:Number):void {

			super.update(timeDelta);
		}
		
		override public function  turnAround():void {

			_inverted = !_inverted;
			_facingRight = !_facingRight;
		}
		
		public function chasePlayer(flag:Boolean):void
		{		
			body.SetLinearVelocity(new b2Vec2((flag) ? 3.0 : 0.0, body.GetLinearVelocity().y));
			
			_chasing = flag;
			
			if (!flag)
				_animation = "idle";
		}

		public function onDigStart(playerX:Number, playerY:Number):void
		{
			var dist:Number = b2Math.Distance(new b2Vec2(playerX, playerY), new b2Vec2(x, y));
			
			if (dist < DETECTION_RANGE)
			{
				var dx:Number = playerX - x;
				
				if (dx > 0) 
				{
					if (_facingRight) turnAround();
				}
				else
				{
					if (!_facingRight) turnAround();
				}
				
				chasePlayer(true);
			}
			else {
				chasePlayer(false);
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
		*/
	}

}
package space_digger.enemies 
{
	import Box2D.Common.Math.b2Vec2;
	import space_digger.CustomEnemy;
	import space_digger.levels.LevelDig;

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
	public class Creeper extends Foe
	{
		private static var DETECTION_RANGE:int = 350;
		
		private var _sleeping:Boolean = true;
		private var _player:PlayerCharacter;
		private var _player_pos:Point;
		private var _current_pos:Point;
		
		public function Creeper(name:String, params:Object=null) 
		{	
			super(name, params);
			
			view = "IceCreeper";
			height = 63;
			width = 45;
			offsetY = -16;
			offsetX = -5;

			(_ce.state as LevelDig).startedDigging.add(onDigStart);
			
			//turnAround();
			
			_player_pos = new Point();
			_current_pos = new Point();
		}

		public function onDigStart(playerX:Number, playerY:Number):void
		{
		}
		
		override public function update(timeDelta:Number):void
		{	
			super.update(timeDelta);
			
			var velocity:b2Vec2 = _body.GetLinearVelocity();
			
			if (_sleeping)
			{
				// Check if the foe should be awakened
				checkForNearbyPlayers();
			}
			
			if (!_sleeping)
			{
				var position:b2Vec2 = _body.GetPosition();
				
				//Turn around when they pass their left/right bounds
				if ((_inverted && position.x * _box2D.scale < leftBound) || (!_inverted && position.x * _box2D.scale > rightBound))
					turnAround();
				
				if (!_hurt)
					velocity.x = _inverted ? -speed : speed;
				else
					velocity.x = 0;
					
				_animation = _hurt ? "die" : "walk"; 
			} else {
				
				velocity.x = 0;
				
				_animation = _hurt ? "die" : "idle";
			}
			
			_body.SetLinearVelocity(velocity);
			_body.SetAwake(true);
		}

		private function checkForNearbyPlayers():void
		{
			if (!_player)
			{
				_player = _ce.state.getObjectByName("player_char") as PlayerCharacter;
			}
			
			_player_pos.x = _player.x;
			_player_pos.y = _player.y;
			_current_pos.x = this.x;
			_current_pos.y = this.y;
			
			//_sleeping = (Point.distance(_player_pos, _current_pos) <= 300) ? false : true;
			if (Point.distance(_player_pos, _current_pos) <= 300)
				_sleeping = false;
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
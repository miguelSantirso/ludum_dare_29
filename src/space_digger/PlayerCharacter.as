package space_digger 
{
	import Box2D.Collision.b2Manifold;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.objects.platformer.box2d.Enemy;
	import flash.utils.setTimeout;
	import citrus.input.controllers.Keyboard;
	import citrus.physics.PhysicsCollisionCategories;
	import citrus.physics.box2d.Box2DUtils;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PlayerCharacter extends CustomHero 
	{
		
		private var _nLifes:int = 3;
		private var _attackAnimationFrame:int = 0;
		
		private var _attacking:Boolean = false;
		
		private var _attackSensorDef:b2FixtureDef
		private var _leftSensorFixture:b2Fixture;
		private var _leftSensorShape:b2PolygonShape;
		private var _rightSensorFixture:b2Fixture;
		private var _rightSensorShape:b2PolygonShape;
		
		private var _contactingEnemies:Vector.<Enemy> = new Vector.<Enemy>();
		
		public function PlayerCharacter(name:String, params:Object=null) 
		{
			super(name, params);
			
			minVelocityY = -10;
			group = 1;
			
			onTakeDamage.add(onDamageTaken);
			
			_ce.input.keyboard.addKeyAction("left", Keyboard.A);
			_ce.input.keyboard.addKeyAction("jump", Keyboard.W);
			_ce.input.keyboard.addKeyAction("right", Keyboard.D);
			_ce.input.keyboard.addKeyAction("jump", Keyboard.UP);
			_ce.input.keyboard.addKeyAction("attack", Keyboard.Z);
			_ce.input.keyboard.addKeyAction("attack", Keyboard.J);
		}
		
		override protected function createShape():void 
		{
			super.createShape();
			
			var sensorWidth:Number = 35 / _box2D.scale;
			var sensorHeight:Number = 2 / _box2D.scale;
			var sensorOffset:b2Vec2 = new b2Vec2( -_width / 2 - (sensorWidth / 2), _height / 2 - (30 / _box2D.scale));
			
			_leftSensorShape = new b2PolygonShape();
			_leftSensorShape.SetAsOrientedBox(sensorWidth, sensorHeight, sensorOffset);

			sensorOffset.x = -sensorOffset.x;
			_rightSensorShape = new b2PolygonShape();
			_rightSensorShape.SetAsOrientedBox(sensorWidth, sensorHeight, sensorOffset);
		}
		
		override protected function defineFixture():void 
		{
			super.defineFixture();
			
			_attackSensorDef = new b2FixtureDef();
			_attackSensorDef.shape = _leftSensorShape;
			_attackSensorDef.isSensor = true;
			_attackSensorDef.filter.categoryBits = PhysicsCollisionCategories.Get("GoodGuys");
			_attackSensorDef.filter.maskBits = PhysicsCollisionCategories.GetAll();// ("BadGuys");
		}
		
		override protected function createFixture():void 
		{
			super.createFixture();
			
			_leftSensorFixture = body.CreateFixture(_attackSensorDef);

			_attackSensorDef.shape = _rightSensorShape;
			_rightSensorFixture = body.CreateFixture(_attackSensorDef);
		}
		
		public function get isDead():Boolean
		{
			return _nLifes < 0;
		}
		
		override public function update(timeDelta:Number):void 
		{
			super.update(timeDelta);
			
			if (_onGround && !_attacking && _ce.input.justDid("attack", inputChannel))
			{
				_attacking = true;
				_attackAnimationFrame = 0;
				setTimeout(function():void {
					_attacking = false;
				}, 400);
			}
		}
		
		override protected function updateAnimation():void 
		{
			var prevAnimation:String = _animation;
			var walkingSpeed:Number = getWalkingSpeed();
			
			if (_attacking)
			{
				_animation = "attack";
				
				if (++_attackAnimationFrame == 7)
					attackEnemiesInRange();
			}
			else
			{
				super.updateAnimation();
				return;
			}
			
			if (prevAnimation != _animation)
				onAnimationChange.dispatch();
		}
		
		
		private function attackEnemiesInRange():void
		{
			for each (var enemy:Enemy in _contactingEnemies)
			{
				if ((!inverted && enemy.x > x) || (_inverted && enemy.x < x))
					enemy.hurt();
			}
		}
		
		override public function handleBeginContact(contact:b2Contact):void 
		{
			var ignoreContact:Boolean = false;
			
			if (isDead)
				ignoreContact = true;
			
			var fixtureA:b2Fixture = contact.GetFixtureA();
			var fixtureB:b2Fixture = contact.GetFixtureB();
			if (fixtureA == _leftSensorFixture || fixtureB == _leftSensorFixture 
				|| fixtureA == _rightSensorFixture || fixtureB == _rightSensorFixture)
			{
				ignoreContact = true;
			}

			var other:* = Box2DUtils.CollisionGetOther(this, contact);
			var enemy:Enemy = other as Enemy;
			if (enemy && _contactingEnemies.indexOf(enemy) < 0)
			{
				_contactingEnemies.push(enemy);
			}
			
			if (!ignoreContact) super.handleBeginContact(contact);
		}
		
		
		override public function handleEndContact(contact:b2Contact):void 
		{
			super.handleEndContact(contact);
			
			var enemy:Enemy = Box2DUtils.CollisionGetOther(this, contact) as Enemy;
			if (enemy)
			{
				var enemyIndex:int = _contactingEnemies.indexOf(enemy);
				if (enemyIndex >= 0) _contactingEnemies.splice(enemyIndex, 1);
			}
		}
		
		private function onDamageTaken():void
		{
			--_nLifes;
			
			if (isDead)
			{
				_animation = "defeat";
				updateCallEnabled = false;
				setTimeout(function():void {
					_animation = "dead";
				}, 2700);
			}
		}
		
	}

}
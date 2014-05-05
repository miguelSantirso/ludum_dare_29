package space_digger 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.input.controllers.Keyboard;
	import citrus.objects.Box2DPhysicsObject;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.PhysicsCollisionCategories;
	import flash.utils.setTimeout;
	import space_digger.levels.LevelDig;
	import space_digger.CustomEnemy;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PlayerCharacter extends CustomHero 
	{
		private var _attackAnimationFrame:int = 0;
		
		private var _attacking:Boolean = false;
		
		private var _attackSensorDef:b2FixtureDef
		private var _leftSensorFixture:b2Fixture;
		private var _leftSensorShape:b2PolygonShape;
		private var _rightSensorFixture:b2Fixture;
		private var _rightSensorShape:b2PolygonShape;
		
		private var _contactsLeft:Vector.<Box2DPhysicsObject> = new Vector.<Box2DPhysicsObject>();
		private var _contactsRight:Vector.<Box2DPhysicsObject> = new Vector.<Box2DPhysicsObject>();
		
		public function PlayerCharacter(name:String, params:Object=null) 
		{
			super(name, params);
			
			width = 20;
			height = 35;
			offsetX = -5
			offsetY = -10;
			
			// Happy config
			/*minVelocityY = -10;
			maxVelocity = 3.5;
			acceleration = 40;
			friction = 80;
			jumpAcceleration = 3;
			jumpHeight = 10;
			
			// Ice config
			minVelocityY = -10;
			maxVelocity = 6;
			acceleration = 1;
			friction = 0.25;
			jumpAcceleration = 3;
			jumpHeight = 10;
			
			// Water config
			minVelocityY = -10;
			maxVelocity = 2.5;
			acceleration = 2;
			friction = 1;
			jumpAcceleration = 5;
			jumpHeight = 25;
			
			// Fire config
			minVelocityY = -10;
			maxVelocity = 4;
			acceleration = 50;
			friction = 40;
			jumpAcceleration = 5;
			jumpHeight = 10;
			*/
			// Forest config BASE
			minVelocityY = -10;
			maxVelocity = 4;
			acceleration = 50;
			friction = 40;
			jumpAcceleration = 3;
			jumpHeight = 10;
			
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
			
			var sensorWidth:Number = 40 / _box2D.scale;
			var sensorHeight:Number = 30 / _box2D.scale;
			var sensorOffset:b2Vec2 = new b2Vec2( -_width / 2 - (sensorWidth / 2), _height / 2 - (20 / _box2D.scale));
			
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
			return _nLifes <= 0;
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
				{
					attackContactsInRange();
					onGiveDamage.dispatch();
					
					(_ce.state as LevelDig).startedDigging.dispatch(x, y);
				}
			}
			else
			{
				super.updateAnimation();
				return;
			}
			
			if (prevAnimation != _animation)
				onAnimationChange.dispatch();
		}
		
		
		private function attackContactsInRange():void
		{
			var relevantContacts:Vector.<Box2DPhysicsObject> = _inverted ? _contactsLeft : _contactsRight;
			for each (var contact:Box2DPhysicsObject in relevantContacts)
			{
				if (contact is CustomEnemy)
				{
					_ce.sound.playSound("HitEnemy");
					(contact as CustomEnemy).hurt();
				}
				else if (contact is DestructibleBlock)
				{
					(contact as DestructibleBlock).explode();
				}
			}
		}
		
		
		override public function handleBeginContact(contact:b2Contact):void 
		{
			var ignoreContact:Boolean = false;
			
			if (isDead)
				ignoreContact = true;
			
			// Ignore the contact if it's against one of the left/right sensors
			var fixtureA:b2Fixture = contact.GetFixtureA();
			var fixtureB:b2Fixture = contact.GetFixtureB();
			if (fixtureA == _leftSensorFixture || fixtureB == _leftSensorFixture 
				|| fixtureA == _rightSensorFixture || fixtureB == _rightSensorFixture)
			{
				ignoreContact = true;
			}
			
			var rightContact:Boolean = fixtureA == _rightSensorFixture || fixtureB == _rightSensorFixture;

			var other:* = Box2DUtils.CollisionGetOther(this, contact);
			var relevantContacts:Vector.<Box2DPhysicsObject> = rightContact ? _contactsRight : _contactsLeft;
			if (other is CustomEnemy || other is DestructibleBlock && relevantContacts.indexOf(other) < 0)
			{
				relevantContacts.push(other);
			}
			
			if (!ignoreContact) super.handleBeginContact(contact);
		}
		
		
		override public function handleEndContact(contact:b2Contact):void 
		{
			super.handleEndContact(contact);
			
			// Check if it's colliding with the right sensor or the left sensor
			// There's probably some easier way to do this, but I couldn't find it...
			var fixtureA:b2Fixture = contact.GetFixtureA();
			var fixtureB:b2Fixture = contact.GetFixtureB();
			var rightContact:Boolean = fixtureA == _rightSensorFixture || fixtureB == _rightSensorFixture;

			var other:* = Box2DUtils.CollisionGetOther(this, contact);
			var relevantContacts:Vector.<Box2DPhysicsObject> = rightContact ? _contactsRight : _contactsLeft;
			if (other is CustomEnemy || other is DestructibleBlock)
			{
				var contactIndex:int = relevantContacts.indexOf(other);
				if (contactIndex >= 0) relevantContacts.splice(contactIndex, 1);
			}
		}
		
		private function onDamageTaken():void
		{
			if (isDead)
			{
				// INSERT_SOUND PLAYER MUERE
				_ce.sound.playSound("Death");
				
				if((_ce.state as LevelDig).exploring){
					(_ce.state as LevelDig).diggingSession.died(x, y);
					(_ce.state as LevelDig).endExploration();
				}
				
				_animation = "defeat";
				updateCallEnabled = false;
				setTimeout(function():void {
					_animation = "dead";
				}, 2700);
			}
		}
		
		public function stopCharacter():void
		{
			_fixture.SetFriction(_friction);
			
			if (_animation != "idle"){
				onAnimationChange.dispatch();
			}
		}
	}

}
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
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Creeper extends Patrol
	{
		public var inputChannel:uint = 0;
		private var _facingLeft:Boolean = true;
		private var _chasing:Boolean = false;
		private var _chasingTarget:b2Vec2 = new b2Vec2();
		private var _player:PlayerCharacter = null;
		private var _firstTime:Boolean = true;
		
		private static var DETECTION_RANGE:int = 350;
		
		public function Creeper(name:String, params:Object=null) 
		{	
			super(name, params);
			
			view = "IceCreeper";
			height = 63;
			width = 64;
			offsetY = -16;

			(_ce.state as LevelDig).startedDigging.add(onDigStart);
			
			turnAround();
		}

		public function onDigStart(playerX:Number, playerY:Number):void
		{
		}
	}
}
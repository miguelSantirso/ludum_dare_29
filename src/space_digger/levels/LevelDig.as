package space_digger.levels 
{
	import Box2D.Collision.b2ContactID;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2PolygonContact;
	import citrus.core.State;
	import flash.display.MovieClip;
	import citrus.objects.CitrusSprite;
	import citrus.objects.CitrusSpritePool;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2D;
	import flash.display.MovieClip;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.platformer.box2d.Coin;
	import citrus.objects.platformer.box2d.Cannon;
	import citrus.utils.objectmakers.ObjectMaker2D;
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	import space_digger.GameplayHud;
	import space_digger.PlayerCharacter;
	import space_digger.Seam;
	import space_digger.enemies.Patrol;
	import space_digger.enemies.Creeper;
	import space_digger.enemies.Spike;
	import space_digger.enemies.SpawnSpot;
	import citrus.core.CitrusObject;
	import space_digger.SpaceShip;
	import managers.GameManager;
	import flash.utils.setTimeout;
	import space_digger.DestructibleBlock;
	
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class LevelDig extends GameLevel
	{
		public var startedDigging:Signal = new Signal(Number, Number);
		
		private var _ship:SpaceShip;
		private var _inExitArea:Boolean = false;
		
		private var _hud:GameplayHud = new GameplayHud();
		
		public function LevelDig(_level:MovieClip) 
		{
			super(_level);
			
			var objectsUsed:Array = [SpaceShip, SpawnSpot, Hero, Platform, Coin, Cannon, PlayerCharacter, Seam, Spike, Patrol, Creeper, DestructibleBlock];
		}
		
		public override function initialize():void
		{
			super.initialize();
			
			_ship = getObjectByName("ship") as SpaceShip;
			view.camera.setUp(_ship, new Rectangle(0, -500, 1000, 530));
			
			(getObjectByName("exit") as Sensor).onBeginContact.add(onEnteredExit);
			(getObjectByName("exit") as Sensor).onEndContact.add(onExitedExit);
			
			stage.addChild(_hud);
		}
		
		public override function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if (_inExitArea && _ce.input.justDid("attack"))
			{
				_ship.leave();
			}
		}
		
		public function startExploration():void
		{
			view.camera.bounds = null;
			var ship:CitrusSprite = getObjectByName("ship") as CitrusSprite;
			var player:PlayerCharacter = getObjectByName("player_char") as PlayerCharacter;
			view.camera.camPos.x = ship.x;
			view.camera.camPos.y = ship.y - 40;
			player.x = ship.x;
			view.camera.tweenSwitchToTarget(getObjectByName("player_char"), 3);
			
			GameManager.getInstance().play(function(data:Object):void {
				view.camera.switchToTarget(getObjectByName("player_char"));
				view.camera.bounds = null;
			});
		}
		
		private function onEnteredExit(c:b2Contact):void
		{
			_inExitArea = true;
		}
		private function onExitedExit(c:b2Contact):void
		{
			_inExitArea = false;
		}
		
	}
}
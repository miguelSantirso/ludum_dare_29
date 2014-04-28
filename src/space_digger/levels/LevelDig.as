package space_digger.levels 
{
	import Box2D.Collision.b2ContactID;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2PolygonContact;
	import citrus.core.State;
	import data.DiggingSession;
	import data.Mine;
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
	import managers.GameManager;
	import managers.DataManager;
	import data.SeamData;
	import com.greensock.TweenLite;
	
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class LevelDig extends GameLevel
	{
		public var startedDigging:Signal = new Signal(Number, Number);
		
		protected var _ship:SpaceShip;
		protected var _player:PlayerCharacter;
		protected var _inExitArea:Boolean = false;
		protected var _exploring:Boolean = false;
		
		public var diggingSession:DiggingSession = new DiggingSession();
		
		protected var _hud:GameplayHud = new GameplayHud();
		
		public function LevelDig(_level:MovieClip) 
		{
			super(_level);
			
			var objectsUsed:Array = [SpaceShip, SpawnSpot, Hero, Platform, Coin, Cannon, PlayerCharacter, Seam, Spike, Patrol, Creeper, DestructibleBlock];
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			var seams:Vector.<CitrusObject> = getObjectsByName("seam");
			for (var i:int = 0; i < seams.length; ++i)
			{
				var seam:Seam = seams[i] as Seam;
				
				seam.destroy();
			}
			
			stage.removeChild(_hud);
			
			TweenLite.killDelayedCallsTo(endExploration);
		}
		
		public override function initialize():void
		{
			super.initialize();
			
			_player = getObjectByName("player_char") as PlayerCharacter;
			_player.onTakeDamage.add(onPlayerTakeDamage);
			
			_ship = getObjectByName("ship") as SpaceShip;
			view.camera.setUp(_ship, new Rectangle(0, -500, 1000, 530));
			
			(getObjectByName("exit") as Sensor).onBeginContact.add(onEnteredExit);
			(getObjectByName("exit") as Sensor).onEndContact.add(onExitedExit);
			
			setDiggingSession();
			
			stage.addChild(_hud);
		}
		
		protected function setDiggingSession():void
		{
			diggingSession.mine = DataManager.getInstance().currentMine;
			
			initializeMine();
		}
		
		
		public function onPlayerTakeDamage():void
		{
			_hud.nLifes = _player.nLifes;
			
			if (_player.nLifes < 0)
			{
				_hud.stopCountdown();
			}
		}
		
		private function initializeMine():void
		{
			var seams:Vector.<CitrusObject> = getObjectsByName("seam");
			
			var seamsData:Vector.<SeamData> = diggingSession.mine.seams;
			for (var i:int = 0; i < seams.length; ++i)
			{
				var seam:Seam = seams[i] as Seam;
				
				if (i < seamsData.length) 
					seam.init(seamsData[i]);
				else 
					seam.visible = false;
			}
		}
		
		public override function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if (_exploring && _inExitArea && _ce.input.justDid("attack"))
			{
				endExploration();
			}
			
			_hud.updateCountdown(timeDelta);
			
			if (_exploring && _hud.timeLeft <= 0)
			{
				_player.hurt();
			}
		}
		
		public function startExploration():void
		{
			GameManager.getInstance().play(onPlaySuccess);
		}
		
		protected function onPlaySuccess(payload:Object):void
		{
			view.camera.bounds = null;
				var ship:CitrusSprite = getObjectByName("ship") as CitrusSprite;
				var player:PlayerCharacter = getObjectByName("player_char") as PlayerCharacter;
				view.camera.camPos.x = ship.x;
				view.camera.camPos.y = ship.y - 40;
				player.x = ship.x;
				view.camera.tweenSwitchToTarget(getObjectByName("player_char"), 3);
				
				_hud.startCountdown(payload.stopwatch * 1000);
				
				_exploring = true;
				
				retryCounter = 0;
		}
		
		protected var retryCounter:int = 0;
		
		public function endExploration(takeOff:Boolean = true):void
		{
			var retrySeconds:int = 5;
			_exploring = false;
			_hud.stopCountdown();
			
			if (!takeOff)
				return;
				
			GameManager.getInstance().takeOff(diggingSession, exit, function():void	{
				if (retryCounter <= 3)
					TweenLite.delayedCall(retrySeconds, endExploration, [takeOff]);
				else
					exit();
				
				retryCounter++;
			});
			
		}
		
		protected function exit():void
		{
			var player:PlayerCharacter = getObjectByName("player_char") as PlayerCharacter;
			view.camera.camPos.x = player.x; 
			view.camera.camPos.y = player.y;
			view.camera.bounds = new Rectangle(0, -500, 1000, 530);
			view.camera.switchToTarget(_ship, 10, function():void {
				_ship.leave();
			});
		}
		
		public function endMission():void
		{
			GameManager.getInstance().updateState();
			GameManager.getInstance().updateSystem();
			
			changeLevel.dispatch(2);
		}
		
		
		private function onEnteredExit(c:b2Contact):void
		{
			_inExitArea = true;
		}
		private function onExitedExit(c:b2Contact):void
		{
			_inExitArea = false;
		}
		
		public function get hud():GameplayHud 
		{
			return _hud;
		}
		
		public function deploySeamMachine(seamIndex:int):void
		{
			diggingSession.deploySeamMachine(seamIndex);
		}
		
		public function destroySeamMachine(seamIndex:int):void
		{
			diggingSession.destroySeamMachine(seamIndex);
		}
		
	}
}
package space_digger.levels 
{
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.core.CitrusObject;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Cannon;
	import citrus.objects.platformer.box2d.Coin;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2DUtils;
	import com.greensock.TweenLite;
	import data.Death;
	import data.DiggingSession;
	import data.SeamData;
	import flash.geom.Rectangle;
	import managers.AnalyticsManager;
	import managers.DataManager;
	import managers.GameManager;
	import org.osflash.signals.Signal;
	import space_digger.CustomHero;
	import space_digger.DestructibleBlock;
	import space_digger.enemies.Creeper;
	import space_digger.enemies.Patrol;
	import space_digger.enemies.SpawnSpot;
	import space_digger.enemies.Spike;
	import space_digger.GameplayHud;
	import space_digger.PlayerCharacter;
	import space_digger.popups.PopupGeneric;
	import space_digger.popups.PopupTutorial;
	import space_digger.Seam;
	import space_digger.SpaceShip;
	
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class LevelDig extends StateGameplay
	{
		public var startedDigging:Signal = new Signal(Number, Number);
		
		protected var _ship:SpaceShip;
		protected var _player:PlayerCharacter;
		protected var _inExitArea:Boolean = false;
		protected var _exploring:Boolean = false;
		protected var _exit:Sensor;
		
		public var diggingSession:DiggingSession = new DiggingSession();
		
		protected var _hud:GameplayHud = new GameplayHud();
		
		public function LevelDig(tiledMap:XML) 
		{
			super(tiledMap, Levels.tileset(tiledMap.tileset[0].@name));
			
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
			view.camera.setUp(_ship, new Rectangle( -2000, -500, 5000, 530));
			
			_exit = getObjectByName("exit") as Sensor;
			_exit.view = "FxExit";
			_exit.onBeginContact.add(onEnteredExit);
			_exit.onEndContact.add(onExitedExit);
			_exit.animation = "empty";
			_exit.offsetY = 70;
			_exit.offsetX = 9;
			
			setDiggingSession();
			
			stage.addChild(_hud);
			
			_ce.sound.stopAllPlayingSounds();
			_ce.sound.playSound("Hypnothis");
			
			// INSERT_SOUND ENTRAR AL NIVEL
			_ce.sound.playSound("Aterrizaje");
				
			showTutorial();
		}
		
		protected function setDiggingSession():void
		{
			diggingSession.mine = DataManager.getInstance().currentMine;
			
			initializeMine();
			initializeCorpses();
		}
		
		
		public function onPlayerTakeDamage():void
		{
			_hud.nLifes = _player.nLifes;
			
			if (_player.nLifes < 0)
			{
				_hud.stopCountdown();
			}
		}
		
		private function initializeCorpses():void
		{
			for each (var corpseData:Death in diggingSession.mine.deaths)
			{
				var corpse:CitrusSprite = new CitrusSprite("corpse");
				corpse.view = new Corpse();
				corpse.offsetX += 10;
				corpse.offsetY += 34;
				corpse.x = corpseData.x; corpse.y = corpseData.y;
				add(corpse);
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
				{
					seam.visible = false;
					seam.kill = true;
				}
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
			view.camera.bounds = new Rectangle(0, -1000, 1320, 3500);
			var ship:CitrusSprite = getObjectByName("ship") as CitrusSprite;
			var player:PlayerCharacter = getObjectByName("player_char") as PlayerCharacter;
			view.camera.camPos.x = ship.x;
			view.camera.camPos.y = ship.y - 40;
			player.x = ship.x;
			view.camera.tweenSwitchToTarget(getObjectByName("player_char"), 2.3);
			
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
				
			disablePlayer();
				
			GameManager.getInstance().takeOff(diggingSession, exit, function():void	{
				if (retryCounter <= 3)
					TweenLite.delayedCall(retrySeconds, endExploration, [takeOff]);
				else {				
					exit();
				}
				
				retryCounter++;
			});
			
		}
		
		protected function exit():void
		{
			_exit.animation = "empty";
			_hud.hideLeavePlanetHint();
			
			var player:PlayerCharacter = getObjectByName("player_char") as PlayerCharacter;
			view.camera.camPos.x = player.x; 
			view.camera.camPos.y = player.y;
			//view.camera.bounds = new Rectangle(0, -500, 1000, 530);
			view.camera.allowZoom = true;
			view.camera.zoom(1.2);
			view.camera.switchToTarget(_ship, 10, function():void {
				_ship.leave();
			});
			
			// INSERT_SOUND SALIR DEL NIVEL
			_ce.sound.playSound("Despegue");
		}
		
		public function endMission():void
		{
			showResults();
		}
		
		protected function showResults():void
		{
			var numClaimed:int = diggingSession.activatedSeams.length;
			var message:String = "";
			
			if (diggingSession.death){
				if (numClaimed > 0)
					message = "Your worker didn't make it! But at least he deployed " + numClaimed + " machine"+(numClaimed > 1 ? "s" : "")+" before passing.";
				else
					message = "What a shame. Your worker didn't deploy any machines. You've got to try harder.";
			}else {
				if (numClaimed > 4)
					message = "You deployed " + numClaimed + " machines. What a great job!";
				else
					message = "You deployed " + numClaimed + " machine" + (numClaimed == 0 || numClaimed > 1 ? "s" : "") + ".";
			}

			var planet_name:String = DataManager.getInstance().currentPlanet.name;
			var mine_id:int = DataManager.getInstance().currentMine.id;
			
			// Report the amoun of claimed seams after the digging session
			AnalyticsManager.getInstance().triggerDesignEvent("digging_session:claimed_seams:" + planet_name+":" + mine_id,
															  numClaimed,
															  "LevelDig");
														  
			var player:PlayerCharacter = _player = getObjectByName("player_char") as PlayerCharacter;
			AnalyticsManager.getInstance().triggerDesignEvent("digging_session:consumed_lifes:" + planet_name + ":" + mine_id,
															  CustomHero.MAX_LIFES - player.nLifes,
															  "LevelDig");
			
			GameManager.getInstance().displayMessagePopUp(message, PopupGeneric.TYPE_MONO, "OK", "", goToSpaceLevel); // exit here is really important
		}
		
		protected function goToSpaceLevel():void
		{
			GameManager.getInstance().updateState();
			GameManager.getInstance().updateSystem();
			
			changeLevel.dispatch(2);
		}
		
		private function onEnteredExit(c:b2Contact):void
		{
			if (!_exploring) return;
			
			if (!(Box2DUtils.CollisionGetOther(_exit, c) is PlayerCharacter)) return;
			
			_inExitArea = true;
			_hud.showLeavePlanetHint();
			_exit.animation = "exit";
		}
		private function onExitedExit(c:b2Contact):void
		{
			if (!(Box2DUtils.CollisionGetOther(_exit, c) is PlayerCharacter)) return;
			
			_inExitArea = false;
			_hud.hideLeavePlanetHint();
			_exit.animation = "empty";
		}
		
		public function get hud():GameplayHud 
		{
			return _hud;
		}
		
		public function get exploring():Boolean 
		{
			return _exploring;
		}
		
		public function deploySeamMachine(seamIndex:int):void
		{
			diggingSession.deploySeamMachine(seamIndex);
		}
		
		public function destroySeamMachine(seamIndex:int):void
		{
			diggingSession.destroySeamMachine(seamIndex);
		}
		
		public function playBreakBlock():void
		{
			
		}
		
		protected function showTutorial():void
		{
			// tutorial
			if (!GameManager.getInstance().checkTutorial(GameManager.TUTORIAL_DIG)) {
				GameManager.getInstance().markTutorial(GameManager.TUTORIAL_DIG);
				GameManager.getInstance().displayMessageTutorialPopup(PopupTutorial.STATE_DIG);
			}
		}
		
		protected function disablePlayer():void
		{
			_player.updateCallEnabled = false;
			_player.stopCharacter();
		}
	}
}

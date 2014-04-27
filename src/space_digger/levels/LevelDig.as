package space_digger.levels 
{
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
	import space_digger.Patrol;
	import space_digger.Creeper;
	import space_digger.Spike;
	import citrus.core.CitrusObject;
	
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class LevelDig extends GameLevel
	{
		public var startedDigging:Signal = new Signal(int, int);
		
		private var _hud:GameplayHud = new GameplayHud();
		private var _player:PlayerCharacter;
		
		public function LevelDig(_level:MovieClip) 
		{
			super(_level);
			
			var objectsUsed:Array = [Hero, Platform, Coin, Cannon, PlayerCharacter, Seam, Spike, Patrol, Creeper];
		}
		
		public override function initialize():void
		{
			super.initialize();
			
			_player = getObjectByName("player_char") as PlayerCharacter;
			view.camera.setUp(_player/*, new Rectangle(0, 0, 1352, 1963)*/);
			_player.onTakeDamage.add(onPlayerTakeDamage);
			
			stage.addChild(_hud);
		}
		
		
		public function onPlayerTakeDamage():void
		{
			_hud.nLifes = _player.nLifes;
		}
		
	}
}
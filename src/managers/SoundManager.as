package managers 
{
	import citrus.core.CitrusEngine;
	import citrus.sounds.CitrusSoundGroup;
	import citrus.sounds.CitrusSoundInstance;
	import citrus.events.CitrusSoundEvent;
	import flash.media.Sound;
	import org.osflash.signals.Signal;
	
	public class SoundManager
	{
		[Embed(source = "/../res/sounds/basement_floor.mp3")]
		public static const SND_BG_GAME_1:Class;

		[Embed(source="/../res/sounds/hypnothis.mp3")]
		public static const SND_BG_GAME_2:Class;
		
		[Embed(source="/../res/sounds/aterrizaje.mp3")]
		public static const SND_LANDING:Class;
		
		[Embed(source="/../res/sounds/despegue.mp3")]
		public static const SND_TAKEOFF:Class;
		
		[Embed(source="/../res/sounds/break_block.mp3")]
		public static const SND_BREAK_BLOCK:Class;
		
		[Embed(source="/../res/sounds/death.mp3")]
		public static const SND_DEATH:Class;
		
		[Embed(source="/../res/sounds/deploy.mp3")]
		public static const SND_DEPLOY_SEAM:Class;
		
		[Embed(source="/../res/sounds/destroy_seam.mp3")]
		public static const SND_DESTROY_SEAM:Class;
		
		[Embed(source="/../res/sounds/get_hit.mp3")]
		public static const SND_GET_HIT:Class;
		
		[Embed(source="/../res/sounds/hit_enemy.mp3")]
		public static const SND_HIT_ENEMY:Class;
		
		[Embed(source="/../res/sounds/jetpack.mp3")]
		public static const SND_JETPACK:Class;

		private var _ce:CitrusEngine = null;
		private static var instance:SoundManager;
		private static var instantiated:Boolean = false;	
		
		public static function getInstance():SoundManager
		{
			if (!instance) {
				instantiated = true;
				instance = new SoundManager();
			}
			return instance;
		}
		
		public function SoundManager() 
		{
			if (instantiated) {
				instantiated = false;
			}else {
				throw new Error("Use getInstance()");
			}
		}
		
		public function init():void 
		{
			_ce = CitrusEngine.getInstance();
			
			//offset the sounds (less gap in the looping sound)
			CitrusSoundInstance.startPositionOffset = 80;

			//sound added with asset manager
			_ce.sound.addSound("BasementFloor", { sound:SND_BG_GAME_1 ,permanent:true, volume:0.4 , loops:int.MAX_VALUE , group:CitrusSoundGroup.BGM } );
			_ce.sound.addSound("Hypnothis", { sound:SND_BG_GAME_2 ,permanent:true, volume:0.4 , loops:int.MAX_VALUE , group:CitrusSoundGroup.BGM } );

			//sounds added with url
			_ce.sound.addSound("Aterrizaje", { sound:SND_LANDING , group:CitrusSoundGroup.SFX } );
			_ce.sound.addSound("BreakBlock", { sound:SND_BREAK_BLOCK , group:CitrusSoundGroup.SFX } );
			_ce.sound.addSound("Death", { sound:SND_DEATH , group:CitrusSoundGroup.SFX } );
			_ce.sound.addSound("Deploy", { sound:SND_DEPLOY_SEAM , group:CitrusSoundGroup.SFX } );
			_ce.sound.addSound("Despegue", { sound:SND_TAKEOFF , group:CitrusSoundGroup.SFX } );
			_ce.sound.addSound("DestroySeam", { sound:SND_DESTROY_SEAM , group:CitrusSoundGroup.SFX } );
			_ce.sound.addSound("GetHit", { sound:SND_GET_HIT , group:CitrusSoundGroup.SFX } );
			_ce.sound.addSound("HitEnemy", { sound:SND_HIT_ENEMY , group:CitrusSoundGroup.SFX } );
			_ce.sound.addSound("JetPack", { sound:SND_JETPACK , permanent:true, volume:0.2 , loops:int.MAX_VALUE , group:CitrusSoundGroup.SFX } );
			
			_ce.sound.getGroup(CitrusSoundGroup.BGM).volume = 0.4;
			
			_ce.sound.getGroup(CitrusSoundGroup.SFX).volume = 0.4;
			_ce.sound.getGroup(CitrusSoundGroup.SFX).preloadSounds();
		}
	}
}

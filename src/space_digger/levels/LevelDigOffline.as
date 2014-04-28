package space_digger.levels 
{
	import data.Mine;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class LevelDigOffline extends LevelDig 
	{
		
		public function LevelDigOffline(_level:MovieClip) 
		{
			super(_level);
		}
		
		protected override function setDiggingSession():void
		{
			var mine:Mine = new Mine();
			
			// fill the mine data
			diggingSession.mine = mine;
		}
		
		public override function startExploration():void
		{
			var maxMinutes:int = 10;
			var randomSeconds:int = Math.floor(Math.random() * maxMinutes * 60);
			
			onPlaySuccess( { stopwatch:randomSeconds } );
		}
		
		public override function endExploration(takeOff:Boolean = true):void
		{
			// TODO
			return;
			
			//old
			/*_exploring = false;
			_hud.stopCountdown();
			
			if (takeOff)
				GameManager.getInstance().takeOff(diggingSession);
			
			var player:PlayerCharacter = getObjectByName("player_char") as PlayerCharacter;
			view.camera.camPos.x = player.x; 
			view.camera.camPos.y = player.y;
			view.camera.bounds = new Rectangle(0, -500, 1000, 530);
			view.camera.switchToTarget(_ship, 10, function():void {
				_ship.leave();
			});*/
		}
	}

}
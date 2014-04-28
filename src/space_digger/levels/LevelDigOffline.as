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
		protected var _claimedSeams:int;
		
		public function LevelDigOffline(_level:MovieClip) 
		{
			super(_level);
			
			_claimedSeams = 0;
		}
		
		protected override function setDiggingSession():void
		{
			var mine:Mine = new Mine();
			
			// fill the mine data
			diggingSession.mine = mine;
		}
		
		public override function startExploration():void
		{
			var minMinutes:int = 3;
			var maxMinutes:int = 10;
		var randomSeconds:int = Math.max(minMinutes * 60, Math.floor(Math.random() * maxMinutes * 60));
			
			onPlaySuccess( { stopwatch:randomSeconds } );
		}
		
		public override function endExploration(takeOff:Boolean = true):void
		{
			_exploring = false;
			_hud.stopCountdown();
			
			exit();
		}
		
		public override function endMission():void
		{
			changeLevel.dispatch(1);
		}
		
		
		public override function deployMachine(seamIndex:int):Boolean
		{
			var deployment:Boolean = super.deploySeamMachine(seamIndex);
			
			//if(deployment
			
			return deployment;
		}
		
		public override function destroySeamMachine(seamIndex:int):Boolean
		{
			var destroyed:Boolean = super.destroySeamMachine(seamIndex);
			
			//if(deployment
			
			return destroyed;
		}
	}

}
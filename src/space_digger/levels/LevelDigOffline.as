package space_digger.levels 
{
	import data.Mine;
	import flash.display.MovieClip;
	import managers.GameManager;
	import space_digger.popups.PopupGeneric;
	
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class LevelDigOffline extends LevelDig 
	{
		protected var _claimedSeamIndexes:Array;
		
		public function LevelDigOffline(_level:MovieClip) 
		{
			super(_level);
			
			_claimedSeamIndexes = new Array();
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			_claimedSeamIndexes.splice(0, _claimedSeamIndexes.length);
			_claimedSeamIndexes = null;
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
		
		protected override function showResults():void
		{
			var numClaimed:int = _claimedSeamIndexes.length;
			var message:String = "";
			
			if (diggingSession.death){
				if (numClaimed > 0)
					message = "The worker didn't make it, but at least he deployed " + numClaimed + " machine"+(numClaimed > 1 ? "s" : "")+" before passing. We are lucky this was just training.";
				else
					message = "What a shame. Your worker didn't deploy any machines. Try again, you'll get better at it.";
			}else {
				if (numClaimed > 2)
					message = "You deployed " + _claimedSeamIndexes.length + " machines. Great job, you are totally ready for Online mode!";
				else
					message = "You deployed " + _claimedSeamIndexes.length + " machines. You can do better."
			}
			
			GameManager.getInstance().displayMessagePopUp(message, PopupGeneric.TYPE_MONO, "Got it", "", goToRegister); // exit here is really important
		}
		
		protected function goToRegister():void
		{
			changeLevel.dispatch(1);
		}
		
		public override function deploySeamMachine(seamIndex:int):void
		{
			if (_claimedSeamIndexes.indexOf(seamIndex) < 0)
				_claimedSeamIndexes.push(seamIndex);
		}
		
		public override function destroySeamMachine(seamIndex:int):void
		{	
			if (_claimedSeamIndexes.indexOf(seamIndex) >= 0)
				_claimedSeamIndexes.splice(_claimedSeamIndexes.indexOf(seamIndex),1);
		}
		
		protected override function showTutorial():void
		{
			// nothing
		}
	}

}
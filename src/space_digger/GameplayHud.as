package space_digger 
{
	import away3d.animators.data.VertexAnimationMode;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author ...
	 */
	public class GameplayHud extends GameHud
	{
		private var _timeLeft:Number = -1;
		
		public function GameplayHud() 
		{
			nLifes = 3;
			
			mineral_hud.visible = false;
		}
		
		
		
		public function startCountdown(milliseconds:uint):void
		{
			_timeLeft = milliseconds;
			countdown.visible = true;
		}
		public function stopCountdown():void
		{
			_timeLeft = -1;
		}
		public function updateCountdown(timeDelta:Number):void
		{
			if (_timeLeft < 0)
			{
				return;
			}
			
			_timeLeft -= timeDelta * 1000;
			
			_timeLeft = Math.max(0, _timeLeft);
			
			var aux:Number = _timeLeft;
			var minutes:int = Math.floor(aux / 1000.0 / 60.0);
			aux -= minutes * 60 * 1000;
			var seconds:int = Math.floor(aux / 1000.0) % 60;
			aux -= seconds * 1000;
			var milliseconds:int = aux;
			
			countdown.text = (minutes < 10 ? "0" : "") + minutes + ":" 
							+ (seconds < 10 ? "0" : "") + seconds + ":" 
							+ (milliseconds < 100 ? "0" : "") + milliseconds;
		}
		
		
		public function showMineralHud(owner:String, lifePercent:int):void
		{
			mineral_hud.visible = true;
			mineral_hud.owner.text = owner;
			mineral_hud.life.gotoAndStop(lifePercent);
		}
		public function hideMineralHud():void
		{
			mineral_hud.visible = false;
		}
		
		public function showClaimHint():void
		{
			claim_hint.visible = true;
		}
		public function hideClaimHint():void
		{
			claim_hint.visible = false;
		}
		
		
		public function set nLifes(value:int):void
		{
			value = Math.max(0, value);
			value = Math.min(3, value);
			lifes.gotoAndStop("l" + value);
		}
		
		public function get timeLeft():Number 
		{
			return _timeLeft;
		}
		
	}

}
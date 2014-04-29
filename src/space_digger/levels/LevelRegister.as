package space_digger.levels 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import managers.RemoteManager;
	import managers.GameManager;
	import managers.DataManager;
	import flash.events.KeyboardEvent;
	import space_digger.popups.PopupGeneric;
	import com.greensock.TweenLite;
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class LevelRegister extends GameLevel
	{
		private var _suffixIndex:int = 0;
		private var _offlineStarted:Boolean = false;
		
		public function LevelRegister(_level:MovieClip) 
		{
			super(_level);
			
			addChild(level);
		}
		
		public override function initialize():void
		{
			super.initialize();
			
			setActionListeners();
			
			var suffixes:Vector.<String> = DataManager.getInstance().core.companySuffixes;
			
			(level.input_company_name as TextField).maxChars = 16;
			level.input_company_type.text = suffixes.length > 0 ? suffixes[_suffixIndex] : "INC.";
			
			level.button_start.label_text.text = "LAUNCH";
			
			if (!_ce.sound.soundIsPlaying("BasementFloor"))
			{
				_ce.sound.stopAllPlayingSounds();
				_ce.sound.playSound("BasementFloor");
			}
		}
		
		public override function update(timeDelta:Number):void
		{
			super.update(timeDelta);
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			removeActionListeners();
			
			TweenLite.killDelayedCallsTo(resetOfflineFlag);
		}
		
		public function get companyNameInput():String
		{
			return level.input_company_name.text;
		}
		
		public function get companyTypeInput():String
		{
			return level.input_company_type.text;
		}
		
		protected function setActionListeners():void
		{
			level.button_start.addEventListener(MouseEvent.CLICK, onStartButtonHandler,false,0,true);
			level.button_offline.addEventListener(MouseEvent.CLICK, onOfflineButtonHandler, false, 0, true);
			
			level.button_arrow_up.addEventListener(MouseEvent.CLICK, onPreviousCompanySuffix, false, 0, true);
			level.button_arrow_down.addEventListener(MouseEvent.CLICK, onNextCompanySuffix, false, 0, true);
		}
		
		protected function removeActionListeners():void
		{
			level.button_start.removeEventListener(MouseEvent.CLICK, onStartButtonHandler);
			level.button_offline.removeEventListener(MouseEvent.CLICK, onOfflineButtonHandler);
			
			level.button_arrow_up.removeEventListener(MouseEvent.CLICK, onPreviousCompanySuffix);
			level.button_arrow_down.removeEventListener(MouseEvent.CLICK, onNextCompanySuffix);
		}
		
		// ACTION HANDLERS:
		private function onStartButtonHandler(e:MouseEvent):void
		{
			if (companyNameInput != "")
			{
				GameManager.getInstance().register(companyNameInput + " " + companyTypeInput, 0x000000, 0x000000);
			}
			else GameManager.getInstance().displayMessagePopUp("You need to introduce a company name", PopupGeneric.TYPE_MONO);
		}
		
		protected function onOfflineButtonHandler(e:MouseEvent):void
		{
			if(!_offlineStarted){
				_offlineStarted = true;
				GameManager.getInstance().changeToOffline();
				
				TweenLite.delayedCall(10,resetOfflineFlag);
			}
		}
		
		private function onPreviousCompanySuffix(e:MouseEvent = null):void
		{
			if (DataManager.getInstance().core.companySuffixes.length <= 0)
				return;
				
			_suffixIndex++;
			
			if (_suffixIndex == DataManager.getInstance().core.companySuffixes.length)
				_suffixIndex = 0;
			
			level.input_company_type.text = DataManager.getInstance().core.companySuffixes[_suffixIndex];
		}
		
		private function onNextCompanySuffix(e:MouseEvent = null):void
		{
			if (DataManager.getInstance().core.companySuffixes.length <= 0)
				return;
				
			_suffixIndex--;
			
			if (_suffixIndex == -1)
				_suffixIndex = DataManager.getInstance().core.companySuffixes.length - 1;
			
			level.input_company_type.text = DataManager.getInstance().core.companySuffixes[_suffixIndex];
		}
		
		protected function resetOfflineFlag():void
		{
			_offlineStarted = false;
		}
	}
}
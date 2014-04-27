package managers 
{
	import data.Company;
	import data.CompanyState;
	import data.Core;
	import data.RankingEntry;
	import data.System;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class DataManager 
	{
		private static var instance:DataManager;
		private static var instantiated:Boolean = false;
		
		protected var _core:Core;
		protected var _myState:CompanyState;
		protected var _mySystem:System;
		protected var _ranking:Vector.<RankingEntry>;
		
		public function DataManager() 
		{
			if (instantiated) {
				instantiated = false;
				
				_core = new Core();
				_myState = new CompanyState();
				_mySystem = new System();
				_ranking = new Vector.<RankingEntry>();
			}else {
				throw new Error("Use getInstance()");
			}
		}
		
		public static function getInstance():DataManager
		{
			if (!instance) {
				instantiated = true;
				instance = new DataManager();
			}
			return instance;
		}
		
		public function reset():void
		{
			_core.reset();
			_myState.reset();
			_mySystem.reset();
			_ranking.splice(0,_ranking.length);
		}
		
		public function populateRanking(data:Object):void
		{
			if (!data)
				return;
				
			var rankingEntries:Array = data as Array ? data as Array : [data];
			var entry:RankingEntry;
			
			for each(var e:Object in rankingEntries) {
				entry = new RankingEntry();
				entry.populate(e);
				
				if (!entry.empty())
					_ranking.push(entry);
			}
		}
		
		public function get core():Core 
		{
			return _core;
		}
		
		public function get myState():CompanyState 
		{
			return _myState;
		}
		
		public function get mySystem():System 
		{
			return _mySystem;
		}
		
		public function get ranking():Vector.<RankingEntry> 
		{
			return _ranking;
		}
	}

}
package managers 
{
	import data.Company;
	import data.CompanyState;
	import data.Core;
	import data.DiggingSession;
	import data.Mine;
	import data.RankingEntry;
	import data.System;
	import flash.utils.Dictionary;
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
		
		public var currentMine:Mine;
		
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
			_ranking.splice(0, _ranking.length);
		}
		
		public function populateRanking(data:Object):void
		{
			if (!data)
				return;
				
			_ranking.splice(0, _ranking.length);
			
			var rankingEntries:Array = new Array();
			var positionCounter:int = 1;
			var rankingObject:Object;
			
			for each(var o:Object in data)
			{
				rankingObject = new Object();
				rankingObject["position"] = positionCounter;
				rankingObject["company"] = o;
				rankingEntries.push(rankingObject);
				positionCounter++;
			}

			var entry:RankingEntry;
			
			for each(var e:Object in rankingEntries) {
				entry = new RankingEntry(e);
				
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
		
		public function getCompanyRank(companyID:int):Number
		{
			var rank:Number = int.MAX_VALUE;
			
			if (_ranking != null && _ranking.length > 0)
			{
				for each(var rankingEntry:RankingEntry in _ranking)
				{
					if (rankingEntry.company.id == companyID)
					{
						rank = rankingEntry.position; 
						break;
					}
				}
			}
			
			return rank;
		}
	}

}
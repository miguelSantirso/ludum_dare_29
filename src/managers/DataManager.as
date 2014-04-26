package managers 
{
	import data.Company;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class DataManager 
	{
		private static var instance:DataManager;
		private static var instantiated:Boolean = false;
		
		protected var _myCompany:Company;
		
		public function DataManager() 
		{
			if (instantiated) {
				instantiated = false;
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
		
		public function populateMyState(data:Object):void
		{
			_myCompany = new Company();
			_myCompany.populate(data);
			
			// populate my seams
		}
		
		public function get myCompany():Company 
		{
			return _myCompany;
		}
	}

}
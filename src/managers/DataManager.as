package managers 
{
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class DataManager 
	{
		private static var instance:DataManager;
		private static var instantiated:Boolean = false;
		
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
	}

}
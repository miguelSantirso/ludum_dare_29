package managers 
{
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class GameManager 
	{
		private static var instance:GameManager;
		private static var instantiated:Boolean = false;
		
		public function GameManager() 
		{
			if (instantiated) {
				instantiated = false;
			}else {
				throw new Error("Use getInstance()");
			}
		}
		
		public static function getInstance():GameManager
		{
			if (!instance) {
				instantiated = true;
				instance = new GameManager();
			}
			return instance;
		}
		
		public function test():void
		{
			trace("test");
		}
	}

}
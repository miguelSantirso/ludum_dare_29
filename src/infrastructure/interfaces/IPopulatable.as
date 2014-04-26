package infrastructure.interfaces
{
	public interface IPopulatable
	{
		/**
		 * Fills the data structures with the data stored in data
		 */		
		function populate(data:Object):void;
		
		function reset():void;
	}
}
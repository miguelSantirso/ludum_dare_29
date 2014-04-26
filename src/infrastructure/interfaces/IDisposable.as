package infrastructure.interfaces
{
	public interface IDisposable
	{
		/**
		 * Removes all event listeners, removes all visual elements from the 
		 * display list, calls the dispose method of all disposable methods and 
		 * sets to null all references to objects.
		 */		
		function dispose():void;
	}
}
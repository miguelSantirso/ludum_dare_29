package data 
{
	import infrastructure.interfaces.IPopulatable;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class Planet implements IPopulatable 
	{
		protected var _id:int;
		protected var _name:String;
		protected var _difficulty:int; //PlanetDifficulty
		protected var _richness:int; // number of seams
		protected var _toxicity:int; // number of active machines
		protected var _mines:Vector.<Mine>;
		protected var _skin:int; //SkinType

		public function Planet(data:Object = null) 
		{
			_mines = new Vector.<Mine>;
			
			if (data)
				populate(data);
		}
		
		public function populate(data:Object):void 
		{
			if(data["id"])
				_id = data["id"];
				
			if(data["name"])
				_name = data["name"];
			
			if(data["difficulty"])
				_difficulty = data["difficulty"];
				
			if(data["richness"])
				_richness = data["richness"];
				
			if(data["toxicity"])	
				_toxicity = data["toxicity"];
				
			if(data["skin"])
				_skin = data["skin"];
			
			if(data["mines"])
				populateMines(data["mines"]);
		}
		
		public function reset():void 
		{
			_id = 0;
			_name = null;
			_difficulty = -1;
			_richness = 0;
			_toxicity = 0;
			_skin = 0;
			
			_mines.splice(0, _mines.length);
		}
		
		protected function populateMines(data:Object):void
		{
			if (!data)
				return;
				
			var mineArray:Array = data as Array ? data as Array : [data];
			var tempMine:Mine;
			
			for each(var mineObject:Object in mineArray) {
				tempMine = new Mine();
				tempMine.populate(mineObject);
				
				if(!tempMine.empty())
					_mines.push(tempMine);
			}
		}
		
		public function empty():Boolean
		{
			return _id <= 0;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get difficulty():int 
		{
			return _difficulty;
		}
		
		public function get richness():int 
		{
			return _richness;
		}
		
		public function get toxicity():int 
		{
			return _toxicity;
		}
		
		public function get mines():Vector.<Mine> 
		{
			return _mines;
		}
		
		public function get skin():int 
		{
			return _skin;
		}
	}

}
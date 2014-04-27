package data 
{
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class Planet implements IPopulatable 
	{
		protected var _id:
		protected var _name:String;
		protected var _difficulty:int; //PlanetDifficulty
		protected var _richness:int; // number of seams
		protected var _toxicity:int; // number of active machines
		protected var _mines:Vector.<Mine>;
		protected var _skin:int; //SkinType

		public function Planet() 
		{
			_mines = new Vector.<Mine>;
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
				_toxicity = data.toxicity;
				
			if(data["skin"])
				_skin = data.skin;
			
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
			// TODO
		}
		
		public function get id(): 
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
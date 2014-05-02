package  
{
	import citrus.core.State;
	import citrus.physics.box2d.Box2D;
	import citrus.utils.objectmakers.ObjectMaker2D;
	import flash.display.Bitmap;
	
	/**
	 * ...
	 * @author Miguel
	 */
	public class StateGameplay extends SDState 
	{
		private var _tiledMap:XML;
		private var _tileset:Bitmap;
		
		public function StateGameplay(tiledMap:XML, tileset:Bitmap) 
		{
			super();
			
			_tiledMap = tiledMap;
			_tileset = tileset;
		}
		
		override public function initialize():void 
		{
			super.initialize();
			
			var physics:Box2D = new Box2D("physics");
			physics.timeStep = 1 / 30.0;
			physics.visible = Main.DEBUG;
			// 15 is deffault
			physics.gravity.y = 30;
			add(physics);
			
			ObjectMaker2D.FromTiledMap(_tiledMap, [_tileset]);
		}
		
	}

}
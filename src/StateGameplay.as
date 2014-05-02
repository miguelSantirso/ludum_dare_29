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
		[Embed(source="../res/tilesets/tileset_fire.png")]
		private var TilesetFire:Class;
		
		private var _tiledMap:XML;
		
		public function StateGameplay(tiledMap:XML) 
		{
			super();
			
			_tiledMap = tiledMap;
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
			
			var bitmapView:Bitmap = new TilesetFire();     
            bitmapView.name = "tileset_fire.png";  
			
			ObjectMaker2D.FromTiledMap(_tiledMap, [bitmapView]);
		}
		
	}

}
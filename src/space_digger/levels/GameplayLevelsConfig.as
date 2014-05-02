package space_digger.levels 
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Miguel
	 */
	internal final class GameplayLevelsConfig 
	{
		// TILED MAP FILES
		
		[Embed(source="../../../res/levels/level_fire_small_1.tmx", mimeType="application/octet-stream")]
		private static var TiledMapSmall:Class;
		
		
		// TILESETS
		
		[Embed(source="../../../res/tilesets/tileset_fire.png")]
		private static var TilesetFire:Class;
		
		
		private static const TiledMapsByName:Dictionary = new Dictionary();
		private static const TilesetsByName:Dictionary = new Dictionary();
		
		{
			TiledMapsByName['small'] = TiledMapSmall;
			// ...
			
			TilesetsByName['fire'] = TilesetFire;
			// ...
		}
		
		
		public static function tiledMap(templateName:String):XML
		{
			return XML(new TiledMapsByName[templateName]);
		}
		
		public static function tileset(name:String):Bitmap
		{
			var tileset:Bitmap = new TilesetsByName[name];
			tileset.name = "tileset_" + name + ".png";
			return tileset;
		}
		
	}

}
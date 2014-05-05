package space_digger.levels 
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Miguel
	 */
	public final class Levels 
	{
		// TILED MAP FILES
		
		[Embed(source="../../../res/levels/level_fire_small_1.tmx", mimeType="application/octet-stream")]
		public static var TiledMapFireSmall1:Class;
		[Embed(source="../../../res/levels/level_ice_large_1.tmx", mimeType="application/octet-stream")]
		public static var TiledMapIceLarge1:Class;
		[Embed(source="../../../res/levels/level_fire_large_1.tmx", mimeType="application/octet-stream")]
		public static var TiledMapFireLarge1:Class;
		[Embed(source="../../../res/levels/level_forest_large_1.tmx", mimeType="application/octet-stream")]
		public static var TiledMapForestLarge1:Class;
		[Embed(source="../../../res/levels/level_happy_large_1.tmx", mimeType="application/octet-stream")]
		public static var TiledMapHappyLarge1:Class;
		
		// TILESETS
		
		[Embed(source="../../../res/tilesets/tileset_ice.png")]
		private static var TilesetIce:Class;
		[Embed(source="../../../res/tilesets/tileset_fire.png")]
		private static var TilesetFire:Class;
		[Embed(source="../../../res/tilesets/tileset_forest.png")]
		private static var TilesetForest:Class;
		[Embed(source="../../../res/tilesets/tileset_happy.png")]
		private static var TilesetHappy:Class;
		
		private static const TilesetsByName:Dictionary = new Dictionary();
		
		{
			TilesetsByName['tileset_ice'] = TilesetIce;
			TilesetsByName['tileset_fire'] = TilesetFire;
			TilesetsByName['tileset_forest'] = TilesetForest;
			TilesetsByName['tileset_happy'] = TilesetHappy;
			// ...
		}
		
		
		public static function tileset(name:String):Bitmap
		{
			var tileset:Bitmap = new TilesetsByName[name];
			tileset.name = name + ".png";
			return tileset;
		}
		
	}

}
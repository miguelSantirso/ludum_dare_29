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
		
		[Embed(source="../../../res/levels/level_ice_large_1.tmx", mimeType="application/octet-stream")]
		public static var TiledMapIceLarge1:Class;
		[Embed(source="../../../res/levels/level_fire_large_1.tmx", mimeType="application/octet-stream")]
		public static var TiledMapFireLarge1:Class;
		[Embed(source="../../../res/levels/level_forest_large_1.tmx", mimeType="application/octet-stream")]
		public static var TiledMapForestLarge1:Class;
		[Embed(source="../../../res/levels/level_happy_large_1.tmx", mimeType="application/octet-stream")]
		public static var TiledMapHappyLarge1:Class;
		[Embed(source="../../../res/levels/level_water_large_1.tmx", mimeType="application/octet-stream")]
		public static var TiledMapWaterLarge1:Class;
		
		[Embed(source="../../../res/levels/level_ice_medium_1.tmx", mimeType="application/octet-stream")]
		public static var TiledMapIceMedium1:Class;
		[Embed(source="../../../res/levels/level_happy_medium_1.tmx", mimeType="application/octet-stream")]
		public static var TiledMapHappyMedium1:Class;
		[Embed(source="../../../res/levels/level_water_medium_1.tmx", mimeType="application/octet-stream")]
		public static var TiledMapWaterMedium1:Class;
		[Embed(source="../../../res/levels/level_fire_medium_1.tmx", mimeType="application/octet-stream")]
		public static var TiledMapFireMedium1:Class;
		[Embed(source="../../../res/levels/level_forest_medium_1.tmx", mimeType="application/octet-stream")]
		public static var TiledMapForestMedium1:Class;
		
		[Embed(source="../../../res/levels/level_ice_small_1.tmx", mimeType="application/octet-stream")]
		public static var TiledMapIceSmall1:Class;
		[Embed(source="../../../res/levels/level_happy_small_1.tmx", mimeType="application/octet-stream")]
		public static var TiledMapHappySmall1:Class;
		[Embed(source="../../../res/levels/level_water_small_1.tmx", mimeType="application/octet-stream")]
		public static var TiledMapWaterSmall1:Class;
		[Embed(source="../../../res/levels/level_fire_small_1.tmx", mimeType="application/octet-stream")]
		public static var TiledMapFireSmall1:Class;
		[Embed(source="../../../res/levels/level_forest_small_1.tmx", mimeType="application/octet-stream")]
		public static var TiledMapForestSmall1:Class;
		
		[Embed(source="../../../res/levels/level_ice_small_2.tmx", mimeType="application/octet-stream")]
		public static var TiledMapIceSmall2:Class;
		[Embed(source="../../../res/levels/level_happy_small_2.tmx", mimeType="application/octet-stream")]
		public static var TiledMapHappySmall2:Class;
		[Embed(source="../../../res/levels/level_water_small_2.tmx", mimeType="application/octet-stream")]
		public static var TiledMapWaterSmall2:Class;
		[Embed(source="../../../res/levels/level_fire_small_2.tmx", mimeType="application/octet-stream")]
		public static var TiledMapFireSmall2:Class;
		[Embed(source="../../../res/levels/level_forest_small_2.tmx", mimeType="application/octet-stream")]
		public static var TiledMapForestSmall2:Class;
		
		[Embed(source="../../../res/levels/level_ice_medium_2.tmx", mimeType="application/octet-stream")]
		public static var TiledMapIceMedium2:Class;
		[Embed(source="../../../res/levels/level_happy_medium_2.tmx", mimeType="application/octet-stream")]
		public static var TiledMapHappyMedium2:Class;
		[Embed(source="../../../res/levels/level_water_medium_2.tmx", mimeType="application/octet-stream")]
		public static var TiledMapWaterMedium2:Class;
		[Embed(source="../../../res/levels/level_fire_medium_2.tmx", mimeType="application/octet-stream")]
		public static var TiledMapFireMedium2:Class;
		[Embed(source="../../../res/levels/level_forest_medium_2.tmx", mimeType="application/octet-stream")]
		public static var TiledMapForestMedium2:Class;
		
		
		// TILESETS
		
		[Embed(source="../../../res/tilesets/tileset_ice.png")]
		private static var TilesetIce:Class;
		[Embed(source="../../../res/tilesets/tileset_fire.png")]
		private static var TilesetFire:Class;
		[Embed(source="../../../res/tilesets/tileset_forest.png")]
		private static var TilesetForest:Class;
		[Embed(source="../../../res/tilesets/tileset_happy.png")]
		private static var TilesetHappy:Class;
		[Embed(source="../../../res/tilesets/tileset_water.png")]
		private static var TilesetWater:Class;
		
		private static const TiledMaps:Vector.<Class> = new Vector.<Class>;
		private static const TilesetsByName:Dictionary = new Dictionary();
		
		{
			TilesetsByName['tileset_ice'] = TilesetIce;
			TilesetsByName['tileset_fire'] = TilesetFire;
			TilesetsByName['tileset_forest'] = TilesetForest;
			TilesetsByName['tileset_happy'] = TilesetHappy;
			TilesetsByName['tileset_water'] = TilesetWater;
			
			TiledMaps.push(TiledMapIceLarge1); // 1
			TiledMaps.push(TiledMapFireLarge1);
			TiledMaps.push(TiledMapForestLarge1);
			TiledMaps.push(TiledMapHappyLarge1);
			TiledMaps.push(TiledMapWaterLarge1); // 5
			TiledMaps.push(TiledMapIceMedium1); 
			TiledMaps.push(TiledMapHappyMedium1);
			TiledMaps.push(TiledMapWaterMedium1);
			TiledMaps.push(TiledMapFireMedium1);
			TiledMaps.push(TiledMapForestMedium1); // 10
			TiledMaps.push(TiledMapIceSmall1); 
			TiledMaps.push(TiledMapHappySmall1);
			TiledMaps.push(TiledMapWaterSmall1);
			TiledMaps.push(TiledMapFireSmall1);
			TiledMaps.push(TiledMapForestSmall1); // 15
			TiledMaps.push(TiledMapIceSmall2);
			TiledMaps.push(TiledMapHappySmall2);
			TiledMaps.push(TiledMapWaterSmall2);
			TiledMaps.push(TiledMapFireSmall2);
			TiledMaps.push(TiledMapForestSmall2); // 20
			TiledMaps.push(TiledMapIceMedium2);
			TiledMaps.push(TiledMapHappyMedium2);
			TiledMaps.push(TiledMapWaterMedium2);
			TiledMaps.push(TiledMapFireMedium2);
			TiledMaps.push(TiledMapForestMedium2);
		}
		
		
		public static function get nMaps():int
		{
			return TiledMaps.length;
		}
		public static function tiledMap(levelIndex:int):XML
		{
			return XML(new TiledMaps[levelIndex]);
		}
		
		public static function tileset(name:String):Bitmap
		{
			var tileset:Bitmap = new TilesetsByName[name];
			tileset.name = name + ".png";
			return tileset;
		}
		
	}

}
package space_digger.levels 
{
	import Box2D.Dynamics.Contacts.b2PolygonContact;
	import citrus.core.State;
	import flash.display.MovieClip;
	import citrus.objects.CitrusSprite;
	import citrus.objects.CitrusSpritePool;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2D;
	import flash.display.MovieClip;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.platformer.box2d.Coin;
	import citrus.objects.platformer.box2d.Cannon;
	import citrus.utils.objectmakers.ObjectMaker2D;
	import flash.geom.Rectangle;
	import space_digger.GameplayHud;
	import space_digger.PlayerCharacter;
	import traps.TrapSpikes;
	
	import citrus.core.CitrusObject;
	
	/**
	 * ...
	 * @author 10 2  Live Team
	 */
	public class LevelDig extends GameLevel
	{
		private var _decorations:Vector.<CitrusSprite> = new Vector.<CitrusSprite>();
		//protected var sensors:Array;
		
		private var _hud:GameplayHud = new GameplayHud();
		
		public function LevelDig(_level:MovieClip) 
		{
			super(_level);
			
			var objectsUsed:Array = [Hero, Platform, Coin, Cannon, PlayerCharacter, TrapSpikes];
		}
		
		public override function initialize():void
		{
			super.initialize();
			
			//view.camera.setUp(getObjectByName("player_char"));// , new Rectangle(0, 0, 1550, 450), new Point(.25, .05), new Point(stage.stageWidth / 2, stage.stageHeight / 2));
			view.camera.setUp(getObjectByName("player_char"), new Rectangle(0, 0, 1352, 1963));
			//createDecorationSprites();
			
			var seams:Vector.<CitrusObject> = getObjectsByName("seam");
			for each (var seam:Sensor in seams)
			{
				seam.onBeginContact.add(onSeamEnter);
				seam.onEndContact.add(onSeamExit);
			}
			
			stage.addChild(_hud);
		}
		
		private function onSeamEnter(contact:b2PolygonContact):void
		{
			_hud.onSeamEntered();
		}
		private function onSeamExit(contact:b2PolygonContact):void
		{
			_hud.onSeamExited();
		}
		
		public override function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			//updateDecorationOcclusion();
		}
		
		public override function dispose():void
		{
			_decorations.splice(0, _decorations.length);
			
			super.dispose();
		}
		
		/*public function updateDecorationOcclusion():void
		{
			var nDecorations:int = _decorations.length;
			var decor:CitrusSprite;
			for (var i:int = 0; i < nDecorations; ++i)
			{
				var child:MovieClip;
				decor = _decorations[i];
				//decor.visible = view.camera.contains(decor.x, decor.y);
			}
		}*/
		
		public function createDecorationSprites():void
		{
			var child:MovieClip;
			
			while (level.numChildren > 0)
			{
				child = level.getChildAt(0) as MovieClip;
				level.removeChildAt(0);
				
				if (child)
				{
					var cs:CitrusSprite = new CitrusSprite("rock");
					cs.x = child.x;
					cs.y = child.y;
					cs.updateCallEnabled = false;
					child.x = child.y = 0;
					cs.view = child;
					add(cs);
					_decorations.push(cs);
				}
			}
		}
	}
}
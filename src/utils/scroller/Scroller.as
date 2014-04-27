package utils.scroller
{
	import com.greensock.TimelineLite;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import com.greensock.TweenMax;
	/**
	 * ...
	 * @author Albert Badosa Solé
	 */
	public class Scroller extends Sprite
	{
		protected static const MAX_INERTIA_DURATION_DEFAULT:Number = 0.5;
		protected static const SCROLLER_SPEED_FACTOR_X:Number = 2;

		protected var _scrollerMask:Shape;
		protected var _scrollerItemsToShow:Number;
		protected var _scrollerCanvas:Sprite;
		protected var _scrollerItemRenderer:Class;
		protected var _scrollerContent:Array;
		protected var _scrollerLayout:Boolean; // H = true, V = false
		protected var _scrollerGap:Number;
		protected var _scrollerCanvasBgColor:uint;
		protected var _scrollerCanvasBgAlpha:Number;
		protected var _scrollerInertiaEnabled:Boolean;
		protected var _scrollerInertiaMaxDuration:Number;

		private var _isMouseDown:Boolean = false;
		private var _startDragPosition:Number = 0;
		private var _previousDragPosition:Number = 0;
		private var _currentDragPosition:Number = 0;
		private var _lastPositionDelta:Number = 0;
		private var _startDragTime:Number = 0;
		private var _stopDragTime:Number = 0;
		private var _scrollerCanvasMaxPos:Number;
		private var _dragDeltaTimer:Timer;

		public function Scroller(layout:Boolean, 
								   itemsToShow:Number, 
								   ir:Class, itemsGap:Number = 0,
								   dataProvider:Array = null,
								   bgColor:uint = 0,
								   bgAlpha:Number = 0,
								   inertiaMaxDuration:Number = MAX_INERTIA_DURATION_DEFAULT) 
		{
			_scrollerLayout = layout;
			_scrollerItemRenderer = ir;
			_scrollerGap = itemsGap;
			_scrollerCanvasBgColor = bgColor;
			_scrollerCanvasBgAlpha = bgAlpha;

			inertiaMaxDurationInSec = inertiaMaxDuration;

			_scrollerMask = new Shape();

			_scrollerCanvas = new Sprite();
			_scrollerCanvas.mask = _scrollerMask;

			this.dataProvider = dataProvider;

			this.itemsToShow = itemsToShow;

			addChild(_scrollerMask);
			addChild(_scrollerCanvas);
		}

		public function init(event:Event = null):void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseHandler, false, 0, true);

			_dragDeltaTimer = new Timer(50, 0);
			_dragDeltaTimer.addEventListener(TimerEvent.TIMER, onCalculateCurrentDragDelta, false, 0, true);
		}

		public function update(event:Event = null):void
		{
		}

		public function dispose(event:Event = null):void
		{
			// TO-DO
		}

		public function set scrollerLayout(layout:Boolean):void
		{
			_scrollerLayout = layout;
		}

		public function set scrollerWidth(w:Number):void
		{
			_scrollerMask.width = w;
			refreshMask();
		}

		public function set scrollerHeight(h:Number):void
		{
			_scrollerMask.height = h;
			refreshMask();
		}

		public function set itemsToShow(num:Number):void
		{
			_scrollerItemsToShow = num;
			refreshMask();
		}

		public function set scrollerItemRenderer(ir:Class):void
		{
			_scrollerItemRenderer = ir;
		}

		public function set dataProvider(data:Array):void
		{
			if (data != null && data.length > 0)
			{
				_scrollerContent = new Array();

				for each(var obj:Object in data)
					_scrollerContent.push(obj);

				refreshCanvas();
			}
			else _scrollerContent = new Array();
		}

		public function set inertiaMaxDurationInSec(value:Number):void
		{
			_scrollerInertiaMaxDuration = value;
			_scrollerInertiaEnabled = _scrollerInertiaMaxDuration > 0;
		}

		public function set enableInertia(value:Boolean):void
		{
			_scrollerInertiaEnabled = value;
		}

		public function addItem(item:Object):void
		{
			_scrollerContent.push(item);
			refreshCanvas();
		}

		private function refreshScroller():void
		{
			refreshMask();
			refreshCanvas();
		}

		private function refreshMask():void
		{
			var auxIR:DisplayObject = new _scrollerItemRenderer();

			var maskW:int = _scrollerLayout
				? (auxIR.width * _scrollerItemsToShow) + (_scrollerGap * (Math.ceil(_scrollerItemsToShow) - 1))
				: auxIR.width;

			var maskH:int = _scrollerLayout
				? auxIR.height
				: (auxIR.height * _scrollerItemsToShow) + (_scrollerGap * (Math.ceil(_scrollerItemsToShow) - 1));

			_scrollerCanvasMaxPos = _scrollerLayout 
				? _scrollerCanvas.width - maskW
				: _scrollerCanvas.height - maskH;

			_scrollerMask.graphics.clear();
			_scrollerMask.graphics.beginFill(0x000000);
			_scrollerMask.graphics.drawRect(0, 0, maskW, maskH);
			_scrollerMask.graphics.endFill();
		}

		private function refreshCanvas():void
		{
			_scrollerCanvas.removeChildren();

			for (var i:int = 0; i < _scrollerContent.length; i++)
			{
				var newIR:Sprite = new _scrollerItemRenderer();

				(newIR as _scrollerItemRenderer).data = _scrollerContent[i];

				if (_scrollerLayout)
				{
					newIR.x = Math.floor(i * (newIR.width + _scrollerGap));
					newIR.y = 0;
				}
				else
				{
					newIR.x = 0;
					newIR.y = Math.floor(i * (newIR.height + _scrollerGap));
				}

				_scrollerCanvas.addChild(newIR);
			}

			_scrollerCanvas.graphics.beginFill(_scrollerCanvasBgColor, _scrollerCanvasBgAlpha);
			_scrollerCanvas.graphics.drawRect(0, 0, _scrollerCanvas.width, _scrollerCanvas.height);
			_scrollerCanvas.graphics.endFill();
		}

		private function onMouseHandler(e:MouseEvent):void
		{	
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					//Main.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseHandler, false, 0, true);

					_isMouseDown = true;
					_startDragPosition = _scrollerLayout ? _scrollerCanvas.x : _scrollerCanvas.y;
					_startDragTime = (new Date()).getTime();

					_previousDragPosition = _scrollerLayout ? _scrollerCanvas.x : _scrollerCanvas.y;

					_dragDeltaTimer.reset();
					_dragDeltaTimer.start();

					if(_scrollerInertiaEnabled) TweenMax.killAll();

					var auxIRSize:Number = _scrollerLayout
						? (new _scrollerItemRenderer()).width
						: (new _scrollerItemRenderer()).height;

					var auxScrollerCanvasSize:Number = _scrollerLayout
						? _scrollerCanvas.width
						: _scrollerCanvas.height;

						if (_scrollerLayout)
						{
							_scrollerCanvas.startDrag(false,  new Rectangle(
								-auxScrollerCanvasSize + ((_scrollerItemsToShow * auxIRSize) + (_scrollerGap * (_scrollerItemsToShow - 1))),
								0, 
								auxScrollerCanvasSize - ((_scrollerItemsToShow * auxIRSize) + (_scrollerGap * (_scrollerItemsToShow - 1))), 
								0));
						}
						else
						{
							_scrollerCanvas.startDrag(false,  new Rectangle(
								0,
								-auxScrollerCanvasSize + ((_scrollerItemsToShow * auxIRSize) + (_scrollerGap * (_scrollerItemsToShow - 1))), 
								0, 
								auxScrollerCanvasSize - ((_scrollerItemsToShow * auxIRSize) + (_scrollerGap * (_scrollerItemsToShow - 1)))));
						}
					break;

				case MouseEvent.MOUSE_OUT:
				case MouseEvent.MOUSE_UP:
					//Main.removeEventListener(MouseEvent.MOUSE_UP, onMouseHandler);

					if (_isMouseDown)
					{
						_isMouseDown = false;
						_currentDragPosition = _scrollerLayout ? _scrollerCanvas.x : _scrollerCanvas.y;
						_stopDragTime = (new Date()).getTime();

						_scrollerCanvas.stopDrag();
						_dragDeltaTimer.stop();

						if (_scrollerInertiaEnabled)
						{
							var deltaPosition:Number = _currentDragPosition - _startDragPosition;
							var deltaDuration:Number = _stopDragTime - _startDragTime;
							var inertiaFactor:Number = Math.abs((_lastPositionDelta / deltaDuration));

							if (inertiaFactor > SCROLLER_SPEED_FACTOR_X) 
							{
								inertiaFactor = SCROLLER_SPEED_FACTOR_X;
							}

							if (_scrollerLayout)
							{
								var toX:Number = _currentDragPosition + (deltaPosition * inertiaFactor);

								TweenMax.to(_scrollerCanvas, _scrollerInertiaMaxDuration, 
									{ x:toX, y:_scrollerCanvas.y, onUpdateParams: ["_scrollerCanvas"], onUpdate: onUpdateTween } );
							}
							else
							{
								var toY:Number = _currentDragPosition + (deltaPosition * inertiaFactor);

								TweenMax.to(_scrollerCanvas, _scrollerInertiaMaxDuration, 
									{ x:_scrollerCanvas.x, y:toY, onUpdateParams: ["_scrollerCanvas"], onUpdate: onUpdateTween } );
							}
						}
					}

					break;
			}
		}

		private function onUpdateTween(params:String):void
		{
			if (params == "_scrollerCanvas")
			{
				if (_scrollerLayout)
				{
					if ( -_scrollerCanvas.x > _scrollerCanvasMaxPos)
					{
						_scrollerCanvas.x = -_scrollerCanvasMaxPos;
						TweenMax.killAll();
					}
					else if ( -_scrollerCanvas.x < 0)
					{
						_scrollerCanvas.x = 0;
						TweenMax.killAll();
					}
				}
				else
				{
					if ( -_scrollerCanvas.y > _scrollerCanvasMaxPos)
					{
						_scrollerCanvas.y = -_scrollerCanvasMaxPos;
						TweenMax.killAll();
					}
					else if ( -_scrollerCanvas.y < 0)
					{
						_scrollerCanvas.y = 0;
						TweenMax.killAll();
					}
				}
			}
		}

		private function onCalculateCurrentDragDelta(e:TimerEvent):void
		{
			_currentDragPosition = _scrollerLayout ? _scrollerCanvas.x : _scrollerCanvas.y;
			_lastPositionDelta = Math.abs(_currentDragPosition - _previousDragPosition);
			_previousDragPosition = _currentDragPosition;
		}
	}
}
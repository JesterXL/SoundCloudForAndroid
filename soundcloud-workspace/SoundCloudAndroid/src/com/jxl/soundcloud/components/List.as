package com.jxl.soundcloud.components
{
	
	import com.bit101.components.Component;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.jxl.soundcloud.components.IItemRenderer;
	import com.jxl.soundcloud.events.ListEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.GestureEvent;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Rectangle;
	
	
	[Event(name="itemClicked", type="com.jxl.soundcloud.events.ListEvent")]
	public class List extends Component
	{
		private static const SCROLL_TWEEN_TIME:Number = 3;
		
		private var _items:Array;
		private var itemsDirty:Boolean = false;
		private var _itemRenderer:Class;
		private var itemRendererDirty:Boolean = false;
		
		private var itemsPerPage:Number;
		private var pageHeight:Number;
		private var oldWidth:Number;
		private var oldHeight:Number;
		private var currentPage:Number;
		private var totalPages:Number;
		private var listOffsetY:Number;
		
		private var listContent:Sprite;
		private var listMask:Shape;
		
		public function get items():Array { return _items; }
		public function set items(value:Array):void
		{
			_items = value;
			itemsDirty = true;
			invalidateProperties();
		}
		
		public function get itemRenderer():Class { return _itemRenderer; }
		public function set itemRenderer(value:Class):void
		{
			_itemRenderer = value;
			itemRendererDirty = true;
			invalidateProperties();
		}
		
		public function List(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}

        public function scrollToPageShowingItem(item:*):void
        {
            if(item == null || _items == null) return;

            var itemIndex:int = _items.indexOf(item);
            if(itemIndex == -1) return;

            var targetPage:int = Math.floor(itemIndex / itemsPerPage);
            if(currentPage != targetPage)
                goToPage(targetPage);
        }
		
		protected override function init():void
		{
			super.init();
			setSize(100, 100);
			this.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
		}
		
		protected override function addChildren():void
		{
			super.addChildren();
			
			listMask = new Shape();
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(itemsDirty || itemRendererDirty)
			{
				itemsDirty = false;
				itemRendererDirty = false;
				redrawListItems();
				draw();
			}
		}
		
		public override function draw():void
		{
			super.draw();
			
			const MARGIN:Number = 4;
			
			if(oldWidth != width || oldHeight != height)
			{
				oldWidth = width;
				oldHeight = height;
				if(_items && _items.length > 0 && listContent && listContent.numChildren > 0)
				{
					var item:IItemRenderer = listContent.getChildAt(0) as IItemRenderer;
					calculateItemsPerPage(item.height);
					resizeChildren();
				}
			}
		}
		
		private function redrawListItems():void
		{
			oldWidth = width;
			oldHeight = height;
			if(listContent)
			{
				removeChildren(listContent)
			}
			else
			{
				listContent = new Sprite();
				addChildAt(listContent, 0);
				listOffsetY = 0;
				listContent.y = listOffsetY;
			}
			
			if(_items == null) return;
			if(_items.length < 1) return;
			
			//listContent.cacheAsBitmap = false;
			
			var len:int = _items.length;
			var startY:Number = 0;
			var calculatedPageHeight:Boolean = false;
			const MARGIN:Number = 20;
			for(var index:int = 0; index < len; index++)
			{
				try
				{
					var renderer:IItemRenderer = new _itemRenderer() as IItemRenderer;
				}
				catch(err:Error)
				{
					Debug.log("List::redrawListItems, failure to create renderer instantiation.");
					return;
				}
				if(renderer == null)
				{
					Debug.log("List::redrawListItems, failure to create renderer, probably doesn't implement IItemRenderer");
					return;
				}
				if(calculatedPageHeight == false)
				{
					calculatedPageHeight = true;
					calculateItemsPerPage(renderer.height);
				}
				renderer.data = _items[index];
				renderer.y = startY;
				renderer.width = width;
				startY += renderer.height + MARGIN;
				listContent.addChild(DisplayObject(renderer));
				//renderer.addEventListener(MouseEvent.CLICK, onItemClick, false, 0, true);
			}
			
			//listContent.cacheAsBitmap = true;
			
			var g:Graphics = listMask.graphics;
			g.clear();
			g.beginFill(0x00FF00, .5);
			g.drawRect(0, 0, width, pageHeight + 1);
			g.endFill();
			if(contains(listMask) == false) addChild(listMask);
			setChildIndex(listMask, numChildren - 1);
			listMask.y = listOffsetY;
			listContent.mask = listMask;
			
			scrollRect = new Rectangle(0, 0, width, height);
			
			currentPage = 0;
		}
		
		private function resizeChildren():void
		{
			var len:int = _items.length;
			var startY:Number = 0;
			for(var index:int = 0; index < len; index++)
			{
				var renderer:IItemRenderer = listContent.getChildAt(index) as IItemRenderer;
				renderer.y = startY;
				renderer.width = width;
				startY += renderer.height + MARGIN;
			}
			
			listMask.width = width;
			scrollRect = new Rectangle(0, 0, width, height);
		}
		
		private function calculateItemsPerPage(itemRendererHeight:Number):void
		{
			const MARGIN:Number = 4;
			const AVAILABlE_HEIGHT:Number = height;
			itemsPerPage = 0;
			pageHeight = 0;
			totalPages = 0;
			if(AVAILABlE_HEIGHT > 0 && AVAILABlE_HEIGHT >= itemRendererHeight)
			{
				itemsPerPage = Math.round(AVAILABlE_HEIGHT / itemRendererHeight);
				pageHeight = itemsPerPage * itemRendererHeight;
				totalPages = Math.round(_items.length / itemsPerPage);
			}
		}
		
		private function removeChildren(container:DisplayObjectContainer):void
		{
			var i:int = container.numChildren;
			while(i--)
			{
				container.removeChildAt(i);
			}
		}
		
		private function getListContentYFromCurrentPage():Number
		{
			return -1 * (currentPage * pageHeight) + listOffsetY;
		}
		
		public function scrollDown():void
		{
			if(currentPage + 1 < totalPages)
			{
				currentPage++;
				TweenLite.to(listContent, SCROLL_TWEEN_TIME, {y: getListContentYFromCurrentPage(), ease: Expo.easeOut});
			}
		}
		
		public function scrollUp():void
		{
			if(currentPage - 1 > -1)
			{
				currentPage--;
				TweenLite.to(listContent, SCROLL_TWEEN_TIME, {y: getListContentYFromCurrentPage(), ease: Expo.easeOut});
			}
		}
		
		public function goToPage(page:uint):void
		{
			currentPage = page;
			if(listContent == null || isNaN(getListContentYFromCurrentPage())) return;
			TweenLite.to(listContent, SCROLL_TWEEN_TIME, {y: getListContentYFromCurrentPage(), ease: Expo.easeOut});
		}
		
		/*
		private function onItemClick(event:MouseEvent):void
		{
			var listItem:IItemRenderer = event.target as IItemRenderer;
			var evt:ListEvent = new ListEvent(ListEvent.ITEM_CLICKED);
			evt.data = listItem.data;
			evt.index = _items.indexOf(listItem.data);
			dispatchEvent(evt);
		}
		*/
		
		/*ction onScrollUp(evnet:MouseEvent):void
		{
			scrollUp();
		}
		
		private function onScrollDown(event:MouseEvent):void
		{
			scrollDown();
		}
		*/
		private function onSwipe(event:TransformGestureEvent):void
		{
			if(event.offsetY == 1)
			{
				scrollUp();
			}
			else
			{
				scrollDown();
			}
		}
		
	}
}
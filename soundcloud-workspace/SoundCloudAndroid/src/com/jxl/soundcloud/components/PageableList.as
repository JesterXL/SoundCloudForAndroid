package com.jxl.soundcloud.components
{
	import com.bit101.components.Component;
	import com.jxl.soundcloud.events.ButtonBarEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	
	import spark.primitives.Graphic;
	
	public class PageableList extends Component
	{
		
		private var list:List;
		private var buttonBar:ButtonBar;
		
		private var _items:Array;
		private var itemsDirty:Boolean 			= false;
		private var _itemRenderer:Class;
		private var itemRendererDirty:Boolean 	= false;
		private var _itemsPerPage:uint = 4;
		private var itemsPerPageDirty:Boolean 	= true;
		private var _currentPage:uint = 0;
		private var currentPageDirty:Boolean 	= true;
		
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
		
		public function get itemsPerPage():uint { return _itemsPerPage; }
		public function set itemsPerPage(value:uint):void
		{
			_itemsPerPage 			= value;
			itemsPerPageDirty 		= true;
			invalidateProperties();
		}
		
		public function get currentPage():uint { return _currentPage; }
		public function set currentPage(value:uint):void
		{
			_currentPage = value;
			currentPageDirty = true;
			invalidateProperties();
		}
		
		public function PageableList(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			
			setSize(320, 370);
		}

        public function scrollToPageShowingItem(item:*):void
        {
            list.scrollToPageShowingItem(item);
        }
		
		public function containsItem(item:*):Boolean
		{
			if(_items && _items.indexOf(item) != -1)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		protected override function addChildren():void
		{
			super.addChildren();
			
			list = new List();
			addChild(list);
			
			buttonBar = new ButtonBar();
			addChild(buttonBar);
			buttonBar.addEventListener(ButtonBarEvent.CURRENT_PAGE_CHANGED, onCurrentPageChanged);
		}
		
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(itemsDirty)
			{
				itemsDirty = false;
				list.items = _items;
				buttonBar.dataProvider = _items;
				invalidateDraw();
			}
			
			if(itemRendererDirty)
			{
				itemRendererDirty = false;
				list.itemRenderer  = _itemRenderer;
				invalidateDraw();
			}
			
			if(itemsPerPageDirty)
			{
				itemsPerPageDirty = false;
				buttonBar.itemsPerPage = _itemsPerPage;
			}
			
			if(currentPageDirty)
			{
				currentPageDirty = false;
				buttonBar.currentPage = _currentPage;
				updateListDataToCurrentPage();
			}
		}
		
		public override function draw():void
		{
			super.draw();
			
			list.setSize(width, height - buttonBar.height);
			buttonBar.setSize(width, buttonBar.height);
			buttonBar.y = height - buttonBar.height;

            /*
			var g:Graphics = graphics;
			g.clear();
			g.lineStyle(0, 0xFF0000);
			g.drawRect(0, 0, width, height);
			
			g.lineStyle(0, 0x0000FF);
			g.drawRect(list.x, list.y, list.width, list.height);
			g.endFill();
			*/
			
		}
		
		private function onCurrentPageChanged(event:ButtonBarEvent):void
		{
			_currentPage = buttonBar.currentPage;
			this.callNextFrame(updateListDataToCurrentPage);
		}
		
		private function updateListDataToCurrentPage():void
		{
			/*
			var total:int 			= currentPage * itemsPerPage;
			var range:int 			= Math.min(total + itemsPerPage, items.length);
			var pageArray:Array 	= items.slice(total, range);
			list.items 				= pageArray;
			*/
			list.goToPage(currentPage);
		}
	}
}
package com.jxl.soundcloud.components
{
	import com.bit101.components.Component;
	import com.jxl.soundcloud.events.ButtonBarEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.formats.BaselineOffset;
	
	
	[Event(name="currentPageChanged", type="com.jxl.soundcloud.events.ButtonBarEvent")]
	public class ButtonBar extends Component
	{
		
		private static const BUTTON_WIDTH:Number 		= 72;
		private static const BUTTON_HEIGHT:Number 		= 72;
		private static const MARGIN:Number 				= 8;
		
		private var _dataProvider:Array;
		private var dataProviderDirty:Boolean = false;
		private var _itemsPerPage:uint = 4;
		private var itemsPerPageDirty:Boolean = false;
		private var _currentPage:uint = 0;
		private var currentPageDirty:Boolean = false;
		
		private var buttonPool:Array = [];
		private var buttonMap:Dictionary = new Dictionary();
		private var dotTextField:TextField;
		private var previousButton:PushButton;
		private var nextButton:PushButton;
		private var buttonsHolder:Sprite;
		
		public function get dataProvider():Array { return _dataProvider; }
		public function set dataProvider(value:Array):void
		{
			_dataProvider 		= value;
			dataProviderDirty 	= true;
			invalidateProperties();
		}
		
		public function get itemsPerPage():uint { return _itemsPerPage; }
		public function set itemsPerPage(value:uint):void
		{
			if(value < 1) value 	= 1;
			_itemsPerPage 			= value;
			itemsPerPageDirty 		= true;
			invalidateProperties();
		}
		
		public function get currentPage():uint { return _currentPage; }
		public function set currentPage(value:uint):void
		{
			if(_currentPage !== value)
			{
				_currentPage = value;
				currentPageDirty = true;
				invalidateProperties();
				var evt:ButtonBarEvent = new ButtonBarEvent(ButtonBarEvent.CURRENT_PAGE_CHANGED);
				evt.currentPage = _currentPage;
				dispatchEvent(evt);
			}
		}
		
		public function ButtonBar(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		protected override function init():void
		{
			super.init();
			
			height = 72;
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(dataProviderDirty || itemsPerPageDirty)
			{
				dataProviderDirty 	= false;
				itemsPerPageDirty 	= false;
				redraw();
			}
			
			if(currentPageDirty)
			{
				currentPageDirty = false;
				if(dataProvider || dataProvider.length > 0)
				{
					//updateCurrentPage(); // TODO
					redraw();
				}
			}
		}
		
		protected override function addChildren():void
		{
			super.addChildren();
			
			buttonsHolder = new Sprite();
			addChild(buttonsHolder);
			
			previousButton = new PushButton();
			previousButton.label = "Prev";
			previousButton.addEventListener(MouseEvent.CLICK, onPrevious);
			
			dotTextField = new TextField();
			dotTextField.text = "...";
			dotTextField.autoSize = "left";
			
			nextButton 			= new PushButton();
			nextButton.label 	= "Next";
			nextButton.addEventListener(MouseEvent.CLICK, onNext);
			
			nextButton.height = previousButton.height = BUTTON_HEIGHT;
		}
		
		private function redraw():void
		{
			removeAllButtons();
			if(dotTextField && contains(dotTextField)) 		removeChild(dotTextField);
			if(nextButton && contains(nextButton)) 			removeChild(nextButton);
			if(previousButton && contains(previousButton)) 	removeChild(previousButton);
			
			if(_dataProvider == null || _dataProvider.length < 1) return;
			
			const totalPages:uint 			= getTotalPages();
			var startX:Number 				= 0;
			var onLastPage:Boolean;
			if(currentPage == totalPages - itemsPerPage)
			{
				onLastPage = true;
			}
			else
			{
				onLastPage = false;
			}
			
			startX += previousButton.width + MARGIN;
			if(_currentPage > 0)
				addChild(previousButton);
			
			var counter:int = -1;
			var startIndex:int = currentPage;
			var max:int = Math.min(totalPages, currentPage + itemsPerPage);
			for(var index:uint = startIndex; index < max; index++)
			{
				counter++;
				
				// show textfield, and where
				if(totalPages > itemsPerPage)
				{
					if( (onLastPage == false && counter == itemsPerPage - 1) || (onLastPage && counter == 1))
					{
						if(contains(dotTextField) == false) addChild(dotTextField);
						dotTextField.x = startX;
						dotTextField.y = height - (dotTextField.textHeight + 4);
						startX += dotTextField.textWidth + 4 + MARGIN;
					}
				}
				
				var button:PushButton = getButton();
				buttonsHolder.addChild(button);
				button.toggle = true;
				button.addEventListener(MouseEvent.CLICK, onButtonClick);
				button.x = startX;
				button.setSize(BUTTON_WIDTH, BUTTON_HEIGHT);
				startX += button.width + MARGIN;
				
				// handle labeling of the buttons
				if(onLastPage == false)
				{
					if(index + 1 < max)
					{
						button.label = String(currentPage + 1 + counter);
					}
					else
					{
						button.label = String(totalPages);
					}
				}
				else
				{
					if(counter == 0)
					{
						button.label = "1";
					}
					else
					{
						button.label = String(currentPage + 1 + counter);
					}
				}
				
				if(parseInt(button.label) - 1 == currentPage)
				{
					button.selected = true;
				}
				else
				{
					button.selected = false;
				}
			}
			
			if(onLastPage == false)
			{
				if(contains(nextButton) == false) addChild(nextButton);
				nextButton.x = startX;
				startX += nextButton.width + MARGIN;
			}
		}
		
		private function updateCurrentPage():void
		{
			
		}
		
		private function getButton():PushButton
		{
			if(buttonPool.length > 0)
			{
				return buttonPool.pop();
			}
			else
			{
				return new PushButton();
			}
		}
		
		private function removeAllButtons():void
		{
			var len:int = buttonsHolder.numChildren;
			while(len--)
			{
				var child:DisplayObject = buttonsHolder.removeChildAt(len);
				delete buttonMap[child];
				if(child is PushButton)
				{
					var button:PushButton = child as PushButton;
					button.removeEventListener(MouseEvent.CLICK, onButtonClick);
					buttonPool.push(button);
				}
			}
		}
		
		private function onButtonClick(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			const totalPages:uint = getTotalPages();
			/*
			var targetPage:int = buttonMap[event.target];
			Debug.logHeader();
			Debug.log("targetPage: " + targetPage);
			Debug.log("label: " + PushButton(event.target).label);
			if(targetPage > totalPages - 3)
			{
				targetPage = totalPages - 3;
			}
			Debug.log("coerced targetPage: " + targetPage);
			currentPage = targetPage;
			*/
			var targetPage:uint = parseInt(PushButton(event.target).label) - 1;
			currentPage = targetPage;
		}
		
		private function onPrevious(event:MouseEvent):void
		{
			if(_currentPage > 0)
			{
				currentPage--;
			}
		}
		
		private function onNext(event:MouseEvent):void
		{
			const totalPages:uint = getTotalPages();
			if(_currentPage < totalPages - 1)
			{
				currentPage++;
			}
		}
		
		private function getTotalPages():uint
		{
			return Math.ceil(_dataProvider.length / _itemsPerPage);
		}
	}
}
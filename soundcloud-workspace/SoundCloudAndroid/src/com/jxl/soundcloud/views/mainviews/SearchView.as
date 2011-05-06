package com.jxl.soundcloud.views.mainviews
{
	import assets.Styles;
	import assets.flash.LoaderAnimation;
	
	import com.bit101.components.Component;
	import com.jxl.soundcloud.components.DraggableList;
	import com.jxl.soundcloud.components.LinkButton;
	import com.jxl.soundcloud.components.PageableList;
	import com.jxl.soundcloud.components.PushButton;
	import com.jxl.soundcloud.components.SearchInputText;
	import com.jxl.soundcloud.components.SongItemRenderer;
	import com.jxl.soundcloud.events.InputTextEvent;
	import com.jxl.soundcloud.events.SearchViewEvent;
	import com.jxl.soundcloud.vo.SongVO;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	[Event(name="search", type="com.jxl.soundcloud.events.SearchViewEvent")]
	[Event(name="back", type="com.jxl.soundcloud.events.SearchViewEvent")]
	[Event(name="play", type="com.jxl.soundcloud.events.SongEvent")]
	[Event(name="stop", type="com.jxl.soundcloud.events.SongEvent")]
	[Event(name="seekClicked", type="com.jxl.soundcloud.events.SongEvent")]
	public class SearchView extends Component
	{
		
		public static const STATE_SEARCH:String 					= "searchState";
		public static const STATE_LOADING:String 					= "loadingState";
		public static const STATE_SEARCH_RESULTS:String 			= "searchResultsState";
		
		
		private var searchInput:SearchInputText;
		private var searchButton:PushButton;
		private var animation:LoaderAnimation;
		private var searchList:DraggableList;
		private var noSearchResults:TextField;
		
		private var _searchResults:Array;
		private var searchResultsDirty:Boolean = false;
		
		public function get searchResults():Array { return _searchResults; }
		public function set searchResults(value:Array):void
		{
			if(_searchResults !== value)
			{
				_searchResults = value;
				searchResultsDirty = true;
				invalidateProperties();
			}
		}
		
		public function SearchView(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		/*
		public function containsItem(item:*):Boolean
		{
			if(searchList && searchList.containsItem(item))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function scrollToPageShowingItem(item:*):void
		{
			if(searchList)
				searchList.scrollToPageShowingItem(item);
		}
		*/
		
		protected override function init():void
		{
			super.init();
			
			setSize(480, 465);
			currentState = STATE_SEARCH;
			this.addEventListener(Event.ADDED, onAdded);
		}
		
		private function onAdded(event:Event):void
		{
			this.removeEventListener(Event.ADDED, onAdded);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(searchResultsDirty)
			{
				searchResultsDirty = false;
				if(searchList)
				{
					searchList.items = _searchResults;
				}
			}
		}
		
		public override function draw():void
		{
			super.draw();
			
			if(searchInput && searchButton)
			{
				searchButton.setSize(100, 72);
				searchButton.y = 44;
				
				searchInput.width = width - searchButton.width - 12;
				searchInput.move(4, searchButton.y + (searchButton.height / 2) - (searchInput.height / 2));

				searchButton.x = searchInput.x + searchInput.width + 4;
			}
			
			if(animation)
			{
				animation.x = (width / 2) - (animation.width / 2);
				animation.y = 22;
			}

			if(searchList)
			{	
				searchList.move(0, 0);
				searchList.setSize(width, height);
			}
			
			if(noSearchResults)
			{
				noSearchResults.x = (width / 2) - (noSearchResults.width / 2);
				noSearchResults.y = noSearchResults.y + 20;
			}
			
		}
		
		private function showNoSearchResults():void
		{
			if(noSearchResults == null)
			{
				noSearchResults = new TextField();
				noSearchResults.defaultTextFormat = Styles.FORM_LABEL;
				noSearchResults.embedFonts = true;
				noSearchResults.multiline = true;
				noSearchResults.wordWrap = true;
				noSearchResults.selectable = false;
				noSearchResults.mouseEnabled = false;
				noSearchResults.tabEnabled = false;
				noSearchResults.width = 300;
				noSearchResults.text = "No search results found.\n\nTry another search term (artist, genre, etc).";
			}
			
			if(contains(noSearchResults) == false)
				addChild(noSearchResults);
			draw();
		}
		
		private function hideNoSearchResults():void
		{
			if(noSearchResults)
			{
				if(contains(noSearchResults))
					removeChild(noSearchResults);
			}
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			// don't handle unless you're actually showing
			if(stage == null) return;
			
			switch(event.keyCode)
			{
				case Keyboard.BACK:
					switch(currentState)
					{
						case STATE_LOADING:
						case STATE_SEARCH_RESULTS:
							event.preventDefault();
							currentState = STATE_SEARCH;
							dispatchEvent(new SearchViewEvent(SearchViewEvent.BACK));
							break;
						
						case STATE_SEARCH:
						default:
							// zee goggles, do nuffing!
							break;
					}
					break;
			}
		}
		
		protected override function onEnterState(state:String):void
		{
			switch(state)
			{
				case STATE_SEARCH:
					
					if(searchInput == null)
					{
						searchInput = new SearchInputText();
						searchInput.addEventListener(InputTextEvent.ENTER_PRESSED, onEnterPressed);
					}
					
					if(searchButton == null)
					{
						searchButton = new PushButton();
						searchButton.label = "Search";
						searchButton.addEventListener(MouseEvent.CLICK, onSearch);
					}
					
					if(contains(searchInput) == false)
						addChild(searchInput);
					
					if(contains(searchButton) == false)
						addChild(searchButton);
					
					break;
				
				case STATE_LOADING:
					if(animation == null)
						animation = new LoaderAnimation();
					
					if(contains(animation) == false)
						addChild(animation);
					break;
			
				case STATE_SEARCH_RESULTS:
					if(searchList == null)
					{
						searchList = new DraggableList();
						searchList.itemRenderer = SongItemRenderer;
					}
					if(contains(searchList) == false)
						addChild(searchList);
					
					searchList.items = _searchResults;
					break;
			}
			
			draw();
		}
		
		protected override function onExitState(oldState:String):void
		{
			switch(oldState)
			{
				case STATE_SEARCH:
					if(contains(searchInput))
						removeChild(searchInput);
					
					if(contains(searchButton))
						removeChild(searchButton);
					
					break;
				
				case STATE_LOADING:
					if(contains(animation))
						removeChild(animation);
					break;
				
				case STATE_SEARCH_RESULTS:
					if(contains(searchList))
						removeChild(searchList);
					break;
					
				
			}
		}
		
		private function onSearch(event:MouseEvent):void
		{
			dispatchSearchEvent();
		}
		
		private function onEnterPressed(event:InputTextEvent):void
		{
			dispatchSearchEvent();
		}
		
		private function dispatchSearchEvent():void
		{
			var evt:SearchViewEvent 		= new SearchViewEvent(SearchViewEvent.SEARCH);
			evt.searchString 				= searchInput.text;
			dispatchEvent(evt);
		}
	}
}
package com.jxl.soundcloud.views.mainviews
{
	import assets.Styles;
	import assets.flash.LoaderAnimation;
	
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.jxl.soundcloud.Constants;
	import com.jxl.soundcloud.components.DraggableList;
	import com.jxl.soundcloud.components.LinkButton;
	import com.jxl.soundcloud.components.List;
	import com.jxl.soundcloud.components.PageableList;
	import com.jxl.soundcloud.components.PlaybackControls;
	import com.jxl.soundcloud.components.SearchInputText;
	import com.jxl.soundcloud.components.SongItemRenderer;
	import com.jxl.soundcloud.components.Tab;
	import com.jxl.soundcloud.components.VolumeSlider;
	import com.jxl.soundcloud.events.ApplicationViewEvent;
	import com.jxl.soundcloud.events.PlaybackControlsEvent;
	import com.jxl.soundcloud.events.SearchInputTextEvent;
	import com.jxl.soundcloud.events.SearchViewEvent;
	import com.jxl.soundcloud.events.SongEvent;
	import com.jxl.soundcloud.vo.SongVO;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	
	
	[Event(name="play", type="com.jxl.soundcloud.events.SongEvent")]
	[Event(name="stop", type="com.jxl.soundcloud.events.SongEvent")]
	[Event(name="seekClicked", type="com.jxl.soundcloud.events.SongEvent")]
	[Event(name="play", type="com.jxl.soundcloud.events.PlaybackControlsEvent")]
	[Event(name="pause", type="com.jxl.soundcloud.events.PlaybackControlsEvent")]
	[Event(name="nextSong", type="com.jxl.soundcloud.events.PlaybackControlsEvent")]
	[Event(name="previousSong", type="com.jxl.soundcloud.events.PlaybackControlsEvent")]
	[Event(name="volumeSliderChanged", type="com.jxl.soundcloud.events.PlaybackControlsEvent")]
	public class ApplicationView extends Component
	{
		
		private static const STATE_FAVORITES:String         = "favoritesState";
		private static const STATE_SEARCH:String            = "searchState";
		
		private var _favorites:Array;
		private var favoritesDirty:Boolean = false;
		private var _volume:Number = 100;
		private var volumeDirty:Boolean = false;
		private var _song:SongVO;
		private var songDirty:Boolean = false;
		
		private var favoritesTab:Tab;
		private var searchTab:Tab;
		private var searchInputText:SearchInputText;
		private var favoritesList:DraggableList;
		private var searchView:SearchView;
		private var playbackControls:PlaybackControls;
		private var animation:LoaderAnimation;
		private var noFavorites:TextField;
		
		private var shownScrollRect:Rectangle;
		
		
		public function get favorites():Array { return _favorites; }
		public function set favorites(value:Array):void
		{
			if(value !== favorites)
			{
				_favorites = value;
				favoritesDirty = true;
				invalidateProperties();
			}
		}
		
		public function get volume():Number { return _volume; }
		public function set volume(value:Number):void
		{
			if(value !== _volume)
			{
				
				_volume = value;
				volumeDirty = true;
				invalidateProperties();
			}
		}
		
		public function get song():SongVO { return _song; }
		public function set song(value:SongVO):void
		{
			if(value !== _song)
			{
				_song = value;
				songDirty = true;
				invalidateProperties();
			}
		}
		
		public function ApplicationView(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			
			
		}
		
		public function showLoading():void
		{
			if(currentState != STATE_FAVORITES) return;
			
			hideNoFavorites();
			
			if(animation == null)
			{
				animation = new LoaderAnimation();
			}
			
			if(contains(animation) == false)
				addChild(animation);
			
			favoritesList.visible = false;
			draw();
		}
		
		public function hideLoading():void
		{
			if(animation && contains(animation))
				removeChild(animation);
			
			favoritesList.visible = true;
		}
		
		private function showNoFavorites():void
		{
			hideLoading();
			if(noFavorites == null)
			{
				noFavorites = new TextField();
				addChild(noFavorites);
				noFavorites.defaultTextFormat = Styles.FORM_LABEL;
				noFavorites.embedFonts = true;
				noFavorites.multiline = true;
				noFavorites.wordWrap = true;
				noFavorites.selectable = false;
				noFavorites.mouseEnabled = false;
				noFavorites.tabEnabled = false;
				noFavorites.width = 300;
				noFavorites.text = "No favorites found.\n\nYou can either add favorites through SoundCloud.com, or you can click the Search Tab and find music you like.";
			}
			favoritesList.visible = false;
			draw();
		}
		
		private function hideNoFavorites():void
		{
			if(noFavorites)
			{
				removeChild(noFavorites);
				noFavorites = null;
			}
		}
		
		protected override function init():void
		{
			super.init();
			
			setSize(Constants.WIDTH, Constants.HEIGHT);
			currentState = STATE_FAVORITES;
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		private function onAdded(event:Event):void
		{
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
		}
		
		private function onRemoved(event:Event):void
		{
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			/*
			switch(event.keyCode)
			{
				case Keyboard.BACK:
			}
			*/
		}
		
		protected override function addChildren():void
		{
			super.addChildren();
			
			favoritesTab = new Tab();
			addChild(favoritesTab);
			favoritesTab.label = "Favorites";
			favoritesTab.toggle = true;
			favoritesTab.addEventListener(MouseEvent.CLICK, onShowFavorites);
			favoritesTab.selected = true;
			
			searchTab = new Tab();
			addChild(searchTab);
			searchTab.label = "Search";
			searchTab.toggle = true;
			searchTab.addEventListener(MouseEvent.CLICK, onShowSearch);
			
			favoritesList = new DraggableList();
			favoritesList.items = favorites;
			favoritesList.itemRenderer = SongItemRenderer;
			
			playbackControls = new PlaybackControls();
			addChild(playbackControls);
			playbackControls.volume = _volume;
			playbackControls.addEventListener(PlaybackControlsEvent.VOLUME_SLIDER_CHANGED, onVolumeSliderChanged);
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(favoritesDirty)
			{
				favoritesDirty = false;
				if(_favorites && _favorites.length > 0)
				{
					hideNoFavorites();
					favoritesList.items = _favorites;
				}
				else
				{
					showNoFavorites();
				}
			}
			
			if(volumeDirty)
			{
				volumeDirty = false;
				playbackControls.volume = _volume;
			}
			
			if(songDirty)
			{
				songDirty = false;
				// TODO: figure out how to auto-scroll
				/*
				if(favoritesList.containsItem(song))
				{
					favoritesList.scrollToPageShowingItem(_song);
				}
				else
				{
					if(searchView.containsItem(song))
						searchView.scrollToPageShowingItem(_song);
				}
				*/
			}
		}
		
		public override function draw():void
		{
				super.draw();
				
				const CONTROLS_MARGIN:Number = 16;
				const MARGIN:Number = 8;
				
				var g:Graphics = graphics;
				g.clear();
				
				playbackControls.setSize(width - 50, 72);
				playbackControls.move((width / 2) - (playbackControls.width / 2), CONTROLS_MARGIN);
				
				favoritesTab.move(8, playbackControls.y + playbackControls.height + CONTROLS_MARGIN);
				
				searchTab.move(favoritesTab.x + favoritesTab.width, favoritesTab.y);
				
				const TAB_BOTTOM:Number = favoritesTab.y + favoritesTab.height;
				
				g.lineStyle(0, 0xCCCCCC);
				g.moveTo(0, TAB_BOTTOM - 1);
				g.lineTo(width, TAB_BOTTOM - 1);
				g.endFill();
				
				favoritesList.move(12, favoritesTab.y + favoritesTab.height + 4);
				favoritesList.setSize(width - 24, height - favoritesList.y);
				
				if(searchView)
				{
					searchView.move(favoritesList.x,  favoritesList.y);
					searchView.setSize(favoritesList.width,  favoritesList.height);
				}
				
				if(animation)
				{
					animation.x = (width / 2) - (animation.width / 2);
					animation.y = favoritesList.y;
				}
				
				if(noFavorites)
				{
					noFavorites.x = (width / 2) - (noFavorites.width / 2);
					noFavorites.y = favoritesList.y + 20;
				}
		
				if(animation && contains(animation))
					setChildIndex(animation, numChildren - 1);
		}
		
		protected override function onEnterState(state:String):void
		{
			switch(state)
			{
				case "":
				case STATE_FAVORITES:
					favoritesTab.selected = true;
					searchTab.selected = false;
					
					if(contains(favoritesList) == false)
						addChild(favoritesList);

					if(noFavorites && contains(noFavorites) == false)
						addChild(noFavorites);
					
					break;
				
				case STATE_SEARCH:
					favoritesTab.selected = false;
					searchTab.selected = true;
					
					if(searchView == null)
					{
						searchView = new SearchView();
						searchView.addEventListener(SearchViewEvent.SEARCH, onSearch);
					}
					
					if(contains(searchView) == false)
						addChild(searchView);
					
					if(noFavorites && contains(noFavorites))
						removeChild(noFavorites);
					
					break;
			}
			
			draw();
		}
		
		protected override function onExitState(oldState:String):void
		{
			switch(oldState)
			{
				case STATE_FAVORITES:
					if(contains(favoritesList))
						removeChild(favoritesList);
					break;
				
				case STATE_SEARCH:
					if(searchView && contains(searchView))
						removeChild(searchView);
					break;
			}
		}
		
		private function onSearch(event:SearchViewEvent):void
		{
			dispatchEvent(event);
			stage.focus = this;
		}
		
		private function onShowFavorites(event:MouseEvent):void
		{
			currentState = STATE_FAVORITES;
		}
		
		private function onShowSearch(event:MouseEvent):void
		{
			currentState = STATE_SEARCH;
		}
		
		private function onVolumeSliderChanged(event:PlaybackControlsEvent):void
		{
			_volume = event.volume;
		}
	}
}
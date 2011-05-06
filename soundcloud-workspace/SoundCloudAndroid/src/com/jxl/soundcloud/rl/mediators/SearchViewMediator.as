package com.jxl.soundcloud.rl.mediators
{
	import com.jxl.soundcloud.events.AuthorizeEvent;
	import com.jxl.soundcloud.events.MenuEvent;
	import com.jxl.soundcloud.events.SearchEvent;
	import com.jxl.soundcloud.events.SearchServiceEvent;
	import com.jxl.soundcloud.events.SearchViewEvent;
	import com.jxl.soundcloud.events.SongEvent;
	import com.jxl.soundcloud.rl.models.SearchModel;
	import com.jxl.soundcloud.views.mainviews.SearchView;
	import com.jxl.soundcloud.vo.SongVO;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class SearchViewMediator extends Mediator
	{
		[Inject]
		public var searchView:SearchView;
		
		[Inject]
		public var searchModel:SearchModel;
		
		private var lastSearchQuery:String;
		
		public function SearchViewMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener(searchView, SearchViewEvent.SEARCH, onSearch, SearchViewEvent);
			eventMap.mapListener(searchView, SearchViewEvent.BACK, onBack, SearchViewEvent);
			
			eventMap.mapListener(eventDispatcher, SearchEvent.SEARCH_RESULTS_CHANGED, onSearchResultsChanged, SearchEvent);
			eventMap.mapListener(eventDispatcher, SearchServiceEvent.SEARCH_ERROR, onSearchError, SearchServiceEvent);
			eventMap.mapListener(eventDispatcher, MenuEvent.REFRESH, onRefresh, MenuEvent);
			
			searchView.searchResults = searchModel.searchResults;
		}
		
		private function onRefresh(event:MenuEvent):void
		{
			if(lastSearchQuery != null || lastSearchQuery != "")
			{
				searchView.currentState = SearchView.STATE_LOADING;
				searchModel.search(lastSearchQuery);
			}
		}
		
		private function onSearch(event:SearchViewEvent):void
		{
			lastSearchQuery = event.searchString;
			searchView.currentState = SearchView.STATE_LOADING;
			searchModel.search(event.searchString);
		}
		
		private function onSearchResultsChanged(event:SearchEvent):void
		{
			searchView.currentState = SearchView.STATE_SEARCH_RESULTS;
			searchView.searchResults = event.searchResults;
		}
		
		private function onSearchError(event:SearchServiceEvent):void
		{
			searchView.currentState = SearchView.STATE_SEARCH;
		}
		
		private function onBack(event:SearchViewEvent):void
		{
			searchModel.cancelLast();
			// In case we're playing a song on search results, we need to stop it if you navigate back
			if(searchModel.searchResults && searchModel.searchResults.length > 0)
			{
				var len:int = searchModel.searchResults.length;
				for(var index:uint = 0; index < len; index++)
				{
					var song:SongVO = searchModel.searchResults[index] as SongVO;
					if(song.playing)
					{
						var evt:SongEvent = new SongEvent(SongEvent.STOP);
						evt.song = song;
						dispatch(evt);
						return;
					}
				}
			}
		}
	}
}
package com.jxl.soundcloud.events
{
	import flash.events.Event;
	
	public class SearchEvent extends Event
	{
		
		public static const SEARCH_RESULTS_CHANGED:String = "searchResultsChanged";
		
		public var searchResults:Array;
		
		public function SearchEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			var event:SearchEvent = new SearchEvent(type, bubbles, cancelable);
			event.searchResults = searchResults;
			return event;
		}
		
	}
}
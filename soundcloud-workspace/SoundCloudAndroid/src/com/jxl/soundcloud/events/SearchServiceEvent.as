package com.jxl.soundcloud.events
{
	import flash.events.Event;
	
	public class SearchServiceEvent extends Event
	{
		public static const SEARCH_SUCCESS:String = "searchSuccess";
		public static const SEARCH_ERROR:String = "searchError";
		
		public var searchResults:Array;
		
		public function SearchServiceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			var event:SearchServiceEvent = new SearchServiceEvent(type, bubbles, cancelable);
			event.searchResults = searchResults;
			return event;
		}
	}
}
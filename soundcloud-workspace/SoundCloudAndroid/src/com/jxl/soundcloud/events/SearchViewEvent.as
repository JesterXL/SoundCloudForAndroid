package com.jxl.soundcloud.events
{
	import flash.events.Event;
	
	public class SearchViewEvent extends Event
	{
		public static const SEARCH:String = "search";
		public static const BACK:String = "back";
		
		public var searchString:String;
		
		public function SearchViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			var evt:SearchViewEvent = new SearchViewEvent(type, bubbles, cancelable);
			evt.searchString = searchString;
			return evt;
		}
	}
}
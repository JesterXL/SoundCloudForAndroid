package com.jxl.soundcloud.events
{
	import flash.events.Event;
	
	public class SearchInputTextEvent extends Event
	{
		public static const SEARCH:String = "search";
		
		public function SearchInputTextEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
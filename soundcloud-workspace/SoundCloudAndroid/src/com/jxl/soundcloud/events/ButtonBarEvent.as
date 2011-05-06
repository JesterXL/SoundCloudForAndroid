package com.jxl.soundcloud.events
{
	import flash.events.Event;
	
	public class ButtonBarEvent extends Event
	{
		public static const CURRENT_PAGE_CHANGED:String = "currentPageChanged";
		
		public var currentPage:uint;
		
		public function ButtonBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			var evt:ButtonBarEvent = new ButtonBarEvent(type, bubbles, cancelable);
			evt.currentPage = currentPage;
			return evt;
		}
	}
}
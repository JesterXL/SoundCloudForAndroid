package com.jxl.soundcloud.events
{
	import flash.events.Event;
	
	public class ListEvent extends Event
	{
		
		public static const ITEM_CLICKED:String = "itemClicked";
		
		public var data:*;
		public var index:int;
		
		public function ListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
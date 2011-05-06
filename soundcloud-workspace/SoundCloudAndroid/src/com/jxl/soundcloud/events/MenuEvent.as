package com.jxl.soundcloud.events
{
	import flash.events.Event;
	
	public class MenuEvent extends Event
	{
		public static const REFRESH:String 			= "refresh";
		public static const QUIT:String 			= "quit";
		public static const DISCONNECT:String 		= "disconnect";
		public static const CHANGE_LOG:String 		= "changeLog";
		public static const SHOW_ERRORS:String		= "showErrors";
		
		
		
		public function MenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new MenuEvent(type, bubbles, cancelable);
		}
	}
}
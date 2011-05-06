package com.jxl.soundcloud.events
{
	import flash.events.Event;
	
	public class AuthorizeViewEvent extends Event
	{
		public static const CODE_SUBMITTED:String 	= "codeSubmitted";
		public static const ABORT_AUTHORIZE:String 	= "abortAuthorized";
		public static const RELOAD_AUTHORIZE:String = "reloadAuthorize";
		
		public var code:String;
		
		public function AuthorizeViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
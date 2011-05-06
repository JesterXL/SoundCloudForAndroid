package com.jxl.soundcloud.events
{
	import flash.events.Event;
	
	public class InputTextEvent extends Event
	{
		public static const ENTER_PRESSED:String = "enterPressed";
		
		public function InputTextEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
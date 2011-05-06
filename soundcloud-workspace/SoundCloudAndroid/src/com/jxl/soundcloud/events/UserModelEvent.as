package com.jxl.soundcloud.events
{
	import com.jxl.soundcloud.vo.UserVO;
	
	import flash.events.Event;
	
	public class UserModelEvent extends Event
	{
		public static const USER_CHANGED:String = "userChanged";
		
		public var user:UserVO;
		
		public function UserModelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
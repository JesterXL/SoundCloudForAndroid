package com.jxl.soundcloud.events
{
	import com.jxl.soundcloud.vo.UserVO;
	
	import flash.events.Event;
	
	public class LoginEvent extends Event
	{
		public static const LOGIN:String				= "login";
		public static const LOGIN_SUCCESS:String		= "loginSuccess";
		public static const LOGIN_ERROR:String			= "loginError";
        public static const LOGOUT:String               = "logout";
		
		public var username:String;
		public var password:String;
		public var user:UserVO;
		
		public function LoginEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			var evt:LoginEvent 		= new LoginEvent(type, bubbles, cancelable);
			evt.username			= username;
			evt.password			= password;
			evt.user				= user;
			return evt;
		}
	}
}
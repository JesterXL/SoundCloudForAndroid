package com.jxl.soundcloud.events
{
	import flash.events.Event;
	
	import org.iotashan.oauth.OAuthToken;
	
	public class AuthorizeEvent extends Event
	{
		
		public static const SOUND_CLOUD_AUTHORIZED:String 		= "soundCloudAuthorized";
		public static const ACCESS_TOKEN_ERROR:String 			= "accessTokenError";
		public static const REQUEST_TOKEN_ERROR:String 			= "requestTokenError";
		public static const UNAUTHORIZED:String 				= "unauthorized";
		
		public var token:OAuthToken;
		
		public function AuthorizeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new AuthorizeEvent(type, bubbles, cancelable);
		}
		
	}
}
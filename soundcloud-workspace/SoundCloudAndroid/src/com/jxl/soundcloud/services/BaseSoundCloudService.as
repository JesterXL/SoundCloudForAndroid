package com.jxl.soundcloud.services
{
	import com.jxl.soundcloud.events.AuthorizeEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	[Event(name="unauthorized", type="com.jxl.soundcloud.events.AuthorizeEvent")]
	public class BaseSoundCloudService extends EventDispatcher
	{
		public function BaseSoundCloudService()
		{
			super();
		}
		
		protected function isAuthorized(response:*):Boolean
		{
			if(response == null) return true;
			
			if(response.error && response.error.toLowerCase() == "401 - unauthorized")
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		protected function handleUnauthorized():void
		{
			return;
			dispatchEvent(new AuthorizeEvent(AuthorizeEvent.UNAUTHORIZED));
		}
	}
}
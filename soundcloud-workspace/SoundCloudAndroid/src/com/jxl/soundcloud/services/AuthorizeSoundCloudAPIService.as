package com.jxl.soundcloud.services
{
	import com.dasflash.soundcloud.as3api.SoundcloudClient;
	import com.dasflash.soundcloud.as3api.SoundcloudDelegate;
	import com.dasflash.soundcloud.as3api.events.SoundcloudAuthEvent;
	import com.dasflash.soundcloud.as3api.events.SoundcloudFaultEvent;
	import com.jxl.soundcloud.events.AuthorizeEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.StageWebView;
	import flash.net.SharedObject;
	
	import org.iotashan.oauth.OAuthToken;
	
	[Event(name="soundCloudAuthorized", type="com.jxl.soundcloud.events.AuthorizeEvent")]
	[Event(name="accessTokenError", type="com.jxl.soundcloud.events.AuthorizeEvent")]
	[Event(name="requestTokenError", type="com.jxl.soundcloud.events.AuthorizeEvent")]
	public class AuthorizeSoundCloudAPIService extends EventDispatcher
	{
		
		
		private var soundCloudClient:SoundcloudClient;
        private var webView:StageWebView;
		
		
		public function AuthorizeSoundCloudAPIService()
		{
			super();
		}
		
		// First, get a request token...
		public function authorize(webView:StageWebView, token:OAuthToken):void
		{
            this.webView = webView;

			if(soundCloudClient == null)
			{
				if(token == null)
				{
					//Debug.log("AuthorizeSoundCloudAPIService::authorize, no token found, requesting...");
					ServiceLocator.initialize();
					if(soundCloudClient == null)
					{
						soundCloudClient = ServiceLocator.instance.soundCloudClient;
						
						soundCloudClient.addEventListener(SoundcloudAuthEvent.REQUEST_TOKEN, onRequestTokenSuccess); 
						soundCloudClient.addEventListener(SoundcloudFaultEvent.REQUEST_TOKEN_FAULT, onRequestTokenError);
	
	                    soundCloudClient.addEventListener(SoundcloudAuthEvent.ACCESS_TOKEN, onAccessTokenSuccess);
						soundCloudClient.addEventListener(SoundcloudFaultEvent.ACCESS_TOKEN_FAULT, onAccessTokenError);
					}
				}
				else
				{
					//Debug.log("AuthorizeSoundCloudAPIService::authorize, saved token read, and initialized.");
					ServiceLocator.initialize(token);
					var evt:AuthorizeEvent = new AuthorizeEvent(AuthorizeEvent.SOUND_CLOUD_AUTHORIZED);
					evt.token = token;
					dispatchEvent(evt);
					return;
				}
			}				
			var soundCloudDelegate:SoundcloudDelegate = soundCloudClient.getRequestToken("http://soundcloudandroid.jessewarden.com/");
		}
		
		public function abort():void
		{
			// TODO: calls may be going on, so we should probably check to see if soundCloudClient is null
			// in event handlers.
			if(soundCloudClient)
			{
				soundCloudClient.removeEventListener(SoundcloudAuthEvent.REQUEST_TOKEN, onRequestTokenSuccess); 
				soundCloudClient.removeEventListener(SoundcloudFaultEvent.REQUEST_TOKEN_FAULT, onRequestTokenError);
				
				soundCloudClient.removeEventListener(SoundcloudAuthEvent.ACCESS_TOKEN, onAccessTokenSuccess);
				soundCloudClient.removeEventListener(SoundcloudFaultEvent.ACCESS_TOKEN_FAULT, onAccessTokenError);
				
				soundCloudClient = null;
			}
		}
		
		// Second, once SoundCloud holla's back, we then redirect the user to an HTML page to get us a code
		private function onRequestTokenSuccess(event:SoundcloudAuthEvent):void
		{
			//Debug.log("AuthorizeSoundCloudAPIService::onRequestTokenSuccess, authorizing user...");
			soundCloudClient.authorizeUserMobile(webView);
		}
		
		private function onRequestTokenError(event:SoundcloudFaultEvent):void
		{
			Debug.log("AuthorizeSoundCloudAPIService::onRequestTokenError, " + event.errorCode + ":" + event.message);
			dispatchEvent(new AuthorizeEvent(AuthorizeEvent.REQUEST_TOKEN_ERROR));
		}
		
		// Third, we submit our received code the user manually inputted,
		// and get our access token.
		public function getAccessToken(code:String):void
		{
			var delegate:SoundcloudDelegate = soundCloudClient.getAccessToken(code); 
			//delegate.addEventListener(SoundcloudFaultEvent.FAULT, faultHandler);
		//	Debug.log("getAccessTokenButtonClickHandler::requesting access token"); 
		}
		
		// Fourth, cool, we got our access token.  Save it, and start using the app.
		private function onAccessTokenSuccess(event:SoundcloudAuthEvent):void
		{
			//Debug.log("AuthorizeSoundCloudAPIService::onAccessTokenSuccess");
			var evt:AuthorizeEvent = new AuthorizeEvent(AuthorizeEvent.SOUND_CLOUD_AUTHORIZED);
			evt.token = event.token;
			dispatchEvent(evt);
		}
		
		private function onAccessTokenError(event:SoundcloudFaultEvent):void
		{
			Debug.log("AuthorizeSoundCloudAPIService::onAccessTokenError, " + event);
			dispatchEvent(new AuthorizeEvent(AuthorizeEvent.ACCESS_TOKEN_ERROR));
		}
		
		
		
		
	}
}
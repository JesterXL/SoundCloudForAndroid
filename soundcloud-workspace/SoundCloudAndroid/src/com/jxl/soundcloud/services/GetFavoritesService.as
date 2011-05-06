package com.jxl.soundcloud.services
{
	import com.dasflash.soundcloud.as3api.SoundcloudClient;
	import com.dasflash.soundcloud.as3api.SoundcloudDelegate;
	import com.dasflash.soundcloud.as3api.events.SoundcloudEvent;
	import com.dasflash.soundcloud.as3api.events.SoundcloudFaultEvent;
	import com.jxl.soundcloud.Constants;
	import com.jxl.soundcloud.events.AuthorizeEvent;
	import com.jxl.soundcloud.events.GetFavoritesServiceEvent;
	import com.jxl.soundcloud.factories.SongFactory;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.URLRequestMethod;
	import flash.utils.Timer;
	
	[Event(name="getFavoritesSuccess", type="com.jxl.soundcloud.events.GetFavoritesServiceEvent")]
	[Event(name="getFavoritesError", type="com.jxl.soundcloud.events.GetFavoritesServiceEvent")]
	public class GetFavoritesService extends BaseSoundCloudService
	{
		private var soundCloudClient:SoundcloudClient;
		
		private var errorCount:uint = 0;
		private var currentTry:uint = 0;
		private var timer:Timer;
		
		public function GetFavoritesService()
		{
			super();
		}
		
		public function getFavorites():void
		{
            //Debug.log("GetFavoritesService::getFavorites");

			errorCount = 0;
			currentTry = 0;
			destroyTimer();
			
			if(soundCloudClient == null)
			{
				soundCloudClient = ServiceLocator.instance.soundCloudClient;
			}
			
			makeCall();
		}
		
		private function makeCall():void
		{
			var delegate:SoundcloudDelegate = soundCloudClient.sendRequest("me/favorites", URLRequestMethod.GET);
			delegate.addEventListener(SoundcloudEvent.REQUEST_COMPLETE, onGetFavoritesResult);
			delegate.addEventListener(SoundcloudFaultEvent.FAULT, onGetFavoritesFault);
		}
		
		private function onGetFavoritesResult(event:SoundcloudEvent):void
		{
			//Debug.log("GetFavoritesService::onGetFavorites: " + event.data);
			destroyTimer();
			if(isAuthorized(event.data) == false)
			{
				//Debug.log("detected unauthorized call, asking for authentication again.");
				handleUnauthorized();
				return;
			}
			
			if(event.data)
			{
				
				var evt:GetFavoritesServiceEvent = new GetFavoritesServiceEvent(GetFavoritesServiceEvent.GET_FAVORITES_SUCCESS);
				
				evt.favorites = SongFactory.getSongs(event.data as Array);
				dispatchEvent(evt);
			}
			else
			{
				Debug.log("GetFavoritesService::onGetFavoritesResult, couldn't parse result.");
				dispatchEvent(new GetFavoritesServiceEvent(GetFavoritesServiceEvent.GET_FAVORITES_ERROR));
			}
				
				/*
			var list:Array = event.data as Array;
			if(list)
			{
				var len:int = list.length;
				for(var index:uint = 0; index < len; index++)
				{
					var o:* = list[index];
					if(o)
					{
						log("------");
						for(var prop:String in o)
						{
							log(prop + ": " + o[prop]);
						}
					}
				}
			}
			*/
		}
		
		private function onGetFavoritesFault(event:SoundcloudFaultEvent):void
		{
			Debug.log("GetFavoritesService::onGetFavoritesFault: " + event);
			dispatchEvent(new GetFavoritesServiceEvent(GetFavoritesServiceEvent.GET_FAVORITES_ERROR));
			errorCount++;
			if(errorCount >= 2)
			{
				// try again
				if(currentTry < 2)
				{
					Debug.log("\tTrying again...");
					currentTry++;
					if(timer == null)
					{
						timer = new Timer(3 * 1000);
						timer.addEventListener(TimerEvent.TIMER, onTryAgain, false, 0, true);
					}
					timer.reset();
					timer.start();
				}
				else
				{
					Debug.log("\tTrying twice, giving up.");
					destroyTimer();
				}
			}
		}
		
		private function onTryAgain(event:TimerEvent):void
		{
			timer.stop();
			makeCall();
		}
		
		private function destroyTimer():void
		{
			if(timer)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onTryAgain);
				timer = null;
			}
		}
	}
}
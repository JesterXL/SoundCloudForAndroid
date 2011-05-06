package com.jxl.soundcloud.services
{
	import com.dasflash.soundcloud.as3api.SoundcloudClient;
	import com.dasflash.soundcloud.as3api.SoundcloudDelegate;
	import com.dasflash.soundcloud.as3api.events.SoundcloudEvent;
	import com.dasflash.soundcloud.as3api.events.SoundcloudFaultEvent;
	import com.jxl.soundcloud.events.SearchServiceEvent;
	import com.jxl.soundcloud.factories.SongFactory;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	[Event(name="searchSuccess", type="com.jxl.soundcloud.events.SearchServiceEvent")]
	[Event(name="searchError", type="com.jxl.soundcloud.events.SearchServiceEvent")]
	public class SearchService extends BaseSoundCloudService
	{
		private var soundCloudClient:SoundcloudClient;
		private var timer:Timer;
		private var lastDelegate:SoundcloudDelegate;
		
		public function SearchService()
		{
			super();
		}
		
		public function search(searchString:String):void
		{
			//Debug.log("SearchService::search: " + searchString);
			if(soundCloudClient == null)
			{
				soundCloudClient = ServiceLocator.instance.soundCloudClient;
			}
			
			if(timer == null)
			{
				timer = new Timer(30 * 1000);
				timer.addEventListener(TimerEvent.TIMER, onTimeout, false, 0, true);
			}
			timer.reset();
			timer.start();
			
			var params:Object = {q: searchString};
			
			if(lastDelegate)
			{
				lastDelegate.removeEventListener(SoundcloudEvent.REQUEST_COMPLETE, onSearchResult);
				lastDelegate.removeEventListener(SoundcloudFaultEvent.FAULT, onSearchFault);
				lastDelegate = null;
			}
			
			lastDelegate = soundCloudClient.sendRequest("tracks", URLRequestMethod.GET, params);
			lastDelegate.addEventListener(SoundcloudEvent.REQUEST_COMPLETE, onSearchResult);
			lastDelegate.addEventListener(SoundcloudFaultEvent.FAULT, onSearchFault);
		}
		
		public function cancel():void
		{
			destroyTimer();
			if(lastDelegate)
			{
				lastDelegate.removeEventListener(SoundcloudEvent.REQUEST_COMPLETE, onSearchResult);
				lastDelegate.removeEventListener(SoundcloudFaultEvent.FAULT, onSearchFault);
				lastDelegate = null;
			}
		}
		
		private function onSearchResult(event:SoundcloudEvent):void
		{
			destroyTimer();
			//Debug.log("SearchService::onSearchResult: " + event.data);
			
			if(isAuthorized(event.data) == false)
			{
				//Debug.log("detected unauthorized call, asking for authentication again.");
				handleUnauthorized();
				return;
			}
			
				
			if(event.data)
			{
				var evt:SearchServiceEvent = new SearchServiceEvent(SearchServiceEvent.SEARCH_SUCCESS);
				var list:Array = event.data as Array;
				if(list.length > 9)
				{
					list = list.slice(0, 9);
				}
				evt.searchResults = SongFactory.getSongs(list);
				dispatchEvent(evt);
			}
			else
			{
				dispatchEvent(new SearchServiceEvent(SearchServiceEvent.SEARCH_ERROR));
			}
		}
		
		private function onSearchFault(event:SoundcloudFaultEvent):void
		{
			destroyTimer();
			Debug.log("SearchService::onSearchFault: " + event);
			dispatchEvent(new SearchServiceEvent(SearchServiceEvent.SEARCH_ERROR));
		}
		
		private function destroyTimer():void
		{
			if(timer)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onTimeout);
				timer = null;
			}
		}
		
		private function onTimeout(event:TimerEvent):void
		{
			destroyTimer();
			dispatchEvent(new SearchServiceEvent(SearchServiceEvent.SEARCH_ERROR));
		}
		
	}
}
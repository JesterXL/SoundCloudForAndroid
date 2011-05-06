package com.jxl.soundcloud.rl.models
{
	import com.jxl.soundcloud.events.AuthorizeEvent;
	import com.jxl.soundcloud.events.GetFavoritesServiceEvent;
	import com.jxl.soundcloud.services.GetFavoritesService;
	
	import org.robotlegs.mvcs.Actor;
	
	public class FavoritesModel extends Actor
	{
		private var getFavoritesService:GetFavoritesService;
		
		public var favorites:Array;
		
		public function FavoritesModel()
		{
			super();
		}
		
		public function getFavorites():void
		{
			if(getFavoritesService == null)
			{
				getFavoritesService = new GetFavoritesService();
				getFavoritesService.addEventListener(GetFavoritesServiceEvent.GET_FAVORITES_ERROR, onGetFavoritesError);
				getFavoritesService.addEventListener(GetFavoritesServiceEvent.GET_FAVORITES_SUCCESS, onGetFavoritesSuccess);
				getFavoritesService.addEventListener(AuthorizeEvent.UNAUTHORIZED, onUnauthorized);
			}
			getFavoritesService.getFavorites();
		}
		
		private function onUnauthorized(event:AuthorizeEvent):void
		{
			dispatch(event);
		}
		
		private function onGetFavoritesError(event:GetFavoritesServiceEvent):void
		{
			// TODO: implement
			dispatch(event);
		}
		
		private function onGetFavoritesSuccess(event:GetFavoritesServiceEvent):void
		{
			favorites = event.favorites;
			dispatch(event);
		}
	}
}
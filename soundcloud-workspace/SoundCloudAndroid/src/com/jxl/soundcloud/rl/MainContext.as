package com.jxl.soundcloud.rl
{
	import com.jxl.soundcloud.rl.mediators.ApplicationViewMediator;
	import com.jxl.soundcloud.rl.mediators.AuthorizeViewMediator;
	import com.jxl.soundcloud.rl.mediators.MainViewMediator;
	import com.jxl.soundcloud.rl.mediators.SearchViewMediator;
	import com.jxl.soundcloud.rl.models.AuthorizationModel;
	import com.jxl.soundcloud.rl.models.FavoritesModel;
	import com.jxl.soundcloud.rl.models.SearchModel;
	import com.jxl.soundcloud.rl.models.SongModel;
	import com.jxl.soundcloud.services.AuthorizeSoundCloudAPIService;
	import com.jxl.soundcloud.services.CacheSongService;
	import com.jxl.soundcloud.services.GetFavoritesService;
	import com.jxl.soundcloud.services.SearchService;
	import com.jxl.soundcloud.services.SendErrorEmailService;
	import com.jxl.soundcloud.views.MainView;
	import com.jxl.soundcloud.views.mainviews.ApplicationView;
	import com.jxl.soundcloud.views.mainviews.AuthorizeView;
	import com.jxl.soundcloud.views.mainviews.ILoginView;
	import com.jxl.soundcloud.views.mainviews.LoginView;
	import com.jxl.soundcloud.views.mainviews.SearchView;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.Context;
	
	public class


    MainContext extends Context
	{
		public function MainContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		
		public override function startup():void
		{

			injector.mapSingleton(AuthorizeSoundCloudAPIService);
			injector.mapSingleton(GetFavoritesService);
			injector.mapSingleton(SongModel);
			injector.mapSingleton(SearchModel);
			injector.mapSingleton(AuthorizationModel);
			injector.mapSingleton(FavoritesModel);
			
            injector.mapClass(CacheSongService, CacheSongService);
			injector.mapClass(SearchService, SearchService);
			injector.mapClass(SendErrorEmailService, SendErrorEmailService);
			
			
			mediatorMap.mapView(ApplicationView, ApplicationViewMediator);
			mediatorMap.mapView(MainView, MainViewMediator);
			mediatorMap.mapView(AuthorizeView, AuthorizeViewMediator);
			mediatorMap.mapView(SearchView, SearchViewMediator);
			
			super.startup();
		}
	}
}
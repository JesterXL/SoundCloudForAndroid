
package com.jxl.soundcloud.rl.mediators
{
	import com.jxl.soundcloud.events.AuthorizeEvent;
	import com.jxl.soundcloud.events.LoginEvent;
	import com.jxl.soundcloud.events.MainViewEvent;
	import com.jxl.soundcloud.events.MenuEvent;
	import com.jxl.soundcloud.rl.models.AuthorizationModel;
	import com.jxl.soundcloud.services.SendErrorEmailService;
	import com.jxl.soundcloud.views.MainView;
	
	import flash.desktop.NativeApplication;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class MainViewMediator extends Mediator
	{
		[Inject]
		public var mainView:MainView;
		
		[Inject]
		public var authModel:AuthorizationModel;
		
		[Inject]
		public var emailService:SendErrorEmailService;
		
		public function MainViewMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			super.onRegister();

			eventMap.mapListener(eventDispatcher, AuthorizeEvent.SOUND_CLOUD_AUTHORIZED, onSoundCloudAuthorized, AuthorizeEvent);
			eventMap.mapListener(eventDispatcher, AuthorizeEvent.UNAUTHORIZED, onUnauthorized, AuthorizeEvent);
			
            eventMap.mapListener(mainView, MainViewEvent.QUIT, onQuit, MainViewEvent);
            eventMap.mapListener(mainView, LoginEvent.LOGOUT, onLogout, LoginEvent);
			eventMap.mapListener(mainView, MenuEvent.REFRESH, onRefresh, MenuEvent);
			eventMap.mapListener(mainView, MenuEvent.SHOW_ERRORS, onShowErrors, MenuEvent);
		}

		private function onSoundCloudAuthorized(event:AuthorizeEvent):void
		{
			mainView.currentState = MainView.STATE_MAIN;
		}
		
		private function onUnauthorized(event:AuthorizeEvent):void
		{
			authModel.clearToken();
			mainView.currentState = MainView.STATE_AUTHORIZE;
		}

        private function onLogout(event:LoginEvent):void
        {
			dispatch(event);
			authModel.clearToken();
            mainView.currentState = MainView.STATE_LOGIN;
        }

        private function onQuit(event:MainViewEvent):void
        {
            NativeApplication.nativeApplication.exit();
        }
		
		private function onRefresh(event:MenuEvent):void
		{
			dispatch(event);
		}
		
		private function onShowErrors(event:MenuEvent):void
		{
			Debug.log("MainViewMediator::onShowErrors");
			emailService.sendErrorEmail();
		}
	}
}
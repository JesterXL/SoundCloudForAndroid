package com.jxl.soundcloud.rl.mediators
{
	import com.jxl.soundcloud.events.AuthorizeEvent;
	import com.jxl.soundcloud.events.AuthorizeViewEvent;
	import com.jxl.soundcloud.rl.models.AuthorizationModel;
	import com.jxl.soundcloud.services.AuthorizeSoundCloudAPIService;
	import com.jxl.soundcloud.views.mainviews.AuthorizeView;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class AuthorizeViewMediator extends Mediator
	{
		[Inject]
		public var authorizeView:AuthorizeView;
		
		[Inject]
		public var authModel:AuthorizationModel;
		
		// HACK/KLUDGE
		private var waitAFrame:Sprite;
		
		public function AuthorizeViewMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			super.onRegister();
			
			if(waitAFrame == null)
			{
				waitAFrame = new Sprite();
				waitAFrame.addEventListener(Event.ENTER_FRAME, onGO);
			}
			eventMap.mapListener(authorizeView, AuthorizeViewEvent.CODE_SUBMITTED, onSubmitCode, AuthorizeViewEvent);
			eventMap.mapListener(authorizeView, AuthorizeViewEvent.ABORT_AUTHORIZE, onAbortAuthorization, AuthorizeViewEvent);
		}
		
		private function onGO(event:Event):void
		{
			waitAFrame.removeEventListener(Event.ENTER_FRAME, onGO);
			waitAFrame = null;
			authorizeView.currentState = AuthorizeView.STATE_MAIN;
			authModel.authorize(authorizeView.webView);
		}
		
		private function onAuthorized(event:AuthorizeEvent):void
		{
			dispatch(event);
		}
		
		private function onSubmitCode(event:AuthorizeViewEvent):void
		{
			authorizeView.currentState = AuthorizeView.STATE_LOADING;
			authModel.getAccessToken(event.code);
		}
		
		private function onAbortAuthorization(event:AuthorizeViewEvent):void
		{
			authorizeView.currentState = AuthorizeView.STATE_MAIN;
			authModel.abort();
			authModel.authorize(authorizeView.webView);
		}
	}
}
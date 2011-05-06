package suites.mediatortests
{
	import com.jxl.soundcloud.events.LoginEvent;
	import com.jxl.soundcloud.rl.mediators.LoginViewMediator;
	import com.jxl.soundcloud.views.mainviews.ILoginView;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flexunit.framework.Assert;
	
	import mx.events.FlexEvent;
	
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.hamcrest.object.nullValue;

	public class LoginViewMediatorTests
	{
		
		private var loginView:ILoginView;
		private var loginViewMediator:LoginViewMediator;
		
		public function LoginViewMediatorTests()
		{
		}
		
		[Before(async)]
		public function setup():void
		{
			loginView 								= new LoginViewMock();
			loginViewMediator 						= new LoginViewMediator();
			loginViewMediator.loginView				= loginView;
			loginViewMediator.setViewComponent(loginView);
			loginViewMediator.eventDispatcher 		= new EventDispatcher();
			loginViewMediator.onRegister();
			Async.proceedOnEvent(this, loginView, FlexEvent.CREATION_COMPLETE);
			UIImpersonator.addChild(loginView as DisplayObject);
		}
		
		[After]
		public function tearDown():void
		{
			loginView = null;
			loginViewMediator.onRemove();
			loginViewMediator.setViewComponent(null);
			loginViewMediator.loginView = null;
			loginViewMediator.eventDispatcher = null;
			loginViewMediator = null;
		}
		
		[Test]
		public function testInitialState():void
		{
			Assert.assertEquals(loginView.currentState, "main_state");
		}
		
	}
}
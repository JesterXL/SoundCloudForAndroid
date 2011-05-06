package suites.servicetests
{
	import com.jxl.soundcloud.events.LoginEvent;
	import com.jxl.soundcloud.rl.models.UserModel;
	import com.jxl.soundcloud.services.LoginService;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.async.Async;
	import org.swiftsuspenders.Injector;

	public class UserModelTests
	{
		
		private var userModel:UserModel;
		private var injector:Injector;
		private var eventDispatcher:EventDispatcher;
		
		public function UserModelTests()
		{
		}
		
		[Before]
		public function setup():void
		{
			eventDispatcher 			= new EventDispatcher();
			
			injector 					= new Injector();
			injector.mapValue(LoginService, new LoginService());
			injector.mapValue(IEventDispatcher, eventDispatcher);
			
			userModel					= new UserModel();
			injector.injectInto(userModel);
			
		}
		
		[After]
		public function tearDown():void
		{
			injector 	= null;
			userModel 	= null;
		}
		
		[Test(async)]
		public function testUserModelLoginSuccess():void
		{
			var func:Function = Async.asyncHandler(this, onLoginSuccess, 5 * 1000, null, onLoginSuccessTimeout);
			eventDispatcher.addEventListener(LoginEvent.LOGIN_SUCCESS, func);
			userModel.login("fake", "fake");
		}
		
		private function onLoginSuccess(event:LoginEvent, passThroughData:Object):void
		{
			Assert.assertNotNull(userModel.user);
		}
		
		private function onLoginSuccessTimeout(passThroughData:Object):void
		{
			Assert.fail("UserModel login success timed out.");
		}
		
		[Test(async)]
		public function testUserModelLoginError():void
		{
			var func:Function = Async.asyncHandler(this, onLoginError, 5 * 1000, null, onLoginErrorTimeout);
			eventDispatcher.addEventListener(LoginEvent.LOGIN_ERROR, func);
			userModel.login(null, null);
		}
		
		private function onLoginError(event:LoginEvent, passThroughData:Object):void
		{
			Assert.assertNull(userModel.user);
		}
		
		private function onLoginErrorTimeout(passThroughData:Object):void
		{
			Assert.fail("UserModel login error timed out.");
		} 
	}
}
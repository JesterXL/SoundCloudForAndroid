package suites.servicetests
{
	import com.jxl.soundcloud.events.LoginEvent;
	import com.jxl.soundcloud.services.LoginService;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.async.Async;

	public class LoginServiceTests
	{
		private var loginService:LoginService;
		
		public function LoginServiceTests()
		{
		}
		
		[Before]
		public function setup():void
		{
			loginService = new LoginService();
			
		}
		
		[After]
		public function tearDown():void
		{
			loginService = null;
		}
		
		[Test(async)]
		public function testLoginSuccess():void
		{
			var func:Function = Async.asyncHandler(this, onLoginSuccess, 5 * 1000, null, onLoginSuccessTimeout);
			loginService.addEventListener(LoginEvent.LOGIN_SUCCESS, func);
			loginService.login("fake", "fake");
		}
		
		private function onLoginSuccess(event:LoginEvent, passThroughData:Object):void
		{
			Assert.assertTrue(true, true);
		}
		
		private function onLoginSuccessTimeout(passThroughData:Object):void
		{
			
			Assert.fail("LoginService success timed out.");
		}
		
		[Test(async)]
		public function testLoginError():void
		{
			var func:Function = Async.asyncHandler(this, onLoginError, 5 * 1000, null, onLoginErrorTimeout);
			loginService.addEventListener(LoginEvent.LOGIN_ERROR, func);
			loginService.login(null, null);
		}
		
		private function onLoginError(event:LoginEvent, passThroughData:Object):void
		{
			Assert.assertTrue(true, true);
		}
		
		private function onLoginErrorTimeout(passThroughData:Object):void
		{
			
			Assert.fail("LoginService error timed out.");
		}
	}
}
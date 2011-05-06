package suites
{
	import suites.servicetests.LoginServiceTests;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class ServiceSuite
	{
		
		public var loginServiceTests:LoginServiceTests;
		
		public function ServiceSuite()
		{
		}
	}
}
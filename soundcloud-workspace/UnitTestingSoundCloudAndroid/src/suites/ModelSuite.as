package suites
{
	import suites.servicetests.UserModelTests;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class ModelSuite
	{
		
		public var userModelTests:UserModelTests;
		
		public function ModelSuite()
		{
		}
	}
}
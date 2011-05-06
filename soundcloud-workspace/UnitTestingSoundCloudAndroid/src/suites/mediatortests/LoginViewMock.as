package suites.mediatortests
{
	import com.jxl.soundcloud.views.mainviews.ILoginView;
	
	import flash.events.Event;
	
	public class LoginViewMock implements ILoginView
	{
		public function LoginViewMock()
		{
		}
		
		public function set currentState(newState:String):void
		{
		}
		
		public function get currentState():String
		{
			return null;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return false;
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return false;
		}
		
		public function willTrigger(type:String):Boolean
		{
			return false;
		}
	}
}
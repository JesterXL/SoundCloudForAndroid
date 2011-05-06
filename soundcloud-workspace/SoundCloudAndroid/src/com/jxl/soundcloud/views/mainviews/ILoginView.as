package com.jxl.soundcloud.views.mainviews
{
	import flash.events.IEventDispatcher;

	public interface ILoginView extends IEventDispatcher
	{
		function set currentState(newState:String):void;
		function get currentState():String;
	}
}
package com.jxl.soundcloud.events
{
	import flash.events.Event;
	
	public class GetFavoritesServiceEvent extends Event
	{
		public static const GET_FAVORITES_SUCCESS:String 	= "getFavoritesSuccess";
		public static const GET_FAVORITES_ERROR:String 		= "getFavoritesError";
		
		public var favorites:Array;
		
		public function GetFavoritesServiceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			var evt:GetFavoritesServiceEvent = new GetFavoritesServiceEvent(type, bubbles, cancelable);
			evt.favorites = favorites;
			return evt;
		}
	}
}
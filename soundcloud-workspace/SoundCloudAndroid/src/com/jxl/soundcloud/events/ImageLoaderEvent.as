
package com.jxl.soundcloud.events
{
	import flash.events.Event;
	
	public class ImageLoaderEvent extends Event
	{
		public static const IMAGE_LOAD_COMPLETE:String 			= "imageLoadComplete";
		public static const IMAGE_LOAD_INIT:String				= "imageLoadInit";
		public static const IMAGE_LOAD_ERROR:String				= "imageLoadError";
		
		public var lastError:String;
		
		public function ImageLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
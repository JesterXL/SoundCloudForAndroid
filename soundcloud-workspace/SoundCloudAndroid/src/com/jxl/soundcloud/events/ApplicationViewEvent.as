/**
 * Created by IntelliJ IDEA.
 * User: jesse
 * Date: Sep 26, 2010
 * Time: 2:08:12 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jxl.soundcloud.events
{
    import flash.events.Event;

    public class ApplicationViewEvent extends Event
    {

        public static const VOLUME_SLIDER_CHANGED:String = "volumeSliderChanged";

        public var volume:Number;

        public function ApplicationViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public override function clone():Event
		{
			return new ApplicationViewEvent(type, bubbles, cancelable);
		}
    }
}
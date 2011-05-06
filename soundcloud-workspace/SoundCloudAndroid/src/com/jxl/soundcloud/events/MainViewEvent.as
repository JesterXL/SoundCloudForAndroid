/**
 * Created by IntelliJ IDEA.
 * User: jesse
 * Date: Sep 10, 2010
 * Time: 4:22:37 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jxl.soundcloud.events
{
    import flash.events.Event;

    public class MainViewEvent extends Event
    {
        public static const QUIT:String = "quit";

        public function MainViewEvent(type:String,bubbles:Boolean = false,cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
        }

    }
}
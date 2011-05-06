/**
 * Created by IntelliJ IDEA.
 * User: jesse
 * Date: Sep 13, 2010
 * Time: 7:12:12 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jxl.soundcloud.events
{
    import flash.events.Event;

    public class CacheableSoundEvent extends Event
    {

        public static const READY:String = "ready";


        public function CacheableSoundEvent(type:String,bubbles:Boolean = false,cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
        }


    }
}
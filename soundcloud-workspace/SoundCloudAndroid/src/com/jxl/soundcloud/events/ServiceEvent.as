/**
 * Created by IntelliJ IDEA.
 * User: jesse
 * Date: Sep 12, 2010
 * Time: 1:36:56 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jxl.soundcloud.events
{
    import flash.events.Event;

    public class ServiceEvent extends Event
    {

        public static const CACHE_SONG_SUCCESS:String               = "cacheSongSuccess";
        public static const CACHE_SONG_ERROR:String                 = "cacheSongError";

        public static const CACHE_SONG_READ_SUCCESS:String          = "cacheSongReadSuccess";
        public static const CACHE_SONG_READ_ERROR:String            = "cacheSongReadError";
        public static const CACHE_SONG_READ_NOT_FOUND:String        = "cacheSongReadNotFound";



        public function ServiceEvent(type:String,bubbles:Boolean = false,cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
        }
    }
}
/**
 * Created by IntelliJ IDEA.
 * User: jesse
 * Date: Sep 26, 2010
 * Time: 3:05:27 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jxl.soundcloud.events
{
    import com.jxl.soundcloud.events.PlaybackControlsEvent;

    import com.jxl.soundcloud.vo.SongVO;

    import flash.events.Event;

    public class PlaybackControlsEvent extends Event
    {

        public static const PLAY:String                         = "play";
        public static const STOP:String                         = "stop";
        public static const NEXT_SONG:String                    = "nextSong";
        public static const PREVIOUS_SONG:String                = "previousSong";
        public static const VOLUME_SLIDER_CHANGED:String        = "volumeSliderChanged";

        public var volume:Number;
        public var song:SongVO;

        public function PlaybackControlsEvent(type:String,bubbles:Boolean = true,cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
        }

        public override function clone():Event
        {
            var evt:PlaybackControlsEvent = new PlaybackControlsEvent(type, bubbles, cancelable);
            evt.volume = volume;
            evt.song = song;
            return evt;
        }
    }
}
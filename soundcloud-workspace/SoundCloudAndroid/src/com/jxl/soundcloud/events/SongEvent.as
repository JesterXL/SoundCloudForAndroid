package com.jxl.soundcloud.events
{
	import com.jxl.soundcloud.vo.SongVO;
	
	import flash.events.Event;
    import flash.html.__HTMLScriptArray;

    public class SongEvent extends Event
	{
		public static const PLAY:String 			            = "play";
		public static const STOP:String 			            = "stop";
        public static const VOLUME_CHANGED:String               = "volumeChanged";
        public static const CURRENT_SONG_CHANGED:String         = "currentSongChanged";
        public static const SEEK_CLICKED:String                 = "seekClicked";
		
		public var song:SongVO;
        public var volume:Number;
        public var seekPercent:Number;
		
		public function SongEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

        public override function clone():Event
        {
            var event:SongEvent = new SongEvent(type, bubbles, cancelable);
            event.song = song;
            event.volume = volume;
            return event;
        }
	}
}
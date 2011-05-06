package com.jxl.soundcloud.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flashx.textLayout.formats.BaselineOffset;
	
	import org.iotashan.oauth.OAuthConsumer;

	[Event(name="playingChanged")]
    [Event(name="currentTimeChanged")]
    [Event(name="downloadProgressChanged")]
	public class SongVO extends EventDispatcher
	{
		
		private var _playing:Boolean = false;
        private var _currentTime:Number = 0;
        private var _downloadProgress:Number = 0;
		
		public function get playing():Boolean { return _playing; }
		public function set playing(value:Boolean):void
		{
			if(_playing !== value)
			{
				_playing = value;
				dispatchEvent(new Event("playingChanged"));
			}
			
		}



        public function get currentTime():Number { return _currentTime; }
        public function set currentTime(value:Number):void
        {
            if(_currentTime !== value)
            {
                _currentTime = value;
                dispatchEvent(new Event("currentTimeChanged"));
            }
        }

        public function get downloadProgress():Number { return _downloadProgress; }
        public function set downloadProgress(value:Number):void
        {
            if(_downloadProgress !== value)
            {
                _downloadProgress = value;
                dispatchEvent(new Event("downloadProgressChanged"));
            }
        }


		
		public var artworkURL:String; // used
		/*
		public var bpm:*;
		public var commentable:Boolean;
		public var commentCount:uint;
		*/
		public var createdAt:String; // TODO: parse to Date
		//public var description:String;
		public var downloadable:Boolean;// used
		//public var downloadCount:uint;
		public var downloadURL:String;// used
		public var duration:Number;// used
		/*
		public var favoritingsCount:uint;
		public var genre:String;
		public var ID:uint;
		public var isrc:String;
		public var keySignature:String;
		public var labelID:uint;
		public var labelName:String;
		public var license:String;
		public var originalFormat:String;
		public var permalink:String;
		public var permalinkURL:String;
		public var playbackCount:uint;
		public var purchaseURL:String;
		public var release:String;
		public var releaseDay:String;
		public var releaseMonth:String;
		public var releaseYear:String;
		public var sharing:String;
		public var state:String;
		*/
		public var streamable:Boolean;// used
		public var streamURL:String;// used
		//public var tagList:Array;
		public var title:String;// used
		/*
		public var trackType:String;
		public var URI:String;
		*/
		//public var user:UserVO;
		/*
		public var userFavorite:Boolean;
		public var userID:uint;
		public var userPlaybackCount:uint;
		public var videoURL:String;
		*/
		public var waveformURL:String;// used
		
		

		public function SongVO()
		{
		}
	}
}
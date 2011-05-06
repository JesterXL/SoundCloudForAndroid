package com.jxl.soundcloud.rl.models
{
	import com.greensock.plugins.SoundTransformPlugin;
	import com.jxl.soundcloud.Constants;
	import com.jxl.soundcloud.events.AuthorizeEvent;
	import com.jxl.soundcloud.events.GetFavoritesServiceEvent;
	import com.jxl.soundcloud.events.ServiceEvent;
	import com.jxl.soundcloud.events.SongEvent;
	import com.jxl.soundcloud.media.SoundPlayer;
	import com.jxl.soundcloud.services.CacheSongService;
	import com.jxl.soundcloud.services.GetFavoritesService;
	import com.jxl.soundcloud.vo.SongVO;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import org.robotlegs.mvcs.Actor;
	
	[Event(name="play", type="com.jxl.soundcloud.vo.SongVO")]
	[Event(name="stop", type="com.jxl.soundcloud.vo.SongVO")]
	public class SongModel extends Actor
	{

        [Inject]
        public var cacheSongService:CacheSongService;
		
		private var _currentPlaylist:Playlist;
		private var sound:Sound;
		private var urlRequest:URLRequest;
		private var soundChannel:SoundChannel;
        private var timer:Timer;
        private var _volume:Number = 100;

        public function get volume():Number { return _volume; }
        public function set volume(value:Number):void
        {
            if(value !== _volume)
            {
                _volume = value;
                var event:SongEvent = new SongEvent(SongEvent.VOLUME_CHANGED);
                event.volume = _volume;
                dispatch(event);
            }
            if(soundChannel)
            {
                updateSoundChannelVolume();
            }
        }
		
		public function get currentPlaylist():Playlist { return _currentPlaylist; }
		public function set currentPlaylist(value:Playlist):void
		{
			if(_currentPlaylist !== value)
			{
				stopAndAbortPlayback();
				_currentPlaylist = value;
			}
		}
		
		public function SongModel()
		{
			super();
		}
		
		public function play(song:SongVO):void
		{
			//Debug.logHeader();
			//Debug.log("SongModel::play, : " + song.title);
			if(currentPlaylist.currentSong == song)
			{
				if(sound)
				{
					//Debug.log("playing the current song on the playlist, resuming playback.");
					startPlayback();
				}
				else
				{
					//Debug.log("playing the current song on the playlist, although it looks like you switched, so loading.");
					startPlayback(true);
				}
			}
			else
			{
				if(currentPlaylist.containsSong(song))
				{
					//Debug.log("Not the current song, aborting playback, loading new one.");
					stopAndAbortPlayback();
					currentPlaylist.setCurrentSong(song);
					startPlayback(true);
	                var event:SongEvent = new SongEvent(SongEvent.CURRENT_SONG_CHANGED);
	                event.song = song;
	                dispatch(event);
				}
				else
				{
					//Debug.log("Song not found in current playlist, doing nothing.");
				}
			}
		}
		
		public function stop():void
		{
			stopPlayback();
		}

        public function nextSong():void
        {
           	if(currentPlaylist)
			{
				if(currentPlaylist.canNext())
				{
					stopAndAbortPlayback();
					currentPlaylist.next();
					startPlayback(true);
					var event:SongEvent = new SongEvent(SongEvent.CURRENT_SONG_CHANGED);
					event.song = currentPlaylist.currentSong;
					dispatch(event);
				}
			}
        }

        public function previousSong():void
        {
			if(currentPlaylist)
			{
				if(currentPlaylist.canPrevious())
				{
					stopAndAbortPlayback();
					currentPlaylist.previous();
					startPlayback(true);
					var event:SongEvent = new SongEvent(SongEvent.CURRENT_SONG_CHANGED);
					event.song = currentPlaylist.currentSong;
					dispatch(event);
				}
			}
        }
		
        public function seek(time:Number):void
        {
            if(sound)
                internalPlay(time);
        }

        /*
        public function get position():Number
        {
            if(soundChannel)
            {
                return soundChannel.position;
            }
            else
            {
                return NaN;
            }
        }
        */

        public function get length():Number
        {
            if(sound)
            {
                return sound.length;
            }
            else
            {
                return NaN;
            }
        }
		
		private function startPlayback(load:Boolean=false):void
		{
			//Debug.logHeader();
			//Debug.log("SongModel::startPlayback, load: " + load);
			if(currentPlaylist.currentSong == null) return;
			
			if(timer == null)
			{
				timer = new Timer(1000);
				timer.addEventListener(TimerEvent.TIMER, onTick);
			}
			timer.reset();
			timer.start();
			
			if(currentPlaylist.currentSong) currentPlaylist.currentSong.playing = true;
			
			if(sound == null)
			{
				sound = new Sound();
				sound.addEventListener(IOErrorEvent.IO_ERROR, onError);
				sound.addEventListener(ProgressEvent.PROGRESS, onProgress);
				sound.addEventListener(Event.COMPLETE, onComplete);
			}
			
			if(load)
			{
				
				if(urlRequest == null)
					urlRequest = new URLRequest();
				
				if(cacheSongService.cached(currentPlaylist.currentSong.title + Constants.SOUND_FILE_EXTENSION) == false)
				{
					//Debug.log("not in cache, loading from internets.");
					if(currentPlaylist.currentSong.streamable)
					{
						urlRequest.url = currentPlaylist.currentSong.streamURL;
					}
					else if(currentPlaylist.currentSong.downloadable)
					{
						urlRequest.url = currentPlaylist.currentSong.downloadURL;
					}
					else
					{
						//Debug.log("Song isn't streamable, nor downloadable.");
						return;
					}
				}
				else
				{
					//Debug.log("FOUND in cache, loading from disk.");
					//Debug.log(cacheSongService.getURL(currentPlaylist.currentSong.title + Constants.SOUND_FILE_EXTENSION));
					urlRequest.url = cacheSongService.getURL(currentPlaylist.currentSong.title + Constants.SOUND_FILE_EXTENSION);
				}
				
				sound.load(urlRequest);
				
			}
			
			if(soundChannel)
			{
				internalPlay(soundChannel.position);
			}
			else
			{
				internalPlay();
			}
			
			updateSoundChannelVolume();
		}

		// TODO: seeking is broken for non 44k sounds (or ... well, just some sounds)
        private function internalPlay(startTime:Number=0):void
        {
            if(soundChannel)
            {
                soundChannel.stop();
                soundChannel = sound.play(Math.round(startTime));
            }
            else
            {
			    soundChannel = sound.play();
                soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundPlaybackComplete);
            }
			updateSoundChannelVolume();
        }

        private function updateSoundChannelVolume():void
        {
            var transform:SoundTransform = soundChannel.soundTransform;
            transform.volume = _volume / 100;
            soundChannel.soundTransform = transform;
        }
		
		private function stopAndAbortPlayback():void
		{
			//Debug.log("SongModel::stopAndAbortPlayback");
			
			if(soundChannel)
			{
				if(currentPlaylist.currentSong) currentPlaylist.currentSong.playing = false;
				soundChannel.stop();	
				soundChannel = null;
			}
			
			if(sound)
			{
                try {sound.close()} catch(err:Error){};
				sound.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				sound.removeEventListener(ProgressEvent.PROGRESS, onProgress);
                sound.removeEventListener(Event.COMPLETE, onComplete);
				sound = null;
			}

            if(timer)
                timer.stop();
		}
		
		private function stopPlayback():void
		{
			//Debug.log("SongModel::stopPlayback");
			
			if(soundChannel)
			{
				soundChannel.stop();
				if(currentPlaylist.currentSong) currentPlaylist.currentSong.playing = false;
			}

            if(timer)
                timer.stop();
		}

        private function getCurrentSongURL(song:SongVO):String
        {
            if(song.streamable)
            {
                return song.streamURL;
            }
            else if(song.downloadable)
            {
                return song.downloadURL;
            }
            else
            {
                return null;
            }
        }

        private function onError(event:IOErrorEvent):void
		{
            Debug.log("SongModel::onError: " + event.text);
		}

		private function onProgress(event:ProgressEvent):void
		{
			currentPlaylist.currentSong.downloadProgress = event.bytesLoaded / event.bytesTotal;
		}

        private function onTick(event:TimerEvent):void
        {
			if(currentPlaylist && currentPlaylist.currentSong && soundChannel)
				currentPlaylist.currentSong.currentTime = soundChannel.position;
        }

        private function onComplete(event:Event):void
        {
            //Debug.log("SongModel::onComplete, caching song...");
           // Debug.log("length: " + sound.length + ", position: " + soundChannel.position);
            cacheSongService.addEventListener(ServiceEvent.CACHE_SONG_ERROR, onCacheSongError);
            cacheSongService.addEventListener(ServiceEvent.CACHE_SONG_SUCCESS, onCacheSongSuccess);
            var url:String = getCurrentSongURL(currentPlaylist.currentSong);
            cacheSongService.saveToCacheFromURL(getFileName(currentPlaylist.currentSong), url);
        }

        private function onCacheSongError(event:ServiceEvent):void
        {
            Debug.log("SongModel::onCacheSongError");
        }

        private function onCacheSongSuccess(event:ServiceEvent):void
        {
           // Debug.log("SongModel::onCacheSongSuccess");
        }

        private function onSoundPlaybackComplete(event:Event):void
        {
            //Debug.log("SoundModel::onSoundPlaybackComplete");
            nextSong();
        }

        private function getFileName(song:SongVO):String
        {
            return song.title + Constants.SOUND_FILE_EXTENSION;
        }

	}
}
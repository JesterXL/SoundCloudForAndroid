package com.jxl.soundcloud.rl.models
{
	import com.jxl.soundcloud.vo.SongVO;
	
	
	public class Playlist
	{
		
		private var _playlistItems:Array;
		private var _currentSong:SongVO;
		
		public function get playlistItems():Array { return _playlistItems; }
		public function set playlistItems(value:Array):void
		{
			if(_playlistItems !== value)
			{
				_playlistItems = value;
				_currentSong = null;
			}
		}
		
		public function get currentSong():SongVO { return _currentSong; }
		
		public function get length():int
		{
			if(_playlistItems)
			{
				return _playlistItems.length;
			}
			else
			{
				return 0;
			}
		}
		
		public function Playlist()
		{
			super();
		}
		
		public function next():SongVO
		{
			if(_currentSong && _playlistItems && _playlistItems.length > 1)
			{
				var currentIndex:int = _playlistItems.indexOf(_currentSong);
				if(currentIndex > -1 && currentIndex + 1 < _playlistItems.length)
				{
					var nextSong:SongVO = _playlistItems[currentIndex + 1] as SongVO;
					_currentSong = nextSong;
					return nextSong;
				}
			}
			else if(_playlistItems && _playlistItems.length > 0)
			{
				_currentSong = _playlistItems[0] as SongVO;
				return _currentSong;
			}
			return null;
		}
		
		public function previous():SongVO
		{
			if(_currentSong && _playlistItems && _playlistItems.length > 1)
			{
				var currentIndex:int = _playlistItems.indexOf(_currentSong);
				if(currentIndex > -1 && currentIndex != 0)
				{
					var previousSong:SongVO = _playlistItems[currentIndex - 1] as SongVO;
					_currentSong = previousSong;
					return _currentSong;
				}
			}
			return null;
		}
		
		public function canPrevious():Boolean
		{
			if(_currentSong && _playlistItems && _playlistItems.length > 1)
			{
				var currentIndex:int = _playlistItems.indexOf(_currentSong);
				if(currentIndex > -1 && currentIndex != 0)
				{
					return true;
				}
			}
			return false;
		}
		
		public function canNext():Boolean
		{
			if(_currentSong && _playlistItems && _playlistItems.length > 1)
			{
				var currentIndex:int = _playlistItems.indexOf(_currentSong);
				if(currentIndex > -1 && currentIndex + 1 < _playlistItems.length)
				{
					return true;
				}
			}
			else if(_playlistItems && _playlistItems.length > 0)
			{
				return true;
			}
			return false;
		}
		
		public function containsSong(song:SongVO):Boolean
		{
			if(_playlistItems && _playlistItems.length > 0)
			{
				if(_playlistItems.indexOf(song) != -1)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function setCurrentSong(song:SongVO):void
		{
			if(_playlistItems && _playlistItems.length > 0 && containsSong(song))
			{
				_currentSong = song;
			}
			else
			{
				throw new Error("Playlist::setCurrentSong, playlist doesn't contain current song: " + song.title);s
			}
		}
		
		/*
		public function getSongIndex(song:SongVO):int
		{
			if(_playlistItems && _playlistItems.length > 0)
			{
				return _playlistItems.indexOf(song);
			}
			else
			{
				return -1;
			}
		}
		*/
		
	}
}
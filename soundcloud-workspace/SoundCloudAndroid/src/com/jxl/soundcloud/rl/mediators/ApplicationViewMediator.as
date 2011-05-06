package com.jxl.soundcloud.rl.mediators
{
    import com.jxl.soundcloud.events.ApplicationViewEvent;
    import com.jxl.soundcloud.events.GetFavoritesServiceEvent;
    import com.jxl.soundcloud.events.LoginEvent;
    import com.jxl.soundcloud.events.MenuEvent;
    import com.jxl.soundcloud.events.PlaybackControlsEvent;
    import com.jxl.soundcloud.events.SongEvent;
    import com.jxl.soundcloud.rl.models.FavoritesModel;
    import com.jxl.soundcloud.rl.models.Playlist;
    import com.jxl.soundcloud.rl.models.SearchModel;
    import com.jxl.soundcloud.rl.models.SongModel;
    import com.jxl.soundcloud.views.MainView;
    import com.jxl.soundcloud.views.mainviews.ApplicationView;
    import com.jxl.soundcloud.vo.SongVO;
    
    import org.robotlegs.mvcs.Mediator;
	
	public class ApplicationViewMediator extends Mediator
	{
		[Inject]
		public var applicationView:ApplicationView;

		[Inject]
		public var songModel:SongModel;
		
		[Inject]
		public var favoritesModel:FavoritesModel;
		
		[Inject]
		public var searchModel:SearchModel;
		
		private var favoritesPlaylist:Playlist;
		private var searchPlaylist:Playlist;
		
		public function ApplicationViewMediator()
		{
			super();
		}
		
		public override function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener(eventDispatcher, GetFavoritesServiceEvent.GET_FAVORITES_SUCCESS, onGetFavoritesSuccess, GetFavoritesServiceEvent);
			eventMap.mapListener(eventDispatcher, GetFavoritesServiceEvent.GET_FAVORITES_ERROR, onGetFavoritesError, GetFavoritesServiceEvent);
			eventMap.mapListener(eventDispatcher, SongEvent.VOLUME_CHANGED, onVolumeChanged, SongEvent);
            eventMap.mapListener(eventDispatcher, SongEvent.CURRENT_SONG_CHANGED, onCurrentSongChanged, SongEvent);
			eventMap.mapListener(eventDispatcher, SongEvent.STOP, onStop, SongEvent);
			eventMap.mapListener(eventDispatcher, LoginEvent.LOGOUT, onLogout, LoginEvent);
			eventMap.mapListener(eventDispatcher, MenuEvent.REFRESH, onRefresh, MenuEvent);

			eventMap.mapListener(applicationView, SongEvent.PLAY, onPlay, SongEvent);
			eventMap.mapListener(applicationView, SongEvent.STOP, onStop, SongEvent);
            eventMap.mapListener(applicationView, SongEvent.SEEK_CLICKED, onSeekClicked, SongEvent);

            eventMap.mapListener(applicationView, PlaybackControlsEvent.NEXT_SONG, onNextSong, PlaybackControlsEvent);
			eventMap.mapListener(applicationView, PlaybackControlsEvent.PREVIOUS_SONG, onPreviousSong, PlaybackControlsEvent);
            eventMap.mapListener(applicationView, PlaybackControlsEvent.STOP, onControlsStop, PlaybackControlsEvent);
            eventMap.mapListener(applicationView, PlaybackControlsEvent.PLAY, onControlsPlay, PlaybackControlsEvent);
            eventMap.mapListener(applicationView, PlaybackControlsEvent.VOLUME_SLIDER_CHANGED, onVolumeSliderChanged, PlaybackControlsEvent);
			
			getFavorites();
		}
		
		private function getFavorites():void
		{
			applicationView.showLoading();
			favoritesModel.getFavorites();
		}
		
		private function onRefresh(event:MenuEvent):void
		{
			getFavorites();
		}
		
		private function onGetFavoritesSuccess(event:GetFavoritesServiceEvent):void
		{
			applicationView.hideLoading();
			applicationView.favorites = favoritesModel.favorites;
		}
		
		private function onGetFavoritesError(event:GetFavoritesServiceEvent):void
		{
			applicationView.hideLoading();
		}
		
		private function onVolumeChanged(event:SongEvent):void
		{
			applicationView.volume = event.volume;
		}
		
		private function onCurrentSongChanged(event:SongEvent):void
		{
			applicationView.song = event.song;
		}
		
		private function onPlay(event:SongEvent):void
		{
			if(setCurrentPlaylistToOneThatContainsSong(event.song))
			{
				songModel.play(event.song);
			}
			else
			{
				throw new Error("ApplicationViewMediator::onPlay, song not found in available playlists.");
			}
		}
		
		private function onStop(event:SongEvent):void
		{
			songModel.stop();
		}

		private function onSeekClicked(event:SongEvent):void
		{
			if(isNaN(songModel.length) == false)
				songModel.seek(event.seekPercent * songModel.length);
		}
		
       

       

        private function onVolumeSliderChanged(event:PlaybackControlsEvent):void
        {
            songModel.volume = event.volume;
        }

        
		
		

        private function onNextSong(event:PlaybackControlsEvent):void
        {
			if(songModel.currentPlaylist == null)
				setCurrentPlaylistToCurrentState();
				
            songModel.nextSong();
        }

        private function onPreviousSong(event:PlaybackControlsEvent):void
        {
			if(songModel.currentPlaylist == null)
				setCurrentPlaylistToCurrentState();
			
            songModel.previousSong();
        }
		
		private function onControlsStop(event:PlaybackControlsEvent):void
		{
			songModel.stop();
		}

		private function onControlsPlay(event:PlaybackControlsEvent):void
		{
			if(setCurrentPlaylistToOneThatContainsSong(event.song))
			{
				songModel.play(event.song);
			}
			else
			{
				throw new Error("ApplicationViewMediator::onPlay, song not found in available playlists.");
			}
		}
		
		
		private function setCurrentPlaylistToCurrentState():void
		{
			if(applicationView.currentState == "favoritesState")
			{
				initAndSetFavoritesPlaylist();
			}
			else if(applicationView.currentState == "searchState")
			{
				initAndSetSearchPlaylist();
			}
		}
		
       private function setCurrentPlaylistToOneThatContainsSong(song:SongVO):Boolean
	   {
		   if(song == null) return false;
		   
		   if(favoritesModel.favorites && favoritesModel.favorites.indexOf(song) != -1)
		   {
			   initAndSetFavoritesPlaylist();
			   return true;
		   }
		   else if(searchModel.searchResults && searchModel.searchResults.indexOf(song) != -1)
		   {
			   initAndSetSearchPlaylist();
			   return true;
		   }
		   
		   return false;
	   }
	   
	   private function initAndSetFavoritesPlaylist():void
	   {
		   if(favoritesModel.favorites && favoritesModel.favorites.length > 0)
		   {
			   if(favoritesPlaylist == null)
			   {
				   favoritesPlaylist = new Playlist();
			   }
			   favoritesPlaylist.playlistItems = favoritesModel.favorites;
			   songModel.currentPlaylist = favoritesPlaylist;
		   }
	   }
	   
	   private function initAndSetSearchPlaylist():void
	   {
		   if(searchModel.searchResults && searchModel.searchResults.length > 0)
		   {
			   if(searchPlaylist == null)
			   {
				   searchPlaylist = new Playlist();
			   }
			   searchPlaylist.playlistItems = searchModel.searchResults;
			   songModel.currentPlaylist = searchPlaylist;
		   }
	   }
	   
	   private function onLogout(event:LoginEvent):void
	   {
		   songModel.stop();
	   }

        
	}
}
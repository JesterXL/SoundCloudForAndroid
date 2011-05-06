package com.jxl.soundcloud.factories
{
	import com.jxl.soundcloud.Constants;
	import com.jxl.soundcloud.vo.SongVO;
	import com.jxl.soundcloud.vo.UserVO;

	public class SongFactory
	{
		public static function getSongs(objectList:Array):Array
		{
			var a:Constants
			var list:Array = [];
			var len:int = objectList.length;
			for(var index:int = 0; index < len; index++)
			{
				var o:Object 					= objectList[index];
				var song:SongVO 				= new SongVO();
				song.artworkURL  				= o.artwork_url;
				
				song.artworkURL					= o.artwork_url;
				//song.bpm						= o.bpm;
				//song.commentable				= o.commentable;	
				//song.commentCount				= o.comment_count;	
				song.createdAt					= o.created_at;
				//song.description				= o.description
				song.downloadable				= o.downloadable;	
				//song.downloadCount				= o.download_count;
				song.downloadURL				= o.download_url + "?consumer_key=" + Constants.consumerKey;
				song.duration					= o.duration;
				/*
				song.favoritingsCount			= o.favoritings_count;	
				song.genre						= o.genre;
				song.ID							= o.id;	
				song.isrc						= o.isrc;	
				song.keySignature				= o.key_signature;
				song.labelID					= o.label_id;	
				song.labelName					= o.label_name;
				song.license					= o.license;
				song.originalFormat				= o.original_format;	
				song.permalink					= o.permalink;
				song.permalinkURL				= o.permalink_url;	
				song.playbackCount				= o.playback_count	
				song.purchaseURL				= o.purchase_url	
				song.release					= o.release;
				song.releaseDay					= o.release_day;	
				song.releaseMonth				= o.release_month;	
				song.releaseYear				= o.release_year;	
				song.sharing					= o.sharing;
				song.state						= o.state;	
				*/
				song.streamable					= o.streamable;	
				song.streamURL					= o.stream_url + "?consumer_key=" + Constants.consumerKey;
				
				//if(o.tag_list)
				//	song.tagList					= o.tag_list.split(" ");
				
				song.title						= o.title;
				//song.trackType					= o.track_type;
				//song.URI						= o.uri;
				
				/*
				if(o.user)
				{
					var user:UserVO 			= new UserVO();
					user.avatarURL				= o.avatar_url;
					user.ID						= o.id;
					user.permalink				= o.permalink;
					user.permalinkURL			= o.permalink_url;
					user.URI					= o.uri;
					user.username				= o.username;
					song.user					= user;
				}
				*/
				//song.userFavorite				= o.user_favorite;	
				//song.userID						= o.user_id;	
				//song.userPlaybackCount			= o.user_playback_count;	
				//song.videoURL					= o.video_url;
				song.waveformURL				= o.waveform_url;
				list[index] 					= song;
			}
			return list;
		}
	}
}
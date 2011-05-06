package com.jxl.soundcloud.services
{
	import com.dasflash.soundcloud.as3api.SoundcloudClient;
	import com.dasflash.soundcloud.as3api.SoundcloudResponseFormat;
	import com.jxl.soundcloud.Constants;
	
	import org.iotashan.oauth.OAuthToken;

	public class ServiceLocator
	{
		
		public var soundCloudClient:SoundcloudClient;
		
		public function ServiceLocator()
		{
		}
		
		public function initialize(token:OAuthToken=null):void
		{
			if(soundCloudClient == null)
			{
				soundCloudClient = new SoundcloudClient(Constants.consumerKey, 
					Constants.consumerSecret, 
					token, 
					false, 
					SoundcloudResponseFormat.JSON);
		
			}
		}
		
		private static var _inst:ServiceLocator;
		
		public static function get instance():ServiceLocator
		{
			if(_inst == null)
			{
				_inst = new ServiceLocator();
			}
			return _inst;
		}
		
		public static function initialize(token:OAuthToken=null):void
		{
			instance.initialize(token);
		}
	}
}
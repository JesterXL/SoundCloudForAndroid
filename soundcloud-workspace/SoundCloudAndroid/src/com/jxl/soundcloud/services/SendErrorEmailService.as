package com.jxl.soundcloud.services
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;

	public class SendErrorEmailService
	{
		public function SendErrorEmailService()
		{
		}
		
		public function sendErrorEmail():void
		{
			Debug.log("SendErrorEmailService::sendErrorEmail");
			const NEWLINE:String = "%0A";
			
			var str:String = "mailto:soundcloudandroid@jessewarden.com";
			str 				+= "?subject=SoundCloud Errors&body=";
			str					+= escape("capabilities: " + Capabilities.serverString) + NEWLINE;
			str					+= escape("errors: " + Debug.errorsString) + NEWLINE;
			
			try
			{
				Debug.log("message str: " + str);
				navigateToURL(new URLRequest(str));
			}
			catch(err:Error)
			{
				Debug.log("SendErrorEmailService::sendErrorEmail, err: " + err);
			}

		}
	}
}
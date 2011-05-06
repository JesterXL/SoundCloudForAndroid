package assets.images
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	[Embed(source="/assets/images/login-background.png")]
	public class LoginBackground extends Bitmap
	{
		
		
		public function LoginBackground(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
	}
}
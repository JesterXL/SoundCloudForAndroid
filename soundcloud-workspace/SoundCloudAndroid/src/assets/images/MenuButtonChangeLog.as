package assets.images
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	[Embed(source="/assets/images/menu-button-change-log.png")]
	public class MenuButtonChangeLog extends Bitmap
	{
		public function MenuButtonChangeLog(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
	}
}
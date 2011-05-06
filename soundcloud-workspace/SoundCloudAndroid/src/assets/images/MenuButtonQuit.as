package assets.images
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	[Embed(source="/assets/images/menu-button-quit.png")]
	public class MenuButtonQuit extends Bitmap
	{
		public function MenuButtonQuit(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
	}
}
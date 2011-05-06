package assets.images
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	[Embed(source="/assets/images/menu-button-errors.png")]
	public class MenuButtonErrors extends Bitmap
	{
		public function MenuButtonErrors(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
	}
}
package assets.images
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	[Embed(source="/assets/images/header.png")]
	public class HeaderImage extends Bitmap
	{
		public function HeaderImage(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
	}
}
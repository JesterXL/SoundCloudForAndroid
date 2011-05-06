package assets.images
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	[Embed(source="/assets/images/checkbox-selected.png")]
	public class CheckboxSelected extends Bitmap
	{
		public function CheckboxSelected(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
	}
}
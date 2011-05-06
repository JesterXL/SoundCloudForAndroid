/**
 * Created by IntelliJ IDEA.
 * User: jesse
 * Date: Sep 30, 2010
 * Time: 5:44:38 PM
 * To change this template use File | Settings | File Templates.
 */
package assets.images
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;

    [Embed(source="/assets/images/close-button.png")]
    public class CloseButtonImage extends Bitmap
    {
        public function CloseButtonImage(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
    }
}
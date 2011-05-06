/**
 * Created by IntelliJ IDEA.
 * User: jesse
 * Date: Sep 12, 2010
 * Time: 11:14:55 AM
 * To change this template use File | Settings | File Templates.
 */
package assets.flash
{
    import flash.display.MovieClip;

    [Embed(source="/assets/flash/gradient-animes.swf", symbol="GradientProgress")]
    public class LoadingProgress extends MovieClip
    {

        private var frame:uint;

        public function LoadingProgress()
        {
            super();

            stop();
        }

        public function setProgress(value:Number):void
        {
            frame = Math.round(value * 100);
            gotoAndStop(frame);
        }
    }
}
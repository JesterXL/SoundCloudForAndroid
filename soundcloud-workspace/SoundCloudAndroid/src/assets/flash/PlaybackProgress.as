/**
 * Created by IntelliJ IDEA.
 * User: jesse
 * Date: Sep 12, 2010
 * Time: 11:18:41 AM
 * To change this template use File | Settings | File Templates.
 */
package assets.flash
{
    import flash.display.Graphics;
    import flash.display.Shape;

    public class PlaybackProgress extends Shape
    {

        public function PlaybackProgress()
        {
            super();
        }

        private var pooledProgressX:Number;

        public function setProgress(width:Number,  height:Number, progress:Number):void
        {
			pooledProgressX = progress * width;

            var g:Graphics = graphics;
            g.clear();
			
			if(progress == 0) return;

            g.beginFill(0xFF9900, .5);
            g.drawRect(0, 0, pooledProgressX, height);

            g.lineStyle(0, 0xFF5200);
            g.moveTo(pooledProgressX, 0);
            g.lineTo(pooledProgressX, height);

            g.endFill();

        }
    }
}
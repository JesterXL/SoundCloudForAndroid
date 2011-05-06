/**
 * Created by IntelliJ IDEA.
 * User: jesse
 * Date: Sep 26, 2010
 * Time: 2:53:14 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jxl.soundcloud.components
{
    import assets.images.NextButtonOverImage;
    import assets.images.NextButtonUpImage;

    import assets.images.PreviousButtonOverImage;
    import assets.images.PreviousButtonUpImage;

    import com.bit101.components.Component;

    import flash.display.DisplayObjectContainer;
    import flash.events.MouseEvent;

    public class PreviousButton extends SimplePushButton
    {
        private var upImage:PreviousButtonUpImage;
        private var overImage:PreviousButtonOverImage;
        private var over:Boolean =  false;

        public function PreviousButton(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0)
        {
            super(parent, xpos, ypos);
        }

        override protected function init():void
		{
			super.init();
			setSize(72, 72);
		}

        override protected function addChildren():void
        {
            super.addChildren();

            upImage = new PreviousButtonUpImage();
            addChild(upImage);

            overImage = new PreviousButtonOverImage();
            addChild(overImage);
        }

        public override function draw():void
        {
            super.draw();

            if(over == false)
            {
                upImage.visible = true;
                overImage.visible = false;
            }
            else
            {
                upImage.visible = false;
                overImage.visible = true;
            }
        }


    }
}
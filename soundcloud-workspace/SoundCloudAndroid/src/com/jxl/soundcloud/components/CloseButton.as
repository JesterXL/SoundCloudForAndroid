/**
 * Created by IntelliJ IDEA.
 * User: jesse
 * Date: Sep 30, 2010
 * Time: 5:47:13 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jxl.soundcloud.components
{
    import assets.images.CloseButtonImage;

    import flash.display.Sprite;

    public class CloseButton extends Sprite
    {

        private var closeButtonImage:CloseButtonImage;

        public function CloseButton()
        {
            super();

            this.mouseChildren = false;
            this.mouseEnabled = true;

            closeButtonImage = new CloseButtonImage();
            addChild(closeButtonImage);
        }


    }
}
/**
 * Created by IntelliJ IDEA.
 * User: jesse
 * Date: Sep 26, 2010
 * Time: 1:29:42 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jxl.soundcloud.components
{
    import assets.images.VolumeBarSprite;

    import assets.images.VolumeSliderThumbSprite;

    import com.bit101.components.Slider;

    import flash.events.MouseEvent;

    public class VolumeSlider extends Slider
    {
        public function VolumeSlider()
        {
        }

        override protected function addChildren():void
		{
			_back = new VolumeBarSprite();
			addChild(_back);

			_handle = new VolumeSliderThumbSprite();
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			_handle.buttonMode = true;
			_handle.useHandCursor = true;
			addChild(_handle);
		}

        override protected function init():void
		{
			super.init();

			if(_orientation == HORIZONTAL)
			{
				setSize(255, 72);
			}
			else
			{
				setSize(72, 255);
			}
		}
		
		public override function draw():void
		{
			super.draw();
			
			_back.width = width;
			
		}

		/**
		 * Draws the back of the slider.
		 */
		protected override function drawBack():void
		{

			if(_backClick)
			{
				_back.addEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
			}
			else
			{
				_back.removeEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
			}
		}

		/**
		 * Draws the handle of the slider.
		 */
		protected override function drawHandle():void
		{
            // TODO: draw correctly crackhead
			if(_orientation == HORIZONTAL)
			{

			}
			else
			{

            }
			positionHandle();
		}
    }
}
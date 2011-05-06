/**
 * Created by IntelliJ IDEA.
 * User: jesse
 * Date: Sep 26, 2010
 * Time: 2:53:14 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jxl.soundcloud.components
{

    import com.bit101.components.Component;

    import flash.display.DisplayObjectContainer;
    import flash.events.MouseEvent;

    public class SimplePushButton extends Component
    {
        private var over:Boolean =  false;

        public function SimplePushButton(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0)
        {
            super(parent, xpos, ypos);
        }

        override protected function init():void
		{
			super.init();
			buttonMode = true;
			useHandCursor = true;
			setSize(72, 72);
		}

        override protected function addChildren():void
        {
            super.addChildren();

            addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
        }

        protected function onMouseOver(event:MouseEvent):void
		{
			over = true;
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}

		protected function onMouseOut(event:MouseEvent):void
		{
			over = false;
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}

		protected function onMouseDown(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		protected function onMouseUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}




    }
}
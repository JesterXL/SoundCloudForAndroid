/**
 * Created by IntelliJ IDEA.
 * User: jesse
 * Date: Sep 9, 2010
 * Time: 3:41:53 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jxl.soundcloud.components
{
    import com.bit101.components.PushButton;
    
    import flash.display.Bitmap;
    import flash.display.DisplayObjectContainer;

    public class PlayPauseButton extends com.bit101.components.PushButton
    {

        [Embed(source="/assets/images/play-button-up.png")]
        private var PlayButtonUpImage:Class;

        [Embed(source="/assets/images/play-button-over.png")]
        private var PlayButtonOverImage:Class;

        [Embed(source="/assets/images/pause-button-up.png")]
        private var PauseButtonUpImage:Class;

        [Embed(source="/assets/images/pause-button-over.png")]
        private var PauseButtonOverImage:Class;


        private var playButtonUpImage:Bitmap;
        private var playButtonOverImage:Bitmap;

        private var pauseButtonUpImage:Bitmap;
        private var pauseButtonOverImage:Bitmap;
		
		public override function set selected(value:Boolean):void
		{
			super.selected = value;
			this.invalidateDraw();
		}

		public function PlayPauseButton(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, label:String="", defaultHandler:Function=null)
		{
			super(parent, xpos, ypos, label, defaultHandler);
		}

		protected override function init():void
		{
			super.init();
            toggle = true;
			setSize(72, 72);

			mouseChildren = false;
		}

		protected override function addChildren():void
		{
			super.addChildren();

            playButtonUpImage = new PlayButtonUpImage() as Bitmap;
            playButtonOverImage = new PlayButtonOverImage() as Bitmap;

            pauseButtonUpImage = new PauseButtonUpImage() as Bitmap;
            pauseButtonOverImage = new PauseButtonOverImage() as Bitmap;
			
			
		}

		public override function draw():void
		{
			super.draw();

			_face.graphics.clear();
			_back.graphics.clear();

            if(contains(playButtonUpImage))     removeChild(playButtonUpImage);
            if(contains(playButtonOverImage))   removeChild(playButtonOverImage);
            if(contains(pauseButtonUpImage))    removeChild(pauseButtonUpImage);
            if(contains(pauseButtonOverImage))  removeChild(pauseButtonOverImage);

			if(selected)
			{
                if(_over)
                {
                    addChild(pauseButtonOverImage);
                }
                else
                {
                    addChild(pauseButtonUpImage);
                }
			}
			else
			{
				if(_over)
                {
                    addChild(playButtonOverImage);
                }
                else
                {
                    addChild(playButtonUpImage);
                }
			}
		}
    }
}
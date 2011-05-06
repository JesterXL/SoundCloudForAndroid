/**
 * Created by IntelliJ IDEA.
 * User: jesse
 * Date: Sep 26, 2010
 * Time: 3:03:51 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jxl.soundcloud.components
{
    import com.bit101.components.Component;
    import com.jxl.soundcloud.events.PlaybackControlsEvent;
    import com.jxl.soundcloud.vo.SongVO;
    
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.net.SharedObject;

    [Event(name="play", type="com.jxl.soundcloud.events.PlaybackControlsEvent")]
    [Event(name="pause", type="com.jxl.soundcloud.events.PlaybackControlsEvent")]
    [Event(name="nextSong", type="com.jxl.soundcloud.events.PlaybackControlsEvent")]
    [Event(name="previousSong", type="com.jxl.soundcloud.events.PlaybackControlsEvent")]
    [Event(name="volumeSliderChanged", type="com.jxl.soundcloud.events.PlaybackControlsEvent")]
    public class PlaybackControls extends Component
    {

        private var volumeSlider:VolumeSlider;
        private var previousButton:PreviousButton;
        private var nextButton:NextButton;

        private var _volume:Number = 100;
        private var volumeDirty:Boolean = false;

        public function get volume():Number { return _volume; }
        public function set volume(value:Number):void
        {
            if(value !== _volume)
            {
                _volume = value;
                volumeDirty = true;
                invalidateProperties();
            }
        }

        public function PlaybackControls(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0)
        {
            super(parent, xpos, ypos);
        }

        protected override function init():void
        {
            super.init();

            setSize(430, 72);
        }

        protected override function addChildren():void
        {
            super.addChildren();

            volumeSlider = new VolumeSlider();
            addChild(volumeSlider);
            volumeSlider.addEventListener(Event.CHANGE, onVolumeChange);
            volumeSlider.value = _volume;

            previousButton = new PreviousButton();
            addChild(previousButton);
            previousButton.addEventListener(MouseEvent.CLICK, onPreviousClick);

            nextButton = new NextButton();
            addChild(nextButton);
            nextButton.addEventListener(MouseEvent.CLICK, onNextClick);
        }

        protected override function commitProperties():void
        {
            super.commitProperties();

            if(volumeDirty)
            {
                volumeDirty = false;
                volumeSlider.value = _volume;
            }
        }

        public override function draw():void
        {
            super.draw();

            const MARGIN:Number = 16;
			
            nextButton.x = width - nextButton.width;
			
            volumeSlider.x = previousButton.x + previousButton.width + MARGIN;
            volumeSlider.y = (volumeSlider.height / 4);
            volumeSlider.width = width - (nextButton.width * 2) - (MARGIN * 2);
			
			/*
			var g:Graphics = graphics;
			g.clear();
			g.lineStyle(0, 0xFF0000);
			g.drawRect(0, 0, width, height);
			g.lineStyle(2, 0x00FF00, .8);
			g.drawRect(nextButton.x, nextButton.y, nextButton.width, nextButton.height);
			g.lineStyle(4, 0x0000FF, .8);
			g.drawRect(previousButton.x, previousButton.y, previousButton.width, previousButton.height);
			g.endFill();
			*/
        }

        private function onVolumeChange(event:Event):void
        {
            _volume = volumeSlider.value;
            var evt:PlaybackControlsEvent = new PlaybackControlsEvent(PlaybackControlsEvent.VOLUME_SLIDER_CHANGED);
            evt.volume = volumeSlider.value;
            dispatchEvent(evt);
        }

        private function onPreviousClick(event:MouseEvent):void
        {
            dispatchEvent(new PlaybackControlsEvent(PlaybackControlsEvent.PREVIOUS_SONG));
        }

        private function onNextClick(event:MouseEvent):void
        {
            dispatchEvent(new PlaybackControlsEvent(PlaybackControlsEvent.NEXT_SONG));
        }

    }

}
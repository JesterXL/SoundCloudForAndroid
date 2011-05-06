/**
 * Created by IntelliJ IDEA.
 * User: jesse
 * Date: Sep 12, 2010
 * Time: 12:20:21 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jxl.soundcloud.media
{
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SampleDataEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;

    public class SoundPlayer extends EventDispatcher
    {
        public function get soundChannel():SoundChannel { return _soundChannel; }
        public function get playing():Boolean { return _playing; }

        private var sourceSound:Sound;
        private var outputSound:Sound;
        private var urlRequest:URLRequest;
        private var _soundChannel:SoundChannel;
        private var soundBytes:ByteArray;
        private var sampleDataPosition:uint = 0;
        private var _playing:Boolean = false;

        public function SoundPlayer()
        {
        }

        public function load(url:String):void
        {
            if(sourceSound == null)
			{
				sourceSound = new Sound();
				sourceSound.addEventListener(IOErrorEvent.IO_ERROR, onError);
				sourceSound.addEventListener(ProgressEvent.PROGRESS, onProgress);
			}

            if(outputSound == null)
            {
                outputSound = new Sound();
                outputSound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
            }

             if(urlRequest == null) urlRequest = new URLRequest();
            urlRequest.url = url;
            sourceSound.load(urlRequest);
        }

        public function play():SoundChannel
        {
            _playing = true;
            _soundChannel = outputSound.play();
            return _soundChannel;
        }

        public function stopAndAbortPlayback():void
        {
            _playing = false;

			if(_soundChannel)
			{
				_soundChannel.stop();
				_soundChannel = null;
			}

			if(sourceSound)
			{
                try {sourceSound.close()} catch(err:Error){};
				sourceSound.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				sourceSound.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				sourceSound = null;
			}

            if(outputSound)
            {
                try {outputSound.close()} catch(err:Error){};
				outputSound.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
				outputSound = null;
            }
        }

        public function stop():void
        {
            _playing = false;

            if(_soundChannel)
                _soundChannel.stop();
        }

        private function onError(event:IOErrorEvent):void
		{
            _playing = false;
            dispatchEvent(event);
		}

		private function onProgress(event:ProgressEvent):void
		{
            if(soundBytes == null)
            {
                soundBytes = new ByteArray();
                sourceSound.extract(soundBytes, event.bytesLoaded, 0);
            }
            else
            {
                sourceSound.extract(soundBytes, event.bytesLoaded - soundBytes.position, soundBytes.position);

            }

            soundBytes.position = event.bytesLoaded;
            dispatchEvent(event);
		}

        private function onSampleData(event:SampleDataEvent):void
        {
            if(soundBytes.length - sampleDataPosition >= 4096)
            {
                var bytes:ByteArray = soundBytes.readBytes(soundBytes, sampleDataPosition, 4096);
                event.data.writeBytes(soundBytes);
                soundBytes.position = soundBytes.length;
            }
        }
    }
}
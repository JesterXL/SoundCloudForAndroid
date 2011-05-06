/**
 * Created by IntelliJ IDEA.
 * User: jesse
 * Date: Sep 12, 2010
 * Time: 1:26:27 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jxl.soundcloud.services
{
    import com.jxl.soundcloud.events.ServiceEvent;
    
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.net.URLRequest;
    import flash.net.URLStream;
    import flash.utils.ByteArray;
    import flash.utils.getTimer;
    
    import flex.lang.reflect.Field;

    [Event(name="cacheSongSuccess", type="com.jxl.soundcloud.events.ServiceEvent")]
    [Event(name="cacheSongError", type="com.jxl.soundcloud.events.ServiceEvent")]
    public class CacheSongService extends EventDispatcher
    {
        private var file:File;
        private var fileStream:FileStream;
        private var bytes:ByteArray;

        private var _cachedSound:ByteArray;
        private var urlStream:URLStream;
        private var urlRequest:URLRequest;

        private var filename:String;
        private var startDownloadTime:uint;
        private var cachedSoundBytes:ByteArray;

        public function get cachedSound():ByteArray { return _cachedSound; }


        public function CacheSongService()
        {
        }

        public function saveToCacheFromURL(filename:String, url:String):void
        {
			Debug.log("CacheSongService::saveToCacheFromURL, filename: " + filename);
            startDownloadTime = getTimer();
            this.filename = filename;

            if(urlStream == null)
            {
                urlStream = new URLStream();
                urlStream.addEventListener(Event.COMPLETE, onURLStreamComplete);
                urlStream.addEventListener(IOErrorEvent.IO_ERROR, onURLStreamError);
                urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onURLStreamError);
            }
            try
            {
                if(urlRequest == null)
                    urlRequest = new URLRequest();
                urlRequest.url = url;
                urlStream.load(urlRequest);
            }
            catch(err:Error)
            {
                Debug.log("CacheSongService::saveToCacheFromURL, error: " + err);
                dispatchError();
            }
        }

        private function onURLStreamError(event:ErrorEvent):void
        {
            Debug.log("CacheSongService::onURLStreamError, error: " + event.text);
            dispatchError();
        }

        private function onURLStreamComplete(event:Event):void
        {
            var et:uint = getTimer() - startDownloadTime;
            //Debug.log("CacheSongServcie::onURLStreamComplete, total time to download is " + (et / 1000) + " seconds.");
            if(cachedSoundBytes == null)
                cachedSoundBytes = new ByteArray();

            cachedSoundBytes.position = 0;
            urlStream.readBytes(cachedSoundBytes, 0, urlStream.bytesAvailable);
            saveToCache(filename, cachedSoundBytes);
        }

        public function saveToCache(filename:String, bytes:ByteArray):void
        {
            Debug.logHeader();
            Debug.log("CacheSongService::saveToCache");
            Debug.log("filename: " + filename);
            this.filename = filename;
            this.bytes = bytes;

            if(file == null)
            {
                file = getPath().resolvePath(filename);
                Debug.log("app dir: " + file.nativePath);
            }

            if(fileStream == null)
            {
                fileStream = new FileStream();
            }

            try
            {
                fileStream.open(file, FileMode.WRITE);
            }
            catch(err:Error)
            {
                Debug.log("CacheSongService::saveToCache error: " + err);
                dispatchError();
            }

            try
            {
                Debug.log("CacheSongService::onFileOpened, bytes.length: " + bytes.length);
                fileStream.writeBytes(bytes, 0, bytes.length);
                fileStream.close();
                fileStream = null;
                file = null;
                dispatchEvent(new ServiceEvent(ServiceEvent.CACHE_SONG_SUCCESS));
            }
            catch(err:Error)
            {
                Debug.log("CacheSongService::onFileOpened, error: " + err);
                dispatchError();
            }
        }



        private function dispatchError():void
        {
            dispatchEvent(new ServiceEvent(ServiceEvent.CACHE_SONG_ERROR));
        }

        public function cached(filename:String):Boolean
        {
            file = getPath().resolvePath(filename);
            if(file.exists)
            {
                file = null;
                return true;
            }
            else
            {
               // Debug.log("CacheSongService::cached, " + file.nativePath + " does not exist.");
                return false;
            }
        }

        public function getURL(filename:String):String
        {
            file = getPath().resolvePath(filename);
            var filePath:String;
            if(file.exists)
            {
                filePath = file.url;
                file = null;
                return filePath;
            }
            else
            {
                file = null;
                return null;
            }
        }

        public function readFromCache(filename:String):void
        {
            //Debug.logHeader();
           // Debug.log("CacheSongService::saveToCache");
           // Debug.log("filename: " + filename);
            this.bytes = bytes;

            file = getPath().resolvePath(filename);
           // Debug.log("file.nativePath: " + file.nativePath);
            if(file.exists)
            {
                fileStream = new FileStream();
                fileStream.addEventListener(Event.COMPLETE, onReadFileOpened);
                fileStream.addEventListener(IOErrorEvent.IO_ERROR, onReadFileIOError);

                try
                {
                    fileStream.openAsync(file, FileMode.READ);
                }
                catch(err:Error)
                {
                    Debug.log("CacheSongService::readFromCache error: " + err);
                   dispatchEvent(new ServiceEvent(ServiceEvent.CACHE_SONG_READ_ERROR));
                }
            }
            else
            {
                dispatchEvent(new ServiceEvent(ServiceEvent.CACHE_SONG_READ_NOT_FOUND));
            }
        }

        private function onReadFileIOError(event:IOErrorEvent):void
        {
            Debug.log("CacheSongService::onReadFileIOError: " + event.text);
            dispatchEvent(new ServiceEvent(ServiceEvent.CACHE_SONG_READ_ERROR));
        }

        private function onReadFileOpened(event:Event):void
        {
            fileStream.readBytes(_cachedSound, 0, fileStream.bytesAvailable);
            fileStream.removeEventListener(Event.COMPLETE, onReadFileOpened);
            fileStream.removeEventListener(IOErrorEvent.IO_ERROR, onReadFileIOError);
            fileStream.close();
            fileStream = null;
            file = null;
            dispatchEvent(new ServiceEvent(ServiceEvent.CACHE_SONG_READ_SUCCESS));
        }
		
		private function getPath():File
		{
			/*
			var file:File = File.userDirectory;
			var path:String = file.nativePath + "/soundcloud";
			return File.userDirectory.resolvePath(path);
			*/
			return File.userDirectory;
		}
    }
}
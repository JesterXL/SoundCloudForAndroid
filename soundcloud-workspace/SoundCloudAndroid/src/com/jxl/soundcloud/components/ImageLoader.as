package com.jxl.soundcloud.components
{
	import com.bit101.components.Component;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.jxl.soundcloud.events.ImageLoaderEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	[Event(name="imageLoadComplete", type="com.jxl.soundcloud.events.ImageLoaderEvent")]
	[Event(name="imageLoadError", type="com.jxl.soundcloud.events.ImageLoaderEvent")]
	[Event(name="imageLoadInit", type="com.jxl.soundcloud.events.ImageLoaderEvent")]
	
	public class ImageLoader extends Component
	{
		
		public function get source():* { return _source; }
		
		public function set source(val:*):void
		{
			_source 		= val;
			_sourceDirty 	= true;
			invalidateProperties();
		}
		
		public function get loading():Boolean { 					return _loading; }
		
		public function get content():DisplayObject { 				return _content; }
		
		public function get contentWidth():Number
		{
			if(_content)
			{
				return _content.width;
			}
			else
			{
				return 0;
			}
		}
		
		public function get contentHeight():Number
		{
			if(_content)
			{
				return _content.height;
			}
			else
			{
				return 0;
			}
		}
		
		public function get scaleContent():Boolean { 				return _scaleContent; }
		
		public function set scaleContent(value:Boolean):void
		{
			_scaleContent = value;
			invalidateDraw();
		}
		
		public function get maintainAspectRatio():Boolean { 		return _maintainAspectRatio; }
		public function set maintainAspectRatio(value:Boolean):void
		{
			_maintainAspectRatio = value;
			invalidateDraw();
		}
		
		public function get centerContent():Boolean { 				return _centerContent; }
		public function set centerContent(val:Boolean):void
		{
			_centerContent = val;
			invalidateDraw();
		}
		
		protected var _scaleContent:Boolean					= false;
		protected var _maintainAspectRatio:Boolean			= true;
		protected var _sourceDirty:Boolean					= false;
		protected var _centerContent:Boolean				= true;
		
		protected var _content:Sprite;
		protected var _loading:Boolean						= false;
		protected var _contentLoader:Loader;
		protected var _external:Boolean						= false;
		protected var _source:*;
		protected var _smoothedBitmap:Bitmap;
		
		public function ImageLoader(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(_sourceDirty == true)
			{
				_sourceDirty = false;
				load();
			}
		}
		
		protected function load():void
		{
				if(_source == null) return;
				
				
				if(_contentLoader == null)
				{
					_contentLoader = new Loader();
					_contentLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, 	onLoadError);
					_contentLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, 			onLoadComplete);
					_contentLoader.contentLoaderInfo.addEventListener(Event.OPEN, 				onOpen);
					_contentLoader.contentLoaderInfo.addEventListener(Event.INIT, 				onLoadInit);
					_contentLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, 	onProgress);
				}
				
				_loading = true;
				
				if(_content != null)
				{
					if(contains(_content) == true) removeChild(_content);
				}
				_content = new Sprite();
				
				var imageLoaderEvent:ImageLoaderEvent;
				if(_source is String)
				{
					if(_source.indexOf(".") != -1)
					{
						_external = true;
						try
						{
							_contentLoader.load(new URLRequest(_source));
						}
						catch(error:SecurityError)
						{
							_loading = false;
							imageLoaderEvent = new ImageLoaderEvent(ImageLoaderEvent.IMAGE_LOAD_ERROR);
							imageLoaderEvent.lastError = error.message;
							dispatchEvent(imageLoaderEvent);
						}
					}
				}
				else if(_source is ByteArray)
				{
					_external = false;
					try
					{
						_contentLoader.loadBytes(_source);
					}
					catch(err:Error)
					{
						_loading = false;
						imageLoaderEvent = new ImageLoaderEvent(ImageLoaderEvent.IMAGE_LOAD_ERROR);
						imageLoaderEvent.lastError = err.message;
						dispatchEvent(imageLoaderEvent);
					}
				}
				else
				{
					_external = false;
					var child:DisplayObject = new _source() as DisplayObject;
					_content.addChild(child);
					if(contains(_content) == false) addChild(_content);
					_loading = false;
					if (_scaleContent == false)
					{
						_width 	= child.width;
						_height = child.height;
					}
					imageLoaderEvent = new ImageLoaderEvent(ImageLoaderEvent.IMAGE_LOAD_COMPLETE);
					dispatchEvent(imageLoaderEvent);
				}
		}
		
		protected function setContentSize(target:DisplayObject, width:Number, height:Number):void
		{
			target.width 	= width;
			target.height 	= height;
		}
		
		protected function onOpen(event:Event):void
		{
			dispatchEvent(event);
		}
		
		protected function onProgress(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}
		
		protected function onLoadComplete(event:Event):void
		{
			if(_external == false)
			{
				if(contains(_content) == false) addChild(_content);
			}
			if (_scaleContent == false)
			{
				_width 	= _content.width;
				_height = _content.height;
			}
			dispatchEvent(new ImageLoaderEvent(ImageLoaderEvent.IMAGE_LOAD_COMPLETE));
			dispatchEvent(event);
		}
		
		protected function onLoadInit(event:Event):void
		{
			if(_smoothedBitmap != null)
			{
				if(_content.contains(_smoothedBitmap) == true)
				{
					_content.removeChild(_smoothedBitmap);
					_smoothedBitmap = null;
				}
			}
			
			//try
			//{
			//	if (_contentLoader.content is Bitmap)
			//	{
					//_smoothedBitmap = smoothLoadedContent(_contentLoader.content as Bitmap);
					//_content.addChild(_smoothedBitmap);
			//	}
			//}
			//catch(err:Error)
			//{
				_content.addChild(_contentLoader);
			//}
			
			invalidateDraw();
			
			alpha = 0;
			TweenLite.to(this, 1, {alpha: 1, ease: Expo.easeOut});
			
			_loading = false;
			
			dispatchEvent(new ImageLoaderEvent(ImageLoaderEvent.IMAGE_LOAD_INIT));
			dispatchEvent(event);
		}
		
		protected function smoothLoadedContent(targetBitmap:Bitmap):Bitmap
		{
			var targetBitmapData:BitmapData = new BitmapData(targetBitmap.width, targetBitmap.height);
			var sourceRect:Rectangle 		= new Rectangle(targetBitmap.x, targetBitmap.y, targetBitmap.width, targetBitmap.height);
			var destPoint:Point 			= new Point(0, 0);
			targetBitmapData.copyPixels(targetBitmap.bitmapData, sourceRect, destPoint);
			var mainBitmap:Bitmap 			= new Bitmap(targetBitmapData, "auto", true);
			return mainBitmap;
		}
		
		protected function onLoadError(event:IOErrorEvent):void
		{
			_loading = false;
			var evt:ImageLoaderEvent = new ImageLoaderEvent(ImageLoaderEvent.IMAGE_LOAD_ERROR);
			evt.lastError = event.text;
			dispatchEvent(evt);
			//dispatchEvent(event);
		}
		
		public override function draw():void
		{
			super.draw();
			
			if(_loading == true) return;
			if(_content == null) return;
			
			graphics.clear();
			graphics.beginFill(0x000000, 0);
			//graphics.lineStyle(2, 0x666666);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
			
			if(_maintainAspectRatio == true)
			{
				var aspectRatio:Number;
				if(_content.width >= _content.height)
				{
					aspectRatio = _content.width / _content.height;
					var desiredHeight:Number = _width / aspectRatio;
					
					if(desiredHeight <= _height)
					{
						setContentSize(_content, _width, desiredHeight);
					}
					else
					{
						setContentSize(_content, aspectRatio * _height, _height);
					}
				}
				else
				{
					aspectRatio = _content.height / _content.width;
					var desiredWidth:Number = _height / aspectRatio;
					
					if(desiredWidth <= _width)
					{
						setContentSize(_content, desiredWidth, _height);
					}
					else
					{
						setContentSize(_content, _width, aspectRatio * _width);
					}
				}
			}
			else
			{
				_content.width = _width;
				_content.height = _height;
			}
			
			if(_centerContent == true)
			{
				if(_width > _content.width)
				{
					_content.x = (_width / 2) - (_content.width / 2);
				}
				else
				{
					_content.x = 0;
				}
				
				if(_height > _content.height)
				{
					_content.y = (_height / 2) - (_content.height / 2);
				}
				else
				{
					_content.y = 0;
				}
			}
			else
			{
				_content.x = _content.y = 0;
			}
			
			if(contains(_content) == false)
			{
				addChild(_content);
			}
		}
		
	}
}

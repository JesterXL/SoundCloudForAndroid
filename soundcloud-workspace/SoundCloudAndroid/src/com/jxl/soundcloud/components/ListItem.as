package com.jxl.soundcloud.components
{
	import assets.images.CharacterListItemBackground;
	import assets.images.RightArrowBitmap;
	
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.jxl.soundcloud.components.ImageLoader;
	import com.jxl.soundcloud.events.ImageLoaderEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.Font;
	import flash.text.TextFormat;
	
	public class ListItem extends Component
	{
		
		private var _icon:*;
		private var iconDirty:Boolean = false;
		private var _label:String = "";
		private var labelDirty:Boolean = false;
		private var _status:String = "";
		private var statusDirty:Boolean = false;
		
		private var background:CharacterListItemBackground;
		private var iconLoader:ImageLoader;
		private var labelField:Label;
		private var statusField:Label;
		private var arrowBitmap:RightArrowBitmap;
		
		public function get icon():* { return _icon; }
		public function set icon(value:*):void
		{
			_icon = value;
			iconDirty = true;
			invalidateProperties();
		}
		
		public function get label():String { return _label; }
		public function set label(value:String):void
		{
			_label = value;
			labelDirty = true;
			invalidateProperties();
		}
		
		public function get status():String { return _label; }
		public function set status(value:String):void
		{
			_status = value;
			statusDirty = true;
			invalidateProperties();
		}
		
		public function ListItem(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			
			mouseChildren = false;
			buttonMode = useHandCursor = true;
			
			width		= 320;
			height		= 40;
		}
		
		protected override function addChildren():void
		{
			super.addChildren();
			
			background = new CharacterListItemBackground();
			addChild(background);
			
			labelField = new Label();
			addChild(labelField);
			labelField.textField.embedFonts = false;
			var tf:TextFormat = labelField.textField.defaultTextFormat;
			tf.font = "Helvectica Neue";
			tf.bold = true;
			tf.size = 17;
			tf.color = 0x00000;
			labelField.textField.defaultTextFormat = tf;
			
			statusField = new Label();
			addChild(statusField);
			statusField.textField.embedFonts = false;
			tf = statusField.textField.defaultTextFormat;
			tf.font = "Helvetica Neue";
			tf.bold = false;
			tf.size = 17;
			tf.color = 0x505c75;
			statusField.textField.defaultTextFormat = tf;
			
			arrowBitmap = new RightArrowBitmap();
			addChild(arrowBitmap);
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(iconDirty)
			{
				iconDirty = false;
				if(iconLoader == null)
				{
					iconLoader = new ImageLoader();
					addChildAt(iconLoader, 0);
					iconLoader.addEventListener(ImageLoaderEvent.IMAGE_LOAD_INIT, onIconLoaded);
				}
				iconLoader.source = _icon;
			}
			
			if(labelDirty)
			{
				labelDirty = false;
				labelField.text = _label;
				callNextFrame(invalidateDraw);
			}
			
			if(statusDirty)
			{
				statusDirty = false;
				statusField.text = _status;
				callNextFrame(invalidateDraw);
			}
		}
		
		public override function draw():void
		{
			super.draw();
			
			background.width = width;
			background.height = height;
			
			var iconWidth:Number = 0;
			if(iconLoader)
			{
				if(iconLoader.width < 32)
				{
					iconWidth = iconLoader.width;
				}
				else
				{
					iconWidth = 32;
				}
			}
			
			arrowBitmap.y = Math.floor((height / 2) - (arrowBitmap.height / 2));
			arrowBitmap.x = width - (arrowBitmap.width + 4);
			
			labelField.x = 4;
			labelField.y = (height / 2) - ((labelField.textField.textHeight + 4) / 2);
			
			if(iconWidth > 0)
			{
				labelField.x += iconWidth + 4;
			}
			
			statusField.x = arrowBitmap.x - (statusField.textField.textWidth + 8);
			statusField.y = (height / 2) - ((statusField.textField.textHeight + 4) / 2);
			
			
			var g:Graphics = graphics;
			g.clear();
			
			g.lineStyle(0, 0x999999);
			g.moveTo(0, height - 1);
			g.lineTo(width, height - 1);
			
			g.beginFill(0xFFFFFF);
			g.moveTo(0, 0);
			g.drawRect(0, 0, width, height);
			
			/*
			g.lineStyle(0, 0xFF0000);
			g.moveTo(labelField.x, labelField.y);
			g.drawRect(labelField.x, labelField.y, labelField.width, labelField.height);
			
			g.lineStyle(0, 0x0000FF);
			g.moveTo(statusField.x, statusField.y);
			g.drawRect(statusField.x, statusField.y, statusField.width, statusField.height);
			*/
			g.endFill();
		}
		
		private function onIconLoaded(event:ImageLoaderEvent):void
		{
			invalidateDraw();
		}
	}
}
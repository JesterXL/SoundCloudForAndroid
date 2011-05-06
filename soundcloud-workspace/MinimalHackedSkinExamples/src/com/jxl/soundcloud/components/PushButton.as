package com.jxl.soundcloud.components
{
	import assets.Styles;
	import assets.fonts.Fonts;
	import assets.images.PushButtonBackground;
	
	import com.bit101.components.PushButton;
	
	import flash.display.DisplayObjectContainer;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	
	public class PushButton extends com.bit101.components.PushButton
	{
		
		private var background:PushButtonBackground;
		
		public override function set selected(value:Boolean):void
		{
			super.selected = value;
			this.invalidateDraw();
		}
		
		public function PushButton(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, label:String="", defaultHandler:Function=null)
		{
			super(parent, xpos, ypos, label, defaultHandler);
		}
		
		protected override function init():void
		{
			super.init();
			setSize(84, 26);
			
			mouseChildren = false;
		}
		
		protected override function addChildren():void
		{
			super.addChildren();
			
			background = new PushButtonBackground();
			addChildAt(background, 0);
			_label.textField.defaultTextFormat = Styles.PUSH_BUTTON_LABEL;
			_label.textField.embedFonts = true;
			_label.textField.antiAliasType = AntiAliasType.ADVANCED;
		}
		
		public override function draw():void
		{
			super.draw();
			
			_face.graphics.clear();
			_back.graphics.clear();
			
			background.width = width;
			background.height = height;
			
			_label.y -= 4;
			
			if(selected == false)
			{
				_label.textField.defaultTextFormat = Styles.PUSH_BUTTON_LABEL;
			}
			else
			{
				_label.textField.defaultTextFormat = Styles.PUSH_BUTTON_SELECTED_LABEL;
			}
		}
	}
}
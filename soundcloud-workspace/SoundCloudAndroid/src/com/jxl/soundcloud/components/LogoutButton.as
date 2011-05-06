package com.jxl.soundcloud.components
{
	import assets.fonts.Fonts;
	import assets.images.LogoutButtonBackground;
	
	import com.bit101.components.Component;
	import com.bit101.components.PushButton;
	
	import flash.display.DisplayObjectContainer;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFormat;
	
	public class LogoutButton extends PushButton
	{
		private var logoutBackground:LogoutButtonBackground;
		
		public function LogoutButton(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		protected override function init():void
		{
			super.init();
			setSize(81, 22);
		}
		
		protected override function addChildren():void
		{
			super.addChildren();
			
			logoutBackground = new LogoutButtonBackground();
			addChildAt(logoutBackground, 0);
			
			var tf:TextFormat		= _label.textField.defaultTextFormat;
			tf.font = Fonts.HERCULANUM;
			tf.color = 0xFFFFFF;
			tf.size = 14;
			_label.textField.defaultTextFormat = tf;
			_label.textField.embedFonts = true;
		}
		
		public override function draw():void
		{
			super.draw();
			
			_face.graphics.clear();
			_back.graphics.clear();
			
			//logoutBackground.width = width;
			//logoutBackground.height = height;
			
			_label.y += 2;
			_label.filters = [new DropShadowFilter(3, 45, 0, 1, 5, 5, 2)];
		}
	}
}
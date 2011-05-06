package com.jxl.soundcloud.components
{
	import assets.Styles;
	
	import com.bit101.components.PushButton;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	
	public class LinkButton extends PushButton
	{
		public function LinkButton(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, label:String="", defaultHandler:Function=null)
		{
			super(parent, xpos, ypos, label, defaultHandler);
		}
		
		protected override function init():void
		{
			super.init();
			
			setSize(46, 46);
		}
		
		protected override function addChildren():void
		{
			super.addChildren();
			
			_label.textField.defaultTextFormat = Styles.LINK_BUTTON_TEXT;
			_label.textField.embedFonts = true;
			_label.textField.antiAliasType = AntiAliasType.ADVANCED;
		}
		
		public override function draw():void
		{
			super.draw();
			
			_face.graphics.clear();
			_back.graphics.clear();
			
			_label.y -= 4;
			_label.width = _label.textField.textWidth + 4;
			_label.height = _label.textField.textHeight + 4;

		}
		
		private function onRollOver(event:MouseEvent):void
		{
			
		}
		
		private function onRollOut(event:MouseEvent):void
		{
			
		}
		
		
	}
}
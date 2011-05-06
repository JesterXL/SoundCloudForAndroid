package com.jxl.soundcloud.components
{
	
	import assets.Styles;
	import assets.images.InputTextBackground;
	
	import com.bit101.components.InputText;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class InputText extends com.bit101.components.InputText
	{
		private var background:InputTextBackground;
		private var clickField:TextField;
        private var debug:Shape;
		
		public function InputText(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, text:String="", defaultHandler:Function=null)
		{
			super(parent, xpos, ypos, text, defaultHandler);

			setSize(364, 44);
		}

		protected override function addChildren():void
		{
			super.addChildren();
			
			background = new InputTextBackground();
			addChildAt(background, 0);

			textField.defaultTextFormat = Styles.FORM_INPUT;
			textField.embedFonts = true;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			
			clickField = new TextField();
			addChild(clickField);
			clickField.addEventListener(Event.CHANGE, onClickFieldChange);
			clickField.addEventListener(Event.CLEAR, onClickFieldClear);
			clickField.addEventListener(Event.CUT, onClickFieldCutOrPaste);
			clickField.addEventListener(Event.PASTE, onClickFieldCutOrPaste);
			clickField.addEventListener(TextEvent.TEXT_INPUT, onClickFieldChange);
			clickField.alpha = 0;
		}
		
		public override function draw():void
		{
			super.draw();
			
			_back.graphics.clear();

			background.width =  width;
			background.height = height;
			
            textField.width = width;
			textField.height = height;
			
			textField.border = true;
			textField.borderColor = 0xFF0000;
		}
		
		private function onClickFieldChange(event:Event):void
		{
			_text = clickField.text;
		}
		
		private function onClickFieldClear(event:Event):void
		{
			_text = "";
		}
		
		private function onClickFieldCutOrPaste(event:Event):void
		{
			_text = clickField.text;
		}
	}
}
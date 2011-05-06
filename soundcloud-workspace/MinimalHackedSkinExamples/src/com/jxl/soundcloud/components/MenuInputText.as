package com.jxl.soundcloud.components
{
    import assets.Styles;
    
    import com.bit101.components.InputText;
    import com.bit101.components.Label;
    import com.jxl.soundcloud.events.InputTextEvent;
    
    import flash.debugger.enterDebugger;
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.events.TextEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.ui.Keyboard;
	
	[Event(name="enterPressed", type="com.jxl.soundcloud.events.InputTextEvent")]
	public class MenuInputText extends InputText
	{
		
		[Embed(source="/assets/images/input-text-background.png", scaleGridLeft="12", scaleGridTop="12", scaleGridRight="277", scaleGridBottom="20")]
		private var TextInputBackgroundImage:Class;
		
		protected var textInputBackground:Sprite;
		protected var promptLabel:TextField;
		private var _prompt:String = "";
		private var promptDirty:Boolean = true;
		
		public function get prompt():String { return _prompt; }
		public function set prompt(value:String):void
		{
			_prompt = value;
			promptDirty = true;
			invalidateProperties();
            invalidateDraw();
		}

		public function MenuInputText(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, text:String="", defaultHandler:Function=null)
		{
			super(parent, xpos, ypos, text, defaultHandler);
		}


        override protected function init():void
		{
			super.init();
			setSize(364, 60);
		}

		protected override function addChildren():void
		{
			super.addChildren();
			
			
			textInputBackground = new TextInputBackgroundImage() as Sprite;
			addChildAt(textInputBackground, 0);
			
			promptLabel = new TextField();
			addChild(promptLabel);
            promptLabel.autoSize = TextFieldAutoSize.LEFT;
			promptLabel.defaultTextFormat =  Styles.FORM_PROMPT;
			promptLabel.embedFonts = false;
            promptLabel.selectable = false;
            promptLabel.multiline = false;
            promptLabel.wordWrap = false;
            promptLabel.mouseEnabled = false;
            promptLabel.tabEnabled = false;
			

            textField.defaultTextFormat = Styles.FORM_INPUT;
			textField.embedFonts = false;
			
			this.textField.addEventListener(FocusEvent.FOCUS_IN, onTextFieldFocusIn);
			this.textField.addEventListener(FocusEvent.FOCUS_OUT, onTextFieldFocusOut);
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(promptDirty)
			{
				promptDirty = false;
				promptLabel.text = _prompt;
			}


		}
		
		public override function draw():void
		{
            super.draw();
			_back.graphics.clear();
			
			textInputBackground.width = width;
            textInputBackground.height = height;

            promptLabel.x = 5;
            promptLabel.y = (height / 2) - ((promptLabel.textHeight + 4) / 2) + 2;


			textField.y = (height / 2) - ((textField.textHeight + 4) / 2) + 2;
	
		}
		
		protected function onTextFieldFocusIn(event:FocusEvent):void
		{
			promptLabel.visible = false;
			_tf.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		protected function onTextFieldFocusOut(event:FocusEvent):void
		{
			if(text.length < 1)
				promptLabel.visible = true;
			
			_tf.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.ENTER:
					dispatchEvent(new InputTextEvent(InputTextEvent.ENTER_PRESSED));
					break;
			}
		}
	}
}
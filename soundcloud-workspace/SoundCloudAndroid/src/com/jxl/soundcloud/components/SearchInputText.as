package com.jxl.soundcloud.components
{
    import assets.Styles;

    import assets.images.CloseButtonImage;

    import com.bit101.components.Component;
    import com.jxl.soundcloud.components.MenuInputText;
	import com.jxl.soundcloud.events.SearchInputTextEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
    import flash.html.__HTMLScriptArray;
    import flash.text.TextFormat;
    import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import mx.core.ClassFactory;



    [Event(name="search", type="com.jxl.soundcloud.events.SearchInputTextEvent")]
	public class SearchInputText extends MenuInputText
	{

        private static const STATE_MAIN:String = "main_state";
        private static const STATE_SEARCHING:String = "searching_state";

        private var clearButton:CloseButton;
		
		public function SearchInputText(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, text:String="", defaultHandler:Function=null)
		{
			super(parent, xpos, ypos, text, defaultHandler);
		}
		
		protected override function init():void
		{
			super.init();
            setSize(364, 60);
            currentState = STATE_MAIN;
            this.mouseChildren = true;
		}

        protected override function addChildren():void
        {
            super.addChildren();

            prompt = "Search";
        }

        public override function draw():void

        {
            super.draw();

            if(currentState == STATE_MAIN)
            {
                _tf.width = width;
            }
            else if(currentState == STATE_SEARCHING)
            {
                clearButton.x = (width - (clearButton.width + 4));
                clearButton.y = (height  / 2) - (clearButton.height / 2) + 2;
                _tf.width = width - (clearButton.width + 10);
            }
			
			_tf.height = height;
        }


        protected override function onEnterState(state:String):void
		{
			switch(state)
			{
				case STATE_MAIN:
					invalidateDraw();
					break;

				case STATE_SEARCHING:
					if(clearButton == null)
					{
						clearButton = new CloseButton();
                        clearButton.addEventListener(MouseEvent.CLICK, onCancelSearch);
					}
					addChild(clearButton);
                    invalidateDraw();
					break;
			}
		}

		protected override function onExitState(oldState:String):void
		{
			switch(oldState)
			{
				case STATE_SEARCHING:
					if(clearButton)
					{
						removeChild(clearButton);
					}
					break;

			}
		}

        private function onCancelSearch(event:MouseEvent):void
        {
            text = "";
            currentState = STATE_MAIN;
        }

        protected override function onTextFieldFocusIn(event:FocusEvent):void
        {
            super.onTextFieldFocusIn(event);

            if(currentState != STATE_SEARCHING)
                currentState = STATE_SEARCHING;
        }

        protected override function onTextFieldFocusOut(event:FocusEvent):void
        {
            super.onTextFieldFocusOut(event);

            if(text.length < 1)
                currentState = STATE_MAIN;
        }

	}
}
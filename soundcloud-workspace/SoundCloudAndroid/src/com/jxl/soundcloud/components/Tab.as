package com.jxl.soundcloud.components
{
	import assets.Styles;
    import assets.images.TabSelectedUpImage;
    import assets.images.TabUpImage;
	
	import com.bit101.components.PushButton;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;

    public class Tab extends PushButton
	{
		private var tabUpImage:TabUpImage;
        private var tabSelectedUpImage:TabSelectedUpImage;

        private var textFieldLabel:TextField;

		public function Tab(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, label:String="", defaultHandler:Function=null)
		{
			super(parent, xpos, ypos, label, defaultHandler);
			
			width		= 144;
			height		= 56;
		}

        public override function set selected(value:Boolean):void
        {
            super.selected = value;
            invalidateDraw();
        }
		
		protected override function addChildren():void
		{
			super.addChildren();

            textFieldLabel = new TextField();
			addChild(textFieldLabel);
			textFieldLabel.defaultTextFormat = Styles.TAB_TEXT_SELECTED;

			textFieldLabel.embedFonts = true;
			textFieldLabel.antiAliasType = AntiAliasType.ADVANCED;
            textFieldLabel.autoSize = TextFieldAutoSize.LEFT;
            textFieldLabel.selectable = false;
            textFieldLabel.mouseEnabled = false;
            textFieldLabel.tabEnabled = false;
            textFieldLabel.multiline = false;
            textFieldLabel.wordWrap = false;
            textFieldLabel.condenseWhite = true;
			
			tabUpImage = new TabUpImage();
			addChild(tabUpImage);
			setChildIndex(tabUpImage, 0);

            tabSelectedUpImage = new TabSelectedUpImage();

            this.textField.visible = false;
		}
		
		public override function draw():void
		{
			super.draw();
			
			_face.graphics.clear();
			_back.graphics.clear();
			
			tabUpImage.width = width;
			tabUpImage.height = height;

            tabSelectedUpImage.width = width;
            tabSelectedUpImage.height = height;

            textFieldLabel.text = _labelText;
            textFieldLabel.x = (width / 2) - ((textFieldLabel.textWidth + 4) / 2);
            textFieldLabel.y = (height / 2) - ((textFieldLabel.textHeight + 4) / 2);

            if(selected == false)
            {
                if(contains(tabSelectedUpImage)) removeChild(tabSelectedUpImage)
                if(contains(tabUpImage) == false) addChildAt(tabUpImage, 0);
            }
            else
            {
                if(contains(tabUpImage)) removeChild(tabUpImage)
                if(contains(tabSelectedUpImage) == false) addChildAt(tabSelectedUpImage, 0);
            }




		}
	}
}
package com.jxl.debug
{
	
	import mx.controls.Label;
	import mx.controls.listClasses.ListItemRenderer;
	import mx.core.FontAsset;
	
	public class DebugMaxItemRenderer extends ListItemRenderer
	{
		private static const MARGIN:Number = 4;
		
		private var _data:Object;
		private var dataDirty:Boolean = false;
		
		private var headerLabel:Label;
		
		[Embed(source="/assets/flash/Fonts.swf", symbol="Pixel")] 
        private static var PixelFont:Class;
		
		public override function set data(value:Object):void
		{
			super.data = value;
			_data = value;
			dataDirty = true;
			invalidateProperties();
		}
		
		public function DebugMaxItemRenderer()
		{
			super();
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			headerLabel = new Label();
			addChild(headerLabel);
			headerLabel.setActualSize(40, 20);
			headerLabel.setStyle("fontFamily", "04b03");
			headerLabel.setStyle("fontSize", 8);
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(dataDirty)
			{
				dataDirty = false;
				if(_data)
				{
					var message:Message = _data as Message;
					switch(message.type)
					{
						case MessageType.LOG:
							headerLabel.setStyle("color", Colors.LOG);
							break;
						
						case MessageType.DEBUG:
							headerLabel.setStyle("color", Colors.DEBUG);
							break;
						
						case MessageType.INFO:
							headerLabel.setStyle("color", Colors.INFO);
							break;
						
						case MessageType.WARN:
							headerLabel.setStyle("color", Colors.WARN);
							break;
						
						case MessageType.ERROR:
							headerLabel.setStyle("color", Colors.ERROR);
							break;
						
						case MessageType.FATAL:
							headerLabel.setStyle("color", Colors.FATAL);
							break;
					}
					headerLabel.text = DebugMax.debug_mizznax::NAMES[message.type].toUpperCase();
				}
				else
				{
					headerLabel.text = "";
				}
			}
		}
		
		
		protected override function measure():void
	    {
	        super.measure();
	
	        var w:Number = 0;
	        var h:Number = 0;
	
	        if (icon)
	            w = icon.measuredWidth;
	
	        // Guarantee that label width isn't zero
	        // because it messes up ability to measure.
	        if (label.width < 4 || label.height < 4)
	        {
	            label.width = 4;
	            label.height = 16;
	        }
	        
	        if(headerLabel.width < 4 || headerLabel.height < 4)
	        {
	        	headerLabel.width = 4;
	        	headerLabel.height = 16;
	        }
	
	        if (isNaN(explicitWidth))
	        {
	            w += label.getExplicitOrMeasuredWidth();
	            w += headerLabel.getExplicitOrMeasuredWidth();
	            measuredWidth = w;
	            h += label.getExplicitOrMeasuredHeight();
	            h += headerLabel.getExplicitOrMeasuredHeight();
	        }
	        else
	        {
	            measuredWidth = explicitWidth;
	            label.setActualSize(Math.max(explicitWidth - w - headerLabel.width, 4), label.height);
	            measuredHeight = Math.max(label.getExplicitOrMeasuredHeight(), headerLabel.getExplicitOrMeasuredHeight());
	            if (icon && icon.measuredHeight > measuredHeight)
	                measuredHeight = icon.measuredHeight;
	        }
	    }
	    
	    protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	    {
	    	super.updateDisplayList(unscaledWidth, unscaledHeight);
	    	
	    	label.x = headerLabel.x + headerLabel.width + MARGIN;
      		label.setActualSize(unscaledWidth - label.x, measuredHeight);
	    }
		
	}
}
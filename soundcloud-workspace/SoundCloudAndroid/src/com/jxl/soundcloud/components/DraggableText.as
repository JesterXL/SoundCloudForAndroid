package com.jxl.soundcloud.components
{
	import assets.Styles;
	
	import com.bit101.components.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	
	public class DraggableText extends Component
	{
		private var _text:String = "";
		private var textDirty:Boolean = false;

		private var lastY:Number = 0; // last touch position
		private var firstY:Number = 0; // first touch position
		private var listY:Number = 0; // initial list position on touch 
		private var diffY:Number = 0;
		private var inertiaY:Number = 0;
		private var minY:Number = 0;
		private var maxY:Number = 0;
		private var totalY:Number;
		private var scrollRatio:Number = 40; // how many pixels constitutes a touch
		private var isTouching:Boolean = false;
		
		private var listWidth:Number;
		private var listHeight:Number;
		private var scrollListHeight:Number;
		private var scrollAreaHeight:Number;
		
		private var field:TextField;
		private var listTicker:Sprite;
		private var listContent:Sprite;
		private var scrollBar:Shape;
		
		public function get text():String { return _text; }
		public function set text(value:String):void
		{
			if(_text !== value)
			{
				_text = value;
				textDirty = true;
				invalidateProperties();
			}
		}
		
		public function DraggableText(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		public override function setSize(w:Number, h:Number):void
		{
			super.setSize(w, h);
			listWidth = w;
			listHeight = h;
			scrollRect = new Rectangle(0, 0, w, h);
		}
		
		protected override function init():void
		{
			super.init();
			
			setSize(480, 400);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown );
			
			listTicker = new Sprite();
			listTicker.addEventListener(Event.ENTER_FRAME, onListTicker);
		}
		
		protected override function addChildren():void
		{
			super.addChildren();
			
			listContent = new Sprite();
			addChild(listContent);
			listContent.mouseChildren = true;
			listContent.mouseEnabled = true;
			
			
			field 						= new TextField();
			field.wordWrap 				= field.multiline = true;
			field.selectable 			= field.mouseEnabled = field.tabEnabled = false;
			field.defaultTextFormat 	= Styles.CHANGE_LOG;
			field.embedFonts 			= false;
			//field.antiAliasType 		= AntiAliasType.ADVANCED;
			field.width					= width;
			field.condenseWhite = false;
			field.autoSize 				= "left";
			
			listContent.addChild(field);
			
			updateScrollBar();
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(textDirty)
			{
				textDirty 			= false;
				field.text 			= _text;
				field.visible 		= false;
				invalidateDraw();
			}
		}
		
		public override function draw():void
		{
			super.draw();
			
			field.width					= width;
			
			var g:Graphics = graphics;
			g.clear();
			g.lineStyle(0, 0x333333);
			g.beginFill(0xFFFFFF);
			g.drawRect(0, 0, width - 1, height - 1);
			//g.lineStyle(0, 0xFF0000);
			//g.drawRect(field.x, field.y, field.textWidth, field.textHeight);
			g.endFill();
			
			scrollListHeight 	= field.textHeight + 4;
			scrollAreaHeight 	= listHeight;
			field.visible		= true;
			
			updateScrollBar();
		}
		
		private function updateScrollBar():void
		{
			if(scrollBar == null)
			{
				scrollBar = new Shape();
				addChild(scrollBar);
				scrollBar.cacheAsBitmap = true;
			}
			scrollBar.x = listWidth - 5;
			scrollBar.graphics.clear();
			
			if(scrollAreaHeight < scrollListHeight)
			{
				scrollBar.graphics.beginFill(0x505050);
				scrollBar.graphics.lineStyle(1, 0x5C5C5C, 1, true);
				scrollBar.graphics.drawRoundRect(0, 0, 4, (scrollAreaHeight/scrollListHeight*scrollAreaHeight), 6, 6);
				scrollBar.graphics.endFill();
			}
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			inertiaY 	= 0;
			firstY 		= mouseY;
			listY 		= listContent.y;
			minY 		= Math.min(-listContent.y, -scrollListHeight + listHeight - listContent.y);
			maxY 		= -listContent.y;
			
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			totalY = mouseY - firstY;
			
			if(Math.abs(totalY) > scrollRatio) isTouching = true;
			
			if(isTouching)
			{
				
				diffY = mouseY - lastY;	
				lastY = mouseY;
				
				if(totalY < minY)
					totalY = minY - Math.sqrt(minY - totalY);
				
				if(totalY > maxY)
					totalY = maxY + Math.sqrt(totalY - maxY);
				
				listContent.y = listY + totalY;
				
				//onTapDisabled();
			}
			
			event.updateAfterEvent();
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown );
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			if(isTouching) {
				isTouching = false;
				inertiaY = diffY;
			}
		}
		
		private function onListTicker(e:Event):void
		{
			// scroll the list on mouse up
			if(!isTouching) {
				
				if(listContent.y > 0) {
					inertiaY = 0;
					listContent.y *= 0.3;
					
					if(listContent.y < 1) {
						listContent.y = 0;
					}
				} else if(scrollListHeight >= listHeight && listContent.y < listHeight - scrollListHeight) {
					inertiaY = 0;
					
					var diff:Number = (listHeight - scrollListHeight) - listContent.y;
					
					if(diff > 1)
						diff *= 0.1;
					
					listContent.y += diff;
				} else if(scrollListHeight < listHeight && listContent.y < 0) {
					inertiaY = 0;
					listContent.y *= 0.8;
					
					if(listContent.y > -1) {
						listContent.y = 0;
					}
				}
				
				if( Math.abs(inertiaY) > 1) {
					listContent.y += inertiaY;
					inertiaY *= 0.9;
				} else {
					inertiaY = 0;
				}
				
				if(inertiaY != 0) {
					//if(scrollBar.alpha < 1 )
					//scrollBar.alpha = Math.min(1, scrollBar.alpha + 0.1);
					scrollBar.y = listHeight * Math.min( 1, (-listContent.y/scrollListHeight) );
				} else {
					//if(scrollBar.alpha > 0 )
					//scrollBar.alpha = Math.max(0, scrollBar.alpha - 0.1);
				}
				
				if(inertiaY == 0)
				{
					scrollBar.visible = false
				}
				else
				{
					scrollBar.visible = true;
				}
				
				
			} else {
				//if(scrollBar.alpha < 1)
				//scrollBar.alpha = Math.min(1, scrollBar.alpha + 0.1);
				
				scrollBar.y = listHeight * Math.min(1, (-listContent.y/scrollListHeight) );
				scrollBar.visible = true;
			}
		}
		
	}
}
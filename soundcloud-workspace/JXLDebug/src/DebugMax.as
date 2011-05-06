package
{
	import com.jxl.debug.Colors;
	import com.jxl.debug.DebugMaxItemRenderer;
	import com.jxl.debug.Message;
	import com.jxl.debug.MessageType;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.SharedObject;
	import flash.system.System;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Button;
	import mx.controls.CheckBox;
	import mx.controls.List;
	import mx.controls.TabBar;
	import mx.core.ClassFactory;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.ItemClickEvent;
	import mx.managers.PopUpManager;
	// import com.jxl.debug.debug_mizznax;
	import com.jxl.debug.debug_mizznax;
	
	use namespace debug_mizznax;

	public class DebugMax extends UIComponent
	{
		
		public function DebugMax():void
		{
			super();
			
			var backlogSource:Array = backlog.source.concat();
			backlogSource.sortOn("date", Array.NUMERIC);
			messages	= new ArrayCollection(backlogSource);
			messages.addEventListener(CollectionEvent.COLLECTION_CHANGE, onMessagesChanged);
			backlog.removeAll();
			backlog 	= null;
			
			inst 		= this;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		public static function logHeader():void
		{
			if(inst)
			{
				inst.logHeader();
			}
			else
			{
				backlog.addItem(new Message(MessageType.LOG, HEADER_TEXT));
			}
		}
		
		public static function debugHeader():void
		{
			if(inst)
			{
				inst.debugHeader();
			}
			else
			{
				backlog.addItem(new Message(MessageType.DEBUG, HEADER_TEXT));
			}
		}
		
		public static function infoHeader():void
		{
			if(inst)
			{
				inst.infoHeader();
			}
			else
			{
				backlog.addItem(new Message(MessageType.INFO, HEADER_TEXT));
			}
		}
		
		public static function warnHeader():void
		{
			if(inst)
			{
				inst.warnHeader();
			}
			else
			{
				backlog.addItem(new Message(MessageType.WARN, HEADER_TEXT));
			}
		}
		
		public static function errorHeader():void
		{
			if(inst)
			{
				inst.errorHeader();
			}
			else
			{
				backlog.addItem(new Message(MessageType.ERROR, HEADER_TEXT));
			}
		}
		
		public static function fatalHeader():void
		{
			if(inst)
			{
				inst.fatalHeader();
			}
			else
			{
				backlog.addItem(new Message(MessageType.FATAL, HEADER_TEXT));
			}
		}
		
		public static function log(o:*):void
		{
			if(inst)
			{
				inst.log(o);
			}
			else
			{
				backlog.addItem(new Message(MessageType.LOG, o));
			}
		}
		
		public static function debug(o:*):void
		{
			if(inst)
			{
				inst.debug(o);
			}
			else
			{
				backlog.addItem(new Message(MessageType.DEBUG, o));
			}
		}
		
		public static function info(o:*):void
		{
			if(inst)
			{
				inst.info(o);
			}
			else
			{
				backlog.addItem(new Message(MessageType.INFO, o));
			}
		}
		
		public static function warn(o:*):void
		{
			if(inst)
			{
				inst.warn(o);
			}
			else
			{
				backlog.addItem(new Message(MessageType.WARN, o));
			}
		}
		
		public static function error(o:*):void
		{
			if(inst)
			{
				inst.error(o);
			}
			else
			{
				backlog.addItem(new Message(MessageType.ERROR, o));
			}
		}
		
		public static function fatal(o:*):void
		{
			if(inst)
			{
				inst.fatal(o);
			}
			else
			{
				backlog.addItem(new Message(MessageType.FATAL, o));
			}
		}
		
		public function logHeader():void
		{
			messages.addItem(new Message(MessageType.LOG, HEADER_TEXT));
		}
		
		public function log(o:*):void
		{
			trace(o);
			messages.addItem(new Message(MessageType.LOG, o));
		}
		
		public function debugHeader():void
		{
			messages.addItem(new Message(MessageType.DEBUG, HEADER_TEXT));
		}
		
		public function debug(o:*):void
		{
			trace(o);
			messages.addItem(new Message(MessageType.DEBUG, o));
		}
		
		public function infoHeader():void
		{
			messages.addItem(new Message(MessageType.INFO, HEADER_TEXT));
		}
		
		public function info(o:*):void
		{
			trace(o);
			messages.addItem(new Message(MessageType.INFO, o));
		}
		
		public function warnHeader():void
		{
			messages.addItem(new Message(MessageType.WARN, HEADER_TEXT));
		}
		
		public function warn(o:*):void
		{
			trace(o);
			messages.addItem(new Message(MessageType.WARN, o));
		}
		
		public function errorHeader():void
		{
			messages.addItem(new Message(MessageType.ERROR, HEADER_TEXT));
		}
		
		public function error(o:*):void
		{
			trace(o);
			messages.addItem(new Message(MessageType.ERROR, o));
		}
		
		public function fatalHeader():void
		{
			messages.addItem(new Message(MessageType.FATAL, HEADER_TEXT));
		}
		
		public function fatal(o:*):void
		{
			trace(o);
			messages.addItem(new Message(MessageType.FATAL, o));
		}
		
		public function get autoScroll():Boolean { return _autoScroll; }
		public function set autoScroll(value:Boolean):void
		{
			_autoScroll = value;
			autoScrollDirty = true;
			invalidateProperties();
		}
		
		protected override function measure():void
		{
			measuredMinWidth 		= 120;
	        measuredMinHeight 		= 120;
	        measuredWidth 			= 540;
	        measuredHeight 			= 400;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			background = new Sprite();
			addChild(background);
			background.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			background.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			background.buttonMode = true;
			
			tabs = new TabBar();
			tabs.includeInLayout = false;
			addChild(tabs);
			tabs.dataProvider = [
									NAMES[MessageType.LOG],
								 	NAMES[MessageType.DEBUG], 
								 	NAMES[MessageType.INFO], 
								 	NAMES[MessageType.WARN], 
								 	NAMES[MessageType.ERROR], 
								 	NAMES[MessageType.FATAL]
								 ];
			tabs.addEventListener(ItemClickEvent.ITEM_CLICK, onItemClick);
			tabs.height = 22;
			tabs.setStyle("tabWidth", 70);
			
			list = new List();
			list.includeInLayout = false;
			addChild(list);
			list.dataProvider = messages;
			list.variableRowHeight = true;
			list.wordWrap = true;
			list.labelField = "content";
			list.allowMultipleSelection = true;
			list.itemRenderer = new ClassFactory(DebugMaxItemRenderer);
			list.setStyle("borderStyle", "solid");
			list.setStyle("borderThickness", 4);
			
			clearButton = new Button();
			clearButton.includeInLayout = false;
			addChild(clearButton);
			clearButton.addEventListener(MouseEvent.CLICK, onClear);
			clearButton.height = 22;
			clearButton.label = "Clear";
			
			copyButton = new Button();
			copyButton.includeInLayout = false;
			addChild(copyButton);
			copyButton.addEventListener(MouseEvent.CLICK, onCopy);
			copyButton.height = 22;
			copyButton.width = 120;
			copyButton.label = "Copy to Clipboard";
			
			scrollCheckBox = new CheckBox();
			scrollCheckBox.includeInLayout = false;
			addChild(scrollCheckBox);
			scrollCheckBox.label = "auto-scroll";
			scrollCheckBox.selected = autoScroll;
			scrollCheckBox.addEventListener(Event.CHANGE, onToggleAutoScroll);
			scrollCheckBox.setActualSize(100, 22);
			
			closeButton = new Button();
			closeButton.includeInLayout = false;
			addChild(closeButton);
			closeButton.addEventListener(MouseEvent.CLICK, onClose);
			closeButton.setActualSize(16, 16);
			
			var drop:DropShadowFilter = new DropShadowFilter(3, 45, 0x333333, .7, 4, 4, 1, 1, false, false, false);
			filters = [drop];
			
			callLater(scrollIt);
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(autoScrollDirty)
			{
				autoScrollDirty = false;
				scrollCheckBox.selected = _autoScroll;
			}
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			trace("w: " + unscaledWidth + ", h: " + unscaledHeight + ", pw: " + percentWidth + ", ph: " + percentHeight);
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			background.graphics.clear();
			background.graphics.beginFill(0x333333, .8);
			background.graphics.drawRoundRect(0, 0, width, height, 6, 6);
			background.graphics.endFill();
			
			closeButton.move(width - (closeButton.width + MARGIN), 2);
			tabs.move(MARGIN, MARGIN);
			tabs.setActualSize(width - (MARGIN * 2), tabs.height);
			scrollCheckBox.move(width - (scrollCheckBox.width + MARGIN), height - (scrollCheckBox.height + MARGIN));
			clearButton.move(MARGIN, height - (clearButton.height + MARGIN));
			clearButton.setActualSize(width - scrollCheckBox.width - copyButton.width - (MARGIN * 5), clearButton.height);
			copyButton.move(clearButton.x + clearButton.width + MARGIN, clearButton.y);
			list.move(tabs.x, tabs.y + tabs.height);
			list.setActualSize(width - (MARGIN * 2), height - clearButton.height - (MARGIN * 2) - list.y);
		}
		
		
		
		private function onMessagesChanged(event:CollectionEvent):void
		{
			scrollIt();
			destroyScrollTimer();
			if(scrollTimer == null)
			{
				scrollTimer = new Timer(500);
				scrollTimer.addEventListener(TimerEvent.TIMER, onTick, false, 0, true);
				scrollTimer.start();
			}
		}
		
		private function destroyScrollTimer():void
		{
			if(scrollTimer)
			{
				scrollTimer.stop();
				scrollTimer.removeEventListener(TimerEvent.TIMER, onTick);
				scrollTimer = null;
			}
		}
		
		private function onTick(event:TimerEvent):void
		{
			scrollIt();
			if(_autoScroll == false) 	destroyScrollTimer();
			if(list == null) 			destroyScrollTimer();
			if(list.verticalScrollPosition == list.maxVerticalScrollPosition) destroyScrollTimer();
		}
		
		private function scrollIt():void
		{
			if(_autoScroll)
			{
				if(list)
				{
					list.verticalScrollPosition = list.maxVerticalScrollPosition;
				}
			}	
		}
		
		private function onClear(event:MouseEvent):void
		{
			messages.removeAll();
		}
		
		private function onCopy(event:MouseEvent):void
		{
			var str:String = "";
			var len:int = messages.length;
			for(var i:uint = 0; i < len; i++)
			{
				var message:Message = messages[i] as Message;
				str += NAMES[message.type] + "  " + message.content + "\n";
			}
			try
			{
				System.setClipboard(str);
			}
			catch(err:Error)
			{
				DebugMax.error("DebugMax::onCopy, Failed to to copy to clipboard.");
				DebugMax.error(err.toString()); 
			}
		}
		
		private function onToggleAutoScroll(event:Event):void
		{
			_autoScroll = scrollCheckBox.selected;
		}
		
		private function onClose(event:MouseEvent):void
		{
			messages.removeAll();
			PopUpManager.removePopUp(this);
			inst = null;
			var messagesSource:Array = messages.source.concat();
			backlog = new ArrayCollection(messagesSource);
			messages.removeAll();
			messages = null;
		}
		
		private function onItemClick(event:ItemClickEvent):void
		{
			switch(event.item)
			{
				case NAMES[MessageType.LOG]:
					filterMessages(MessageType.LOG);
					list.setStyle("borderColor", Colors.LOG);
					break;
				
				case NAMES[MessageType.DEBUG]:
					filterMessages(MessageType.DEBUG);
					list.setStyle("borderColor", Colors.DEBUG);
					break;
				
				case NAMES[MessageType.INFO]:
					filterMessages(MessageType.INFO);
					list.setStyle("borderColor", Colors.INFO);
					break;
				
				case NAMES[MessageType.WARN]:
					filterMessages(MessageType.WARN);
					list.setStyle("borderColor", Colors.WARN);
					break;
				
				case NAMES[MessageType.ERROR]:
					filterMessages(MessageType.ERROR);
					list.setStyle("borderColor", Colors.ERROR);
					break;
				
				case NAMES[MessageType.FATAL]:
					filterMessages(MessageType.FATAL);
					list.setStyle("borderColor", Colors.FATAL);
					break;
			}
		}
		
		private function filterMessages(type:uint):void
		{
			switch(type)
			{
				case MessageType.LOG:
					messages.filterFunction = null;
					break;
					
				case MessageType.DEBUG:
					messages.filterFunction = function(message:Message):Boolean
					{
						if(message.type >= MessageType.DEBUG)
						{
							return true;
						}
						return false;
					};
					break;
				
				case MessageType.INFO:
					messages.filterFunction = function(message:Message):Boolean
					{
						if(message.type >= MessageType.INFO)
						{
							return true;
						}
						return false;
					};
					break;
				
				case MessageType.WARN:
					messages.filterFunction = function(message:Message):Boolean
					{
						if(message.type >= MessageType.WARN)
						{
							return true;
						}
						return false;
					};
					break;
				
				case MessageType.ERROR:
					messages.filterFunction = function(message:Message):Boolean
					{
						if(message.type >= MessageType.ERROR)
						{
							return true;
						}
						return false;
					};
					break;
				
				case MessageType.FATAL:
					messages.filterFunction = function(message:Message):Boolean
					{
						if(message.type >= MessageType.FATAL)
						{
							return true;
						}
						return false;
					};
					break;
				
			}
			messages.refresh();
		}
		
		// Dragging Functionality
		private function onAddedToStage(event:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			try
			{
				var so:SharedObject = SharedObject.getLocal("DebugMax_position");
				if(so != null)
				{
					if(so.data.pos != null)
					{
						if(so.data.pos.x != undefined && so.data.pos.y != undefined)
						{
							move(so.data.pos.x, so.data.pos.y);
						}
					}
				}
			}
			catch(err:Error)
			{
			}
		}
		
		private function onRemovedFromStage(event:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			if(dragging == false)
			{
				dragging = true;
				this.startDrag();
				this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			event.updateAfterEvent();
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			if(dragging)
			{
				dragging = false;
				this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				this.stopDrag();
				event.updateAfterEvent();
				
				var so:SharedObject = SharedObject.getLocal("DebugMax_position");
				so.data.pos = {x: x, y: y};
				var r:String = so.flush();
			}
		}
		
		private static const MARGIN:Number = 4;
		debug_mizznax static var NAMES:Dictionary;
		private static var constrctured:Boolean = classConstruct();
		
		private static function classConstruct():Boolean
		{
			NAMES = new Dictionary();
			NAMES[MessageType.LOG] 			= "Log";
			NAMES[MessageType.DEBUG] 		= "Debug";
			NAMES[MessageType.INFO] 		= "Info";
			NAMES[MessageType.WARN] 		= "Warn";
			NAMES[MessageType.ERROR] 		= "Error";
			NAMES[MessageType.FATAL] 		= "Fatal";
			return true;
		}
		
		private static var inst:DebugMax;
		private static var backlog:ArrayCollection				= new ArrayCollection();
		private static const HEADER_TEXT:String					= "---------------------";
				
		private var messages:ArrayCollection;
		private var _autoScroll:Boolean							= true;
		private var autoScrollDirty:Boolean						= false;
		private var dragging:Boolean							= false;
		private var scrollTimer:Timer;
		
		private var tabs:TabBar;
		private var list:List;
		private var clearButton:Button;
		private var scrollCheckBox:CheckBox;
		private var closeButton:Button;
		private var background:Sprite;
		private var copyButton:Button;
		
	}
}
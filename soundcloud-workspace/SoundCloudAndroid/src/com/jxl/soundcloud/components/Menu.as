package com.jxl.soundcloud.components
{
	import assets.Styles;
	import assets.images.MenuBackground;
	import assets.images.MenuButtonChangeLog;
	import assets.images.MenuButtonDisconnect;
	import assets.images.MenuButtonErrors;
	import assets.images.MenuButtonQuit;
	import assets.images.MenuButtonRefresh;
	
	import com.bit101.components.Component;
	import com.jxl.soundcloud.events.MenuEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	
	[Event(name="refresh", type="com.jxl.soundcloud.events.MenuEvent")]
	[Event(name="quit", type="com.jxl.soundcloud.events.MenuEvent")]
	[Event(name="disconnect", type="com.jxl.soundcloud.events.MenuEvent")]
	[Event(name="changeLog", type="com.jxl.soundcloud.events.MenuEvent")]
	[Event(name="showErrors", type="com.jxl.soundcloud.events.MenuEvent")]
	public class Menu extends Component
	{
		
		public function Menu(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		protected override function init():void
		{
			super.init();
			
			setSize(409, 88);
		}
		
		protected override function addChildren():void
		{
			super.addChildren();
			
			addChild(new MenuBackground());
			
			var refreshSprite:Sprite = new Sprite();
			addChild(refreshSprite);
			refreshSprite.addEventListener(MouseEvent.CLICK, onRefresh);
			var refresh:MenuButtonRefresh = new MenuButtonRefresh();
			refreshSprite.addChild(refresh);
			refresh.x = 3;
			refresh.y = 11;
			var refreshTextField:TextField = getLabel();
			refreshSprite.addChild(refreshTextField);
			refreshTextField.text = "Refresh";
			centerLabel(refreshTextField, refresh);
			
			var quitSprite:Sprite = new Sprite();
			addChild(quitSprite);
			quitSprite.addEventListener(MouseEvent.CLICK, onQuit);
			var quit:MenuButtonQuit = new MenuButtonQuit();
			quitSprite.addChild(quit);
			quit.y = refresh.y;
			quit.x = refresh.x + refresh.width - 1;
			var quitTextField:TextField = getLabel();
			quitSprite.addChild(quitTextField);
			quitTextField.text = "Quit";
			centerLabel(quitTextField, quit);
			
			var disconnectSprite:Sprite = new Sprite();
			addChild(disconnectSprite);
			disconnectSprite.addEventListener(MouseEvent.CLICK, onDisconnect);
			var disconnect:MenuButtonDisconnect = new MenuButtonDisconnect();
			disconnectSprite.addChild(disconnect);
			disconnect.y = refresh.y;
			disconnect.x = quit.x + quit.width - 1;
			var disconnectTextField:TextField = getLabel();
			disconnectSprite.addChild(disconnectTextField);
			disconnectTextField.text = "Disconnect";
			centerLabel(disconnectTextField, disconnect);
			
			var changeLogSprite:Sprite = new Sprite();
			addChild(changeLogSprite);
			changeLogSprite.addEventListener(MouseEvent.CLICK, onChangeLog);
			var changeLog:MenuButtonChangeLog = new MenuButtonChangeLog();
			changeLogSprite.addChild(changeLog);
			changeLog.y = refresh.y;
			changeLog.x = disconnect.x + disconnect.width - 1;
			var changeLogTextField:TextField = getLabel();
			changeLogSprite.addChild(changeLogTextField);
			changeLogTextField.text = "Change Log";
			centerLabel(changeLogTextField, changeLog);
			
			var errorSprite:Sprite = new Sprite();
			addChild(errorSprite);
			errorSprite.addEventListener(MouseEvent.CLICK, onShowErrors);
			var errors:MenuButtonErrors = new MenuButtonErrors();
			errorSprite.addChild(errors);
			errors.y = refresh.y;
			errors.x = changeLog.x + changeLog.width - 1;
			var errorsTextField:TextField = getLabel();
			errorSprite.addChild(errorsTextField);
			errorsTextField.text = "Email Errors";
			centerLabel(errorsTextField, errors);
		}
		
		private function getLabel():TextField
		{
			var textField:TextField 		= new TextField();
			textField.multiline 			= textField.wordWrap = textField.selectable = textField.mouseEnabled = textField.tabEnabled = false;
			textField.autoSize 				= "left";
			textField.defaultTextFormat 	= Styles.MENU_TEXT;
			textField.embedFonts 			= true;
			textField.antiAliasType 		= AntiAliasType.ADVANCED;
			return textField;
		}
		
		private function centerLabel(label:TextField, bitmap:Bitmap):void
		{
			label.x = bitmap.x + (bitmap.width / 2) - (label.width / 2);
			label.y = bitmap.height - label.height + 4;
		}
			
		private function onRefresh(event:MouseEvent):void
		{
			dispatchEvent(new MenuEvent(MenuEvent.REFRESH));
		}
		
		private function onQuit(event:MouseEvent):void
		{
			dispatchEvent(new MenuEvent(MenuEvent.QUIT));
		}
		
		private function onDisconnect(event:MouseEvent):void
		{
			dispatchEvent(new MenuEvent(MenuEvent.DISCONNECT));
		}
		
		private function onChangeLog(event:MouseEvent):void
		{
			dispatchEvent(new MenuEvent(MenuEvent.CHANGE_LOG));
		}
		
		private function onShowErrors(event:MouseEvent):void
		{
			dispatchEvent(new MenuEvent(MenuEvent.SHOW_ERRORS));
		}
	}
}
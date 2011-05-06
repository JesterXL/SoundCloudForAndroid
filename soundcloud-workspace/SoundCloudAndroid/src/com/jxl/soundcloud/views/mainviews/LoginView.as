package com.jxl.soundcloud.views.mainviews
{
	
	import assets.Styles;
	import assets.images.ConnectWithSoundCloudButtonUp;
	import assets.images.JXLLogo;
	import assets.images.LoginBackground;
	
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.jxl.soundcloud.Constants;
	import com.jxl.soundcloud.components.Checkbox;
	import com.jxl.soundcloud.components.InputText;
	import com.jxl.soundcloud.components.PushButton;
	import com.jxl.soundcloud.events.LoginEvent;
	
	import flash.display.Graphics;
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	
	[Event(name="login", type="com.jxl.soundcloud.events.LoginEvent")]
	
	
	
	public class LoginView extends Component implements ILoginView
	{
		
		private var titleLabel:Label;
		private var connectButton:ConnectWithSoundCloudButtonUp;
		private var jxlLogo:JXLLogo;
		
		public function LoginView()
		{
			super();
		}
		
		protected override function init():void
		{
			super.init();
			
			setSize(Constants.WIDTH, Constants.HEIGHT);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(event:Event):void
		{
			draw();
		}
		
		protected override function addChildren():void
		{
			titleLabel = new Label();
			addChild(titleLabel);
			titleLabel.text 	= "Click below to sign in or sign up.";
			titleLabel.textField.defaultTextFormat = Styles.LOGIN_TITLE;
			titleLabel.textField.embedFonts = true;
			
			connectButton = new ConnectWithSoundCloudButtonUp();
			addChild(connectButton);
			connectButton.addEventListener(MouseEvent.CLICK, onClick);
			
			jxlLogo = new JXLLogo();
			addChild(jxlLogo);
			jxlLogo.addEventListener(MouseEvent.CLICK, onJXLLogoClick);
		}
		
		public override function draw():void
		{
			super.draw();
			
			titleLabel.move((width / 2) - (titleLabel.width / 2), 142);
			
			connectButton.x = (width / 2) - (connectButton.width / 2);
			connectButton.y = titleLabel.y + titleLabel.height + 16;
			
			jxlLogo.x = width - (jxlLogo.width + 20);
			jxlLogo.y = height - (jxlLogo.height + 20);
		}
		
		private function onClick(event:MouseEvent):void
		{
			dispatchEvent(new LoginEvent(LoginEvent.LOGIN));
		}
		
		private function onJXLLogoClick(event:MouseEvent):void
		{
			try
			{
				navigateToURL(new URLRequest(Constants.JXL_LOGO_URL));
			}
			catch(err:Error){}
		}
		
		
		
	}
}
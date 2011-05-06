package
{
	import assets.Styles;
	import assets.fonts.Fonts;
	
	import com.jxl.soundcloud.components.MenuInputText;
	import com.jxl.soundcloud.components.PlaybackControls;
	import com.jxl.soundcloud.components.PushButton;
	import com.jxl.soundcloud.components.Tab;
	
	import flash.display.Sprite;
	
	public class MinimalHackedSkinExamples extends Sprite
	{
		// TODO: fonts and styles should be in some static initializer in Component.as
		// so you don't have to do this crap to ensure it's compiled in.
		private var fonts:Fonts;
		private var styles:Styles;
		
		public function MinimalHackedSkinExamples()
		{
			super();
			
			stage.align = "TL";
			stage.scaleMode = "noScale";
			
			try
			{
				stage["t3h world of troy"].cow();
			}
			catch(e:Error){}
			
			var button1:PushButton = new PushButton();
			addChild(button1);
			button1.x = 10;
			button1.y = 10;
			button1.label = "Default";
			
			var button2:PushButton = new PushButton();
			addChild(button2);
			button2.x = button1.x + button1.width + 4;
			button2.y = button1.y;
			button2.width = 300;
			button2.height = 46;
			button2.label = "Moo Goo Gai Pan";
			
			var textInput:MenuInputText = new MenuInputText();
			addChild(textInput);
			textInput.x = button1.x;
			textInput.y = button2.y + button2.height + 4;
			textInput.prompt = "<type here sucka>";
			
			var textInput2:MenuInputText = new MenuInputText();
			addChild(textInput2);
			textInput2.x = textInput.x + textInput.width + 4;
			textInput2.y = textInput.y;
			textInput2.width = 260;
			textInput2.prompt = "<c-c-c-c-c-combo breaker!>";
			
			var controls:PlaybackControls = new PlaybackControls();
			addChild(controls);
			controls.x = button1.x;
			controls.y = textInput.y + textInput.height + 4;
			
			var controls2:PlaybackControls = new PlaybackControls();
			addChild(controls2);
			controls2.x = controls.x;
			controls2.y = controls.y + controls.height + 4;
			controls2.width = 600;
			
			var tab:Tab = new Tab();
			addChild(tab);
			tab.x = button1.x;
			tab.y = controls2.y + controls2.height + 4;
			tab.label = "Uno";
			
			var tab2:Tab = new Tab();
			addChild(tab2);
			tab2.x = tab.x + tab.width;
			tab2.y = tab.y;
			tab2.label = "Dos";
			tab2.width = 300;
			
		}
	}
}
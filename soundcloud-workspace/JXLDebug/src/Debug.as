package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class Debug extends Sprite
	{
		private var debugTextField:TextField;
		
		private static var _inst:Debug;
		private static const HEADER:String = "--------------------";
		private static var backLog:Array = [];
		public static var errorsString:String = "";
		
		public function Debug()
		{
			super();
			
			_inst = this;
			
			debugTextField 				= new TextField();
			addChild(debugTextField);
			debugTextField.multiline 	= true;
			debugTextField.wordWrap 	= true;
			debugTextField.width		= 320;
			debugTextField.height		= 200;
			debugTextField.border 		= true;
			debugTextField.borderColor	= 0x666666;
            debugTextField.selectable   = true;
			debugTextField.background 	= true;
			debugTextField.backgroundColor	= 0xFFFFFF;
			
			var len:int = backLog.length;
			for(var index:uint = 0; index < len; index++)
			{
				log(backLog[index]);
			}
			backLog = null;
			
			//this.mouseChildren = false;
			//this.mouseEnabled = false;
			this.tabChildren = false;
			this.tabEnabled = false;
		}
		
		public function log(o:*):void
		{
			if(CONFIG::DEBUGGING == false) return;
			trace(o);
			debugTextField.appendText(o + "\n");
			debugTextField.scrollV = debugTextField.maxScrollV;
		}
		
		public function logHeader():void
		{
			if(CONFIG::DEBUGGING == false) return;
			trace(HEADER);
			log(HEADER + "\n");
		}
		
		public function setSize(width:Number, height:Number):void
		{
			debugTextField.width = width;
			debugTextField.height = height;
		}
		
		public static function log(o:*):void
		{
			if(CONFIG::DEBUGGING == false) return;
			if(_inst)
			{
				_inst.log(o);
			}
			else
			{
				backLog.push(o);
			}
		}
		
		public static function logHeader():void	
		{
			if(CONFIG::DEBUGGING == false) return;
			if(_inst)
			{
				_inst.logHeader();
			}
			else
			{
				backLog.push(HEADER);
			}
		}
		
		public static function error(o:*):void
		{
			errorsString += o + "\n";
		}
		
		
	}
}
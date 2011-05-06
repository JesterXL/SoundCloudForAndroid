package com.jxl.debug
{
	public class Message
	{
		public var type:uint;
		public var content:*;
		public var date:Date;
		
		public function Message(type:uint, content:*):void
		{
			date				= new Date();
			this.type			= type;
			this.content		= content;
			
		}
		
	}
}
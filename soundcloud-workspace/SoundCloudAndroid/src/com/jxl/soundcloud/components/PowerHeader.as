package com.jxl.soundcloud.components
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.jxl.dnd.constants.PowerType;
	import com.jxl.dnd.powers.Power;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	
	public class PowerHeader extends Component
	{
		
		
		private var nameLabel:Label;
		private var typeLabel:Label;
		private var background:Shape;
		
		private var backgroundColor:uint = 0xCCCCCC;
		private var _power:Power;
		private var powerDirty:Boolean = false;
		
		public function get power():Power { return _power; }
		public function set power(value:Power):void
		{
			_power = value;
			powerDirty = true;
			invalidateProperties();
		}
		
		public function PowerHeader(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			
			width = 400;
			height = 20;
		}
		
		protected override function addChildren():void
		{
			super.addChildren();
			
			background = new Shape();
			addChild(background);
			
			nameLabel = new Label();
			addChild(nameLabel);
			nameLabel.textField.defaultTextFormat.size = 14;
			nameLabel.textField.defaultTextFormat.color = 0xFFFFFF;
			nameLabel.textField.defaultTextFormat.bold = true;
			
			typeLabel = new Label();
			addChild(typeLabel);
			typeLabel.textField.defaultTextFormat.size = 11;
			typeLabel.textField.defaultTextFormat.color = 0xFFFFFF;
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(powerDirty)
			{
				powerDirty = false;
				if(_power == null)
				{
					nameLabel.text = "";
					typeLabel.text = "";
					backgroundColor = 0xCCCCCC;
					return;
				}
				nameLabel.text = power.name;
				if(isNaN(power.level) || power.level > 0)
				{
					typeLabel.text = power.typeDescription + " " + power.level;
				}
				else
				{
					typeLabel.text = power.typeDescription;
				}
				
				
				switch(power.type)
				{
					case PowerType.AT_WILL:
					case PowerType.CLASS:
					case PowerType.DEFAULT:
						backgroundColor = 0x006600;
						break;
					
					case PowerType.DAILY:
						backgroundColor = 0x333333;
						break;
					
					case PowerType.RACIAL_ATTACK:
					case PowerType.RACIAL_EFFECT:
					case PowerType.UTILITY:
					case PowerType.ENCOUNTER:
						backgroundColor = 0x660000;
						break;
				}
				callNextFrame(invalidateDraw);
			}
		}
		
		public override function draw():void
		{
			super.draw();
			
			background.graphics.clear();
			background.graphics.beginFill(backgroundColor);
			background.graphics.drawRect(0, 0, width, height);
			background.graphics.endFill();
			
			const TEXT_OFFSET:Number = 8;
			nameLabel.x = 4;
			nameLabel.setSize(nameLabel.textField.textWidth + TEXT_OFFSET, nameLabel.textField.textHeight + TEXT_OFFSET);
			
			typeLabel.setSize(typeLabel.textField.textWidth + TEXT_OFFSET, typeLabel.textField.textHeight + TEXT_OFFSET);
			typeLabel.x = width - (typeLabel.textField.textWidth + TEXT_OFFSET);
		}
	}
}
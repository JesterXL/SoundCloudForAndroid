package com.jxl.soundcloud.components
{
	import assets.fonts.Fonts;
	import assets.images.CharacterListItemBackground;
	import assets.images.RightArrowBitmap;
	
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.jxl.soundcloud.components.IItemRenderer;
	import com.jxl.soundcloud.components.ImageLoader;
	import com.jxl.dnd.powers.Power;
	
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.core.UIComponent;
	
	public class PowerListItem extends Component implements IItemRenderer
	{
		
		private var power:Power;
		private var powerDirty:Boolean = true;
		private var _data:*;
		
		private var characterListItemBackground:CharacterListItemBackground;
		private var image:ImageLoader;
		private var titleLabel:Label;
		private var flavorLabel:TextField;
		private var infoLabel:Label;
		private var arrow:RightArrowBitmap;
		
		public function get data():* { return _data; }
		public function set data(value:*):void
		{
			_data = value;
			if(_data && _data is Power)
				power = _data;
			
			powerDirty = true;
			invalidateProperties();
		}
		
		public function PowerListItem()
		{
			super();
			
			width = 320;
			height = 72;
			
			this.mouseChildren = this.tabChildren = false;
			this.cacheAsBitmap = true;
		}
		
		protected override function addChildren():void
		{
			super.addChildren();
			
			characterListItemBackground = new CharacterListItemBackground();
			addChild(characterListItemBackground);
			
			image = new ImageLoader();
			addChild(image);
			image.scaleContent = true;
			
			titleLabel = new Label();
			addChild(titleLabel);
			var tf:TextFormat = titleLabel.textField.defaultTextFormat;
			tf.font = Fonts.HELVETICA_NEUE;
			tf.color = 0x000000;
			tf.size = 16;
			titleLabel.textField.defaultTextFormat = tf;
			titleLabel.textField.embedFonts = true;
			
			flavorLabel = new TextField();
			addChild(flavorLabel);
			flavorLabel.multiline = flavorLabel.wordWrap = true;
			tf = flavorLabel.defaultTextFormat
			tf.font = "Arial";
			tf.color = 0x000000;
			tf.size = 12;
			flavorLabel.defaultTextFormat = tf;
			flavorLabel.embedFonts = false;
			
			infoLabel = new Label();
			addChild(infoLabel);
			tf = infoLabel.textField.defaultTextFormat
			tf.font = "Arial";
			tf.color = 0x000000;
			tf.size = 12;
			tf.bold = true;
			infoLabel.textField.defaultTextFormat = tf;
			infoLabel.textField.embedFonts = false;
			
			arrow = new RightArrowBitmap();
			addChild(arrow);
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(powerDirty)
			{
				powerDirty = false;
				
				if(power)
				{
					if(power.icon)
					{
						image.source 			= power.icon;
					}
					else if(power.icon_path && power.icon_path.length > 0)
					{
						image.source			= power.icon_path;
					}
					titleLabel.text 		= power.name;
					flavorLabel.text 		= power.flavor;
					infoLabel.text 			= power.attackRollType;
				}
				else
				{
					image.source			= null;
					titleLabel.text			= "";
					flavorLabel.text		= "";
					infoLabel.text			= "";
				}
				callNextFrame(invalidateDraw);
			}
		}
		
		public override function draw():void
		{
			super.draw();
			
			const MARGIN:Number = 2;
			
			characterListItemBackground.width = width;
			characterListItemBackground.height = height;
			
			image.width = image.height = 62;
			image.x = image.y = 6;
			
			titleLabel.x = image.x + image.width + MARGIN;
			
			flavorLabel.x = titleLabel.x;
			flavorLabel.y = titleLabel.y + titleLabel.height + MARGIN;
			
			infoLabel.x = flavorLabel.x;
			infoLabel.y = flavorLabel.y + flavorLabel.height;
			
			arrow.x = width - (arrow.width + MARGIN);
			arrow.y = Math.round((height / 2) - (arrow.height / 2));
			flavorLabel.width = width - flavorLabel.x - (width - arrow.x) - arrow.width;
			flavorLabel.height = 32;
		}
		
	}
}
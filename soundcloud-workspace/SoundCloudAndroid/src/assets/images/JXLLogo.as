package assets.images
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	
	public class JXLLogo extends Sprite
	{
		[Embed(source="/assets/images/jxl-logo.png")]
		private var BitmapImage:Class;
		
		public function JXLLogo()
		{
			super();
			
			addChild(new BitmapImage() as Bitmap);
			var g:Graphics = graphics;
			g.beginFill(0x000000, 0);
			g.drawRect(0, 0, width, height);
			g.endFill();
			
			this.mouseChildren = false;
			this.useHandCursor = this.buttonMode = true;
		}
	}
}
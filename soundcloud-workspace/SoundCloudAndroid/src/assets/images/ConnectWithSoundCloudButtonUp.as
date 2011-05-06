package assets.images
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	
	public class ConnectWithSoundCloudButtonUp extends Sprite
	{
		[Embed(source="/assets/images/connect-with-soundcloud-button-up.png")]
		private var BitmapImage:Class;
		
		public function ConnectWithSoundCloudButtonUp()
		{
			super();
			
			addChild(new BitmapImage() as Bitmap);
			this.mouseChildren = false;
			this.useHandCursor = this.buttonMode = true;
		}
	}
}
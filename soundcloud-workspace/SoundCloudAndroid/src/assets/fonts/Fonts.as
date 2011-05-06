package assets.fonts
{
	public class Fonts
	{
		[Embed(source="/assets/fonts/fonts.swf", fontName="Lucida Grande")]
		private static var LucidaGrandeFont:Class;
		
		[Embed(source="/assets/fonts/fonts.swf", fontName="Myriad Pro")]
		private static var MyriadProFont:Class;
		
		public static const LUCIDA_GRANDE:String = "Lucida Grande";
		
		
	}
}
package assets.flash
{
	import flash.display.MovieClip;
	
	[Embed(source="/assets/flash/loading-animation.swf", symbol="LoadingAnime")]
	public class LoadingAnimation extends MovieClip
	{
		public function LoadingAnimation()
		{
			super();
			addFrameScript(15, repeat);
			repeat();
		}
		
		private function repeat():void
		{
			gotoAndPlay("start");
			play();
		}
		
		
	}
}
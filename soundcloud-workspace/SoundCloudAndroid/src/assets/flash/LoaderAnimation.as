package assets.flash
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	[Embed(source="/assets/flash/loading-anime.swf", symbol="LoaderAnimation")]
	public class LoaderAnimation extends MovieClip
	{
		public function LoaderAnimation()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		private function onAdded(event:Event):void
		{
			this.play();
		}
		
		private function onRemoved(event:Event):void
		{
			this.stop();
		}
	}
}
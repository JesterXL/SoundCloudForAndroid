package assets
{
	import flash.text.TextFormat;

	public class Styles
	{
		
		public static const LOGIN_TITLE:TextFormat					= new TextFormat("Myriad Pro", 21, 0x333333, false);
		public static const FORM_TITLE:TextFormat 					= new TextFormat("Lucida Grande", 24, 0x333333);
		public static const FORM_LABEL:TextFormat 					= new TextFormat("Lucida Grande", 16, 0x333333, false);
		public static const FORM_INPUT:TextFormat 					= new TextFormat("Lucida Grande", 32, 0x333333, false);
        public static const FORM_PROMPT:TextFormat 					= new TextFormat("Lucida Grande", 16, 0x999999, false);
		public static const PUSH_BUTTON_LABEL:TextFormat 			= new TextFormat("Lucida Grande", 21, 0x333333, false);
		public static const PUSH_BUTTON_SELECTED_LABEL:TextFormat	= new TextFormat("Lucida Grande", 21, 0x0066CC, false);
		public static const CHECKBOX_LABEL:TextFormat 				= new TextFormat("Lucida Grande", 16, 0x333333, false);
		public static const LINK_BUTTON_TEXT:TextFormat 			= new TextFormat("Lucida Grande", 16, 0xCCCCCC, false, false, true);
		public static const TAB_TEXT_SELECTED:TextFormat 			= new TextFormat("Lucida Grande", 18, 0xFB5400, false);
		public static const APP_TITLE:TextFormat 					= new TextFormat("Lucida Grande", 16, 0x0066CC, false);
        public static const SONG_TITLE:TextFormat                   = new TextFormat("Lucida Grande", 18, 0x005ACE, false);
		public static const SONG_TIME:TextFormat                    = new TextFormat("Lucida Grande", 14, 0x333333, false);
		public static const MENU_TEXT:TextFormat                    = new TextFormat("Lucida Grande", 14, 0x333333, false);
		public static const CHANGE_LOG:TextFormat                    = new TextFormat("sans", 14, 0x333333, false);
		
        private static var inited:Boolean                           = classConstruct();

		public function Styles()
		{
		}

        private static function classConstruct():Boolean
        {
            SONG_TIME.letterSpacing = -2;
            return true;
        }
	}
}
package 
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import jp.co.piisu.yotiyoti.GameConst;
	import jp.co.piisu.yotiyoti.MainSprite;
	import jp.co.piisu.yotiyoti.StarlingFactory;
	import jp.co.piisu.yotiyoti.core.Director;
	import jp.co.piisu.yotiyoti.core.XSoundManager;
	import jp.co.piisu.yotiyoti.util.ScreenUtil;
	
	import starling.core.Starling;
	
	public class Yotiyoti extends Sprite
	{
		public static var selecteChara:String;
		public static var clear:Boolean;
		var curStarling:Starling;
		
		var app:NativeApplication;
		
		public function Yotiyoti()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var st:Starling = StarlingFactory.create(MainSprite, stage);
			st.start();
			
			app = NativeApplication.nativeApplication;
			app.addEventListener(Event.DEACTIVATE, onDeactive);
			
		}
		
		private function onDeactive(event:Event):void
		{
			app.removeEventListener(Event.DEACTIVATE, onDeactive);
			XSoundManager.instance.pauseBgm();
			Director.instance.pauseAct();
			app.addEventListener(Event.ACTIVATE, onActive);
		}
		
		private function onActive(event:Event):void
		{
			app.removeEventListener(Event.ACTIVATE, onActive);
			XSoundManager.instance.resumeBgm();
			Director.instance.resumeAct();
			app.addEventListener(Event.DEACTIVATE, onDeactive);
		}
		
		
	}
}
package 
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import jp.co.piisu.yotiyoti.core.Director;
	
	import starling.core.Starling;
	import starling.events.ResizeEvent;
	import jp.co.piisu.yotiyoti.MainSprite;
	import jp.co.piisu.yotiyoti.core.XSoundManager;
	
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
			
			Starling.multitouchEnabled = true;
			Starling.handleLostContext = true;
			curStarling = new Starling(MainSprite, stage);
			Starling.current.showStats = true;
			curStarling.antiAliasing = 0;
			curStarling.start();
			
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
package jp.co.piisu.yotiyoti.scene.game
{
	import jp.co.piisu.yotiyoti.Config;
	
	import org.osflash.signals.Signal;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class SpecialButton extends Sprite
	{
		var img:Image;
		var disable:Boolean;
		
		private var _sigTouch:Signal = new Signal();
		
		public function SpecialButton(tex:Texture)
		{
			super();
			
			img = new Image(tex);
			img.smoothing = Config.smoothing;
			img.scaleX = 0.8;
			img.scaleY = 0.8;
			addChild(img);
			
			disable = false;
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		

		private function onTouch(e:TouchEvent):void {
			if(!disable) {
				var t:Touch = e.getTouch(this, TouchPhase.ENDED);
				if(t != null) {
					sigTouch.dispatch();
				}
			}
		}
		
		public function refreshDisableView():void {
			img.color = 0x808080;
			disable = true;
		}
		
		public function refreshAbleView():void {
			img.color = 0xFFFFFF;
			disable = false;
		}
		
		public function get sigTouch():Signal
		{
			return _sigTouch;
		}
		
	}
}
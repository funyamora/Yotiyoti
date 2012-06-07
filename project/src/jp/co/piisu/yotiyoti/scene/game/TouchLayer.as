package jp.co.piisu.yotiyoti.scene.game
{
	import flash.geom.Point;
	
	import jp.co.piisu.yotiyoti.GameConst;
	
	import org.osflash.signals.Signal;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class TouchLayer extends Sprite
	{
		private var _sigTouchBeganLeft:Signal = new Signal();
		private var _sigTouchBeganRight:Signal = new Signal();
		private var _sigTouchEndedLeft:Signal = new Signal();
		private var _sigTouchEndedRight:Signal = new Signal();
		
		private var _sigFlickUp:Signal = new Signal();
		private var _sigFlickDown:Signal = new Signal();
		
		public function TouchLayer()
		{
			var q:Quad = new Quad(GameConst.WIDTH+100*2, GameConst.HEIGHT, 0x00FF00);
			q.alpha = 0;
			q.x = -100;
			addChild(q);
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var ins:DisplayObject = e.currentTarget as DisplayObject;
			
			procTouch(e.getTouches(this, TouchPhase.BEGAN), ins);
			procTouch(e.getTouches(this, TouchPhase.ENDED), ins);
			
			var touches:Vector.<Touch> = e.getTouches(this, TouchPhase.MOVED);
			for(var i:uint=0; i<touches.length; i++) {
				var move_amount:Number = touches[i].globalY - touches[i].previousGlobalY;
				if(move_amount >= 25) _sigFlickDown.dispatch();
				else if(move_amount <= -25) _sigFlickUp.dispatch();
			}
		}
		
		private function procTouch(touches:Vector.<Touch>, target:DisplayObject):void {
			for(var i:uint=0; i<touches.length; i++) {
				var pos:Point = touches[i].getLocation(target);
				var sig:Signal = phaseToSignal(touches[i].phase, pos);
				if(sig != null) sig.dispatch();
			}
		}
		
		private function phaseToSignal(phase:String, pos:Point):Signal {
			if(phase == TouchPhase.BEGAN) {
				if(pos.x < GameConst.WIDTH/2) return sigTouchBeganLeft;
				else return sigTouchBeganRight;
			}
			
			if(phase == TouchPhase.ENDED) {
				if(pos.x < GameConst.WIDTH/2) return sigTouchEndedLeft;
				else return sigTouchEndedRight;
			}
			
			return null;
		}
		
		public function get sigTouchBeganLeft():Signal
		{
			return _sigTouchBeganLeft;
		}
		
		public function set sigTouchBeganLeft(value:Signal):void
		{
			_sigTouchBeganLeft = value;
		}
		
		public function get sigTouchBeganRight():Signal
		{
			return _sigTouchBeganRight;
		}
		
		public function set sigTouchBeganRight(value:Signal):void
		{
			_sigTouchBeganRight = value;
		}
		
		public function get sigTouchEndedLeft():Signal
		{
			return _sigTouchEndedLeft;
		}
		
		public function set sigTouchEndedLeft(value:Signal):void
		{
			_sigTouchEndedLeft = value;
		}
		
		public function get sigTouchEndedRight():Signal
		{
			return _sigTouchEndedRight;
		}
		
		public function set sigTouchEndedRight(value:Signal):void
		{
			_sigTouchEndedRight = value;
		}


		public function get sigFlickUp():Signal
		{
			return _sigFlickUp;
		}

		public function set sigFlickUp(value:Signal):void
		{
			_sigFlickUp = value;
		}

		public function get sigFlickDown():Signal
		{
			return _sigFlickDown;
		}

		public function set sigFlickDown(value:Signal):void
		{
			_sigFlickDown = value;
		}

		
	}
}
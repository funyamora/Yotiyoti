package jp.co.piisu.yotiyoti.scene.game
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import jp.co.piisu.yotiyoti.Config;
	import jp.co.piisu.yotiyoti.core.ActorSprite;
	import jp.co.piisu.yotiyoti.core.Director;
	import jp.co.piisu.yotiyoti.util.HitUtil;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	public class Funya extends ActorSprite
	{
		const CHARA_HEIGHT:uint = 32;
		const HIT_RECT:Rectangle = new Rectangle(11, 12, 11, 18);
		
		private var _barPos:int = 4;
		
		var charaType:String;
		var clip:MovieClip;
		var vx:Number;
		var vy:Number;
		var touchLayer:TouchLayer;
		
		var pushRight:Boolean;
		var pushLeft:Boolean;
		
		public function Funya(touch_layer:TouchLayer, type:String)
		{
			super();
			
			charaType = type;
			init();
			touchLayer = touch_layer;
			
			Director.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			Director.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			addEventListener(Event.ADDED_TO_STAGE, function():void {
				touchLayer.sigTouchBeganLeft.add( startMoveLeft );
				touchLayer.sigTouchBeganRight.add( startMoveRight );
				touchLayer.sigTouchEndedLeft.add( onEndedLeft );
				touchLayer.sigTouchEndedRight.add( onEndedRight );
				touchLayer.sigFlickUp.add( onFlickUp );
				touchLayer.sigFlickDown.add( onFlickDown );
			});
			
			addEventListener(Event.REMOVED_FROM_STAGE, function():void {
				touchLayer.sigTouchBeganLeft.remove( startMoveLeft );
				touchLayer.sigTouchBeganRight.remove( startMoveRight );
				touchLayer.sigTouchEndedLeft.remove( onEndedLeft );
				touchLayer.sigTouchEndedRight.remove( onEndedRight );
				touchLayer.sigFlickUp.remove( onFlickUp );
				touchLayer.sigFlickDown.remove( onFlickDown );
			});
		}
		
		private function initClip():void
		{
			clip = new MovieClip( MainTexture.getTextures(walkTexturesPrefix), 4 );
			Starling.juggler.add(clip);
			addChild(clip);
			
			clip.smoothing = Config.smoothing;
			clip.x = 0;
			clip.y = 0;
			clip.pivotX = 0;
			clip.pivotY = 0;
		}
		
		public function checkHit(target:Rectangle):Boolean {
			var r:Rectangle = new Rectangle(x+HIT_RECT.x, y+HIT_RECT.y, HIT_RECT.width, HIT_RECT.height);
			return HitUtil.isHit(r, target);
		}
		
		private function onFlickUp():void {
			if( !isJumping && !isDown ) {
				if(barPos >= 2) updateFunc = updateJump;
			}
			
		}
		
		private function onFlickDown():void {
			if( !isJumping && !isDown ) {
				if(barPos < 4) updateFunc = updateDown;
			}
		}
		
		private function onEndedRight():void
		{
			pushRight = false;
			if(!pushLeft) vx = 0;
		}
		
		private function onEndedLeft():void
		{
			pushLeft = false;
			if(!pushRight) vx = 0;
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			var code:int = e.keyCode;
			
			if ( code == Keyboard.RIGHT ) startMoveRight();
			else if( code == Keyboard.LEFT) startMoveLeft();
			
			if( !isJumping && !isDown ) {
				if(code == Keyboard.UP) {
					if(barPos >= 2) updateFunc = updateJump;
				} else if(code == Keyboard.DOWN) {
					if(barPos < 4) updateFunc = updateDown;
				}
			}
		}
		
		private function startMoveLeft():void {
			if(updateFunc != noWork && updateFunc != updateGoTaxi) {
				if(clip.scaleX != -1) {
					clip.scaleX = -1;
					clip.x += clip.width;
				}
				vx = -WALK_SPEED;
				pushLeft = true;
			}
		}
		
		private function startMoveRight():void {
			if(updateFunc != noWork && updateFunc != updateGoTaxi) {
				if(clip.scaleX != 1) {
					clip.scaleX = 1;
					clip.x -= clip.width;
				}
				vx = WALK_SPEED;
				pushRight = true;
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			if ( e.keyCode == Keyboard.RIGHT || e.keyCode == Keyboard.LEFT) vx = 0;
		}
		
		private function get isJumping():Boolean {
			return updateFunc == updateJump;
		}
		
		private function get isDown():Boolean {
			return updateFunc == updateDown;
		}
		
		override public function set updateFunc(value:Function):void
		{
			if(value == updateJump) {
				vy = -JUMP_INIT_VY;
				vx = 0;
				_barPos--;
				
				if(updateFunc == updateGoTaxi) {
					removeChildren();
					initClip();
				}
				
			} else if(value == updateDown) {
				vy = 200;
				vx = 0;
				_barPos++;
				
				if(updateFunc == updateGoTaxi) {
					removeChildren();
					initClip();
				}
				
			}
			
			super.updateFunc = value;
		}
		
		private function updateJump(delta:Number):void {
			moveCommon(delta);
			vy += JUMP_DEC_VY * delta;
			
			if(vy >= 0 && y >= Background.BAR_Y[barPos]-CHARA_HEIGHT ) {
				y = Background.BAR_Y[barPos]-CHARA_HEIGHT;
				vy = 0;
				updateFunc = moveCommon;
			}
		}
		
		private function updateDown(delta:Number):void {
			moveCommon(delta);
			vy += 480 * delta;
			
			if(vy >= 0 && y >= Background.BAR_Y[barPos]-CHARA_HEIGHT ) {
				y = Background.BAR_Y[barPos]-CHARA_HEIGHT;
				vy = 0;
				updateFunc = moveCommon;
			}
		}
		
		public function updateGoTaxi(delta:Number):void {
			moveCommon(delta);
			
			if(updateTime > 1) {
				vx = 0;
				removeChildren();
				initClip();
				updateFunc = moveCommon;
			}
		}
		
		private function get JUMP_DEC_VY():uint {
			if(charaType == CharaType.katsume) return 800;
			else if(charaType == CharaType.okazaki) return 550;
			else if(charaType == CharaType.funya) return 1400;
			else return 500;
		}
		
		private function get JUMP_INIT_VY():uint {
			if(charaType == CharaType.katsume) return 250;
			else if(charaType == CharaType.okazaki) return 250;
			else if(charaType == CharaType.funya) return 350;
			else return 200;
		}
		
		private function get WALK_SPEED():uint {
			if(charaType == CharaType.katsume) return 48;
			else if(charaType == CharaType.okazaki) return 92;
			else if(charaType == CharaType.funya) return 64;
			else return 10;
		}
		
//		private function updateMoveLeft(delta:Number):void
//		{
//			moveCommon(delta);
//		}
//		
//		private function updateMoveRight(delta:Number):void
//		{
//			moveCommon(delta);
//		}
		
		private function moveCommon(delta:Number):void {
			x += vx * delta;
			y += vy * delta;
			
			if(x < -22) x = 245;
			else if(x > 246) x = -21;
		}
		
		public function init():void {
			removeChildren();
			initClip();
			initPos();
			updateFunc = moveCommon;
		}
		
		private function initPos():void {
			x = 0;
			vx = 0;
			vy = 0;
			_barPos = 4;
			y = Background.BAR_Y[barPos] - CHARA_HEIGHT;
			
			clip.scaleX = 1;
			clip.x = 0;
		}

		public function get barPos():int
		{
			return _barPos;
		}

		public function hitEnemy():void
		{
			removeChild(clip);
			
			clip = new MovieClip( MainTexture.getTextures(yararekTexturesPrefix), 3 );
			Starling.juggler.add(clip);
			addChild(clip);
			clip.smoothing = Config.smoothing;
			clip.play();
			
			updateFunc = noWork;
		}
		
		public function banzai():void
		{
			removeChild(clip);
			
			clip = new MovieClip( MainTexture.getTextures(banzaiTexturesPrefix), 3 );
			Starling.juggler.add(clip);
			addChild(clip);
			clip.smoothing = Config.smoothing;
			clip.play();
			
			updateFunc = noWork;
		}
		
		private function get walkTexturesPrefix():String {
			if(charaType == CharaType.yotiyoti) return "enemy_yotiyoti";
			return charaType + "_walk";
		}
		
		private function get yararekTexturesPrefix():String {
			if(charaType == CharaType.yotiyoti) return "enemy_yotiyoti";
			return charaType + "_yarare";
		}
		
		private function get banzaiTexturesPrefix():String {
			if(charaType == CharaType.yotiyoti) return "enemy_yotiyoti";
			return charaType + "_banzai";
		}
		
		
		public function goTaxi():void
		{
			var scale:Number = clip.scaleX;
			removeChild(clip);
			
			clip = new MovieClip( MainTexture.getTextures("taxi") );
			Starling.juggler.add(clip);
			addChild(clip);
			clip.smoothing = Config.smoothing;
			clip.play();
			
			if(scale == -1) {
				clip.scaleX = scale;
				clip.x += clip.width;
			}
			
			vx = 150 * scale;
			updateFunc = updateGoTaxi;
		}
		
		public function yotiyotiWave():void
		{
			var wave:YotiYotiWave = new YotiYotiWave(clip.scaleX, this.x, this.y);
			parent.addChildAt(wave, 1);
			
//			var self:Enemy = this;
//			wave.sigHit.addOnce(function():void {
//				sigHit.dispatch(self);
//			});
//			updateFunc = updateDefault;
		}
		
	}
}
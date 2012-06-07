package jp.co.piisu.yotiyoti.core
{
	import flash.desktop.NativeApplication;
	import flash.errors.IllegalOperationError;
	import flash.utils.getTimer;
	
	import flashx.textLayout.formats.Direction;
	
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;

	public class Director
	{
		private static var _instance :Director;
		private static var _callFromGetInstance :Boolean;
		
		private var _app:NativeApplication;
		private var _directorSprite:DirectorSprite;
		private var _actors:Vector.<Actor> = new Vector.<Actor>();
		
		internal var lastEnterFrameTime:Number;
		
		public function Director()
		{
			if(!_callFromGetInstance) throw new IllegalOperationError("XDirectorのコンストラクタは直接、呼び出せません。 XDirector.instanceを使用してインスタンスを取得してください");
			
			_app = NativeApplication.nativeApplication;
		}
		
		public static function get instance() :Director {
			if(_instance == null) {
				_callFromGetInstance = true;
				_instance = new Director();
				_callFromGetInstance = false;
			}
			
			return _instance;
		}
		
		public static function get stage():Stage {
			return _instance._directorSprite.stage;
		}
		
		public function init(direcotr_sprite:DirectorSprite) :void {
			_directorSprite = direcotr_sprite;
			_directorSprite.addEventListener(starling.events.Event.ENTER_FRAME, onEnterFrame);
			lastEnterFrameTime = getTimer();
		}
		
		public function pauseAct():void {
			if(_directorSprite != null) {
				_directorSprite.removeEventListener(starling.events.Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		public function resumeAct():void {
			lastEnterFrameTime = getTimer();
			if(_directorSprite != null) {
				if(!_directorSprite.hasEventListener(starling.events.Event.ENTER_FRAME)) {
					_directorSprite.addEventListener(starling.events.Event.ENTER_FRAME, onEnterFrame);
				}
			}
		}
		
		private function onEnterFrame(e:starling.events.Event):void
		{
			var gap:Number = (getTimer() - lastEnterFrameTime) / 1000;
			
			for(var i:uint=0; i<_actors.length; i++) {
				_actors[i].update(gap);
			}
			
			lastEnterFrameTime = getTimer();
		}
		
		public function run(scene:Scene) :void {
			if(_directorSprite == null) throw new IllegalOperationError("Directorはまだ初期化されていません。initメソッドで初期化してください");
			if(_directorSprite.currentScene != null) throw new IllegalOperationError("runメソッドはシーンがまだセットされていない場合にしか呼び出せません");
			
			_directorSprite.setScene(scene);
			scene.activate(null);
		}
		
		public function replaceScene(scene:Scene) :void {
			_directorSprite.currentScene.deactivate(scene);
			
			removeAllActors();
			_directorSprite.replaceScene(scene);
		}
		
		public function addActor(actor:Actor):void {
			_actors.push(actor);
		}
		
		public function removeActor(actor:Actor):void {
			var index:int = _actors.indexOf(actor);
			if(index >= 0) _actors.splice(index, 1);
		}
		
		public function removeAllActors():void {
			_actors = new Vector.<Actor>();
		}
		
	}
}
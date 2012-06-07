package jp.co.piisu.yotiyoti.core
{
	import org.osflash.signals.Signal;
	
	import starling.display.Sprite;
	
	public class Scene extends ActorSprite
	{
		protected var _sigSceneActive:Signal;
		protected var _sigSceneDeactive:Signal;
		
		public function Scene()
		{
			super();
			
			_sigSceneActive = new Signal(Scene);
			_sigSceneDeactive = new Signal(Scene);
		}
		
		public function get sigSceneActive():Signal
		{
			return _sigSceneActive;
		}
		
		public function get sigSceneDeactive():Signal
		{
			return _sigSceneDeactive;
		}
		
		internal function deactivate(next_scene:Scene):void
		{
			_sigSceneDeactive.dispatch(next_scene);
		}
		
		internal function activate(prev_scene:Scene):void {
			_sigSceneActive.dispatch(prev_scene);
		}
		
	}
}
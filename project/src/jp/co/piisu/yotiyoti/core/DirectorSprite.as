package jp.co.piisu.yotiyoti.core
{
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class DirectorSprite extends Sprite
	{
		internal var currentScene:Scene;
		internal var oldScene:Scene;
		
		public function DirectorSprite()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, _init);
		}
		
		private function _init(e:Event):void {
			Director.instance.init(this);
			stage.color = 0x000000;
			init();
		}
		
		protected function init():void {
		}
		
		public function replaceScene(scene:Scene) :void {
			oldScene = currentScene;
			removeScene(currentScene);
			
			setScene(scene);
			scene.activate(oldScene);
			scene = null;
		}
		
		internal function removeScene(scene:Scene) :void {
			removeChild(scene);
		}
		
		internal function setScene(scene:Scene) :void {
			scene.x = 0;
			scene.y = 0;
			addChild(scene);
			currentScene = scene;
		}
		
		
		
	}
}
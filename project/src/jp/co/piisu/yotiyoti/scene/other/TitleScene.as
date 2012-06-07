package jp.co.piisu.yotiyoti.scene.other
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.system.Capabilities;
	
	import jp.co.piisu.yotiyoti.Config;
	import jp.co.piisu.yotiyoti.EmbedSounds;
	import jp.co.piisu.yotiyoti.FontManager;
	import jp.co.piisu.yotiyoti.core.Actor;
	import jp.co.piisu.yotiyoti.core.Director;
	import jp.co.piisu.yotiyoti.core.Scene;
	import jp.co.piisu.yotiyoti.core.XSound;
	import jp.co.piisu.yotiyoti.core.XSoundManager;
	import jp.co.piisu.yotiyoti.scene.game.GameScene;
	
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	public class TitleScene extends Scene
	{
		[Embed(source='./resources/title.jpg')]
		private static var jpg:Class;
		
		public function TitleScene()
		{
			super();
			
			var bitmap:Bitmap = new jpg() as Bitmap;
			var tex:Texture = Texture.fromBitmap(bitmap);
			var image:Image = new Image(tex);
			image.smoothing = Config.smoothing;
			
			addChild(image);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var myTouch:Touch = e.getTouch(stage, TouchPhase.ENDED);
			if(myTouch) {
				XSoundManager.instance.playBgm( new XSound(new EmbedSounds.mp3oo(), "oo") );
				
				var ins:DisplayObject = e.currentTarget as DisplayObject;
				var myPos:Point = myTouch.getLocation(ins);
				if(ins.hitTest(myPos, true)) {
					updateFunc = toGameScene;
					sleep(0.3);
				}
			}
		}
		
		private function toGameScene(delta:Number):void {
			Director.instance.replaceScene( new SelectCharaScene() );
		}
		
		
	}
}
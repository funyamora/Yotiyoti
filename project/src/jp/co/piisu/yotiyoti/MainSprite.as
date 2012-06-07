package jp.co.piisu.yotiyoti
{
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import jp.co.piisu.yotiyoti.core.Director;
	import jp.co.piisu.yotiyoti.core.DirectorSprite;
	import jp.co.piisu.yotiyoti.scene.game.AttackWave;
	import jp.co.piisu.yotiyoti.scene.game.GameScene;
	import jp.co.piisu.yotiyoti.scene.other.EndingScene;
	import jp.co.piisu.yotiyoti.scene.other.SelectCharaScene;
	import jp.co.piisu.yotiyoti.scene.other.TitleScene;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.textures.TextureSmoothing;
	
	public class MainSprite extends DirectorSprite
	{
		public function MainSprite()
		{
			super();
		}
		
		protected override function init():void {
			trace(stage.stageWidth + "," + stage.stageHeight);
			trace(Capabilities.screenResolutionX + "," + Capabilities.screenResolutionY);
			
			Starling.current.viewPort = new Rectangle(0, 0, Capabilities.screenResolutionY, Capabilities.screenResolutionX);
			trace(stage.stageWidth + "," + stage.stageHeight);
			
			scaleY = stage.stageHeight / 192;
			scaleX = scaleY;
			
			var quad:Quad = new Quad(256, 192, 0xFFFFFF);
			addChild(quad);
			
			this.x = int( (stage.stageWidth - this.width) / 2 );
			
			FontManager.init();
			Director.instance.run( new TitleScene() );
		}
		
		
	}
}
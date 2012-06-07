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
	import jp.co.piisu.yotiyoti.util.ScreenUtil;
	
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
			
			var fit_rect:Rectangle = ScreenUtil.getScreenFitRectWithFixedAspectRatio(GameConst.WIDTH, GameConst.HEIGHT);
			x = fit_rect.x;
			y = fit_rect.y;
			scaleY = fit_rect.height / GameConst.HEIGHT;
			scaleX = scaleY;
			
			Starling.current.viewPort = new Rectangle( 0, 0, ScreenUtil.screenResolutionX, ScreenUtil.screenResolutionY );
			stage.stageWidth = ScreenUtil.screenResolutionX;
			stage.stageHeight = ScreenUtil.screenResolutionY;
			
			
			FontManager.init();
			Director.instance.run( new TitleScene() );
		}
		
		
	}
}
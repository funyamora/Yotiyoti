package jp.co.piisu.yotiyoti.scene.other
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import jp.co.piisu.yotiyoti.Config;
	import jp.co.piisu.yotiyoti.EmbedSounds;
	import jp.co.piisu.yotiyoti.FontManager;
	import jp.co.piisu.yotiyoti.GameConst;
	import jp.co.piisu.yotiyoti.core.XSound;
	import jp.co.piisu.yotiyoti.core.XSoundManager;
	import jp.co.piisu.yotiyoti.core.Director;
	import jp.co.piisu.yotiyoti.core.Scene;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class EndingScene extends Scene
	{
		[Embed(source='./resources/end.jpg')]
		private static var jpg:Class;
		
		public function EndingScene()
		{
			super();
			XSoundManager.instance.playBgmLoop( new XSound(new EmbedSounds.mp3Ifudodo(), "funya") );
			Yotiyoti.clear = true;
			
			addChild( new Quad(GameConst.WIDTH, GameConst.HEIGHT, 0x000000) );
			updateFunc = updateDefault;
		}
		
		private function updateDefault(delta:Number):void
		{
			var textLine:EndingTextLine = new EndingTextLine(endingTexts[nextPos++]);
			textLine.y = GameConst.HEIGHT;
			addChild(textLine);
			
			if(nextPos >= endingTexts.length) {
				sleep(21);
				updateFunc = updateEnd;
			} else sleep(1.5);
		}
		
		private function updateEnd(delta:Number):void
		{
			var bitmap:Bitmap = new jpg() as Bitmap;
			var tex:Texture = Texture.fromBitmap(bitmap);
			var image:Image = new Image(tex);
			image.smoothing = Config.smoothing;
			
			addChild(image);
			addEventListener(TouchEvent.TOUCH, onTouch);
			updateFunc = updateWaitClick;
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var myTouch:Touch = e.getTouch(stage, TouchPhase.ENDED);
			if(myTouch) {
				XSoundManager.instance.playBgm( new XSound(new EmbedSounds.mp3oo(), "oo") );
				
				var ins:DisplayObject = e.currentTarget as DisplayObject;
				var myPos:Point = myTouch.getLocation(ins);
				if(ins.hitTest(myPos, true)) {
					Director.instance.replaceScene(new TitleScene());
				}
			}
		}
		
		private function updateWaitClick(delta:Number):void
		{
		}
		
		private var nextPos:int = 0;
		private var endingTexts:Vector.<String> = new <String>[
			"",
			"ＣＡＳＴ",
			"",
			"＝ＭＡＩＮ　ＣＨＡＲＡＣＴＥＲ＝",
			"ＦＵＮＹＡＭＯＲＡＫＥ",
			"ＫＡＴＳＵＭＥ",
			"ＯＫＡＺＡＫＩ",
			"",
			"＝ＥＮＥＭＹ＝",
			"ＨＡＮＩＷＡ－ＫＵＮ",
			"ＨＯＰＰＩＮＧ　ＯＪＩＳＡＮ",
			"ＡＳＡＢＡＫＥ",
			"ＫＹＵＫＹＯＫＵ　ＮＯ　ＤＯＧＥＺＡ",
			"",
			"＝ＳＰＥＣＩＡＬ　ＥＮＥＭＹ＝",
			"ＹＯＣＨＩ　ＹＯＣＨＩ　ＫＡＭＥＮ",
			"",
			"",
			"",
			"ＳＴＡＦＦ",
			"＝ＧＡＭＥ　ＤＥＳＩＧＮ／ＢＧＭ＝",
			"ＨＡＴＳＵＮＥ　ＰＩＧ",
			"",
			"＝ＧＲＡＰＨＩＣ＝",
			"ＫＡＴＨＹ　ＴＳＵＫＡＭＯＴＯ",
			"",
			"＝ＥＮＥＭＹ　ＤＥＳＩＧＮ＝",
			"ＣＨＯＮＫＯ　ＭＡＳＵＤＡ",
			"",
			"＝ＰＲＯＧＲＡＭ＝",
			"ＣＨＡＮＫＯ　ＭＡＳＵＤＡ",
			"",
			"＝ＦＬＹＥＲ　ＤＥＳＩＧＮ＝",
			"ＨＹＰＥＲ　ＭＥＤＩＡ　ＣＲＥＡＴＵＲＥ　ＡＭＡＮＯ",
		];
		
	}
	
}
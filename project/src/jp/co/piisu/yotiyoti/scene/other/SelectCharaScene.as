package jp.co.piisu.yotiyoti.scene.other
{
	import jp.co.piisu.yotiyoti.EmbedSounds;
	import jp.co.piisu.yotiyoti.FontManager;
	import jp.co.piisu.yotiyoti.GameConst;
	import jp.co.piisu.yotiyoti.core.XSound;
	import jp.co.piisu.yotiyoti.core.XSoundManager;
	import jp.co.piisu.yotiyoti.core.Director;
	import jp.co.piisu.yotiyoti.core.Scene;
	import jp.co.piisu.yotiyoti.scene.game.CharaType;
	import jp.co.piisu.yotiyoti.scene.game.GameScene;
	import jp.co.piisu.yotiyoti.scene.game.MainTexture;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class SelectCharaScene extends Scene
	{
		var okazaki:Image;
		var funya:Image;
		var katsume:Image;
		var yotiyoti:Image;
		
		var selected:String;
		
		public function SelectCharaScene()
		{
			super();
			
			var q:Quad = new Quad(GameConst.WIDTH, GameConst.HEIGHT, 0xCCCC66);
			addChild(q);
			
			okazaki = createImage(CharaType.okazaki);
			okazaki.x = 16;
			okazaki.y = 50;
			okazaki.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(okazaki);
			addChild( createTextFiled("ＯＫＡＺＡＫＩ", 20, 120) );
			
			
			funya = createImage(CharaType.funya);
			funya.x = 98;
			funya.y = 50;
			funya.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(funya);
			addChild( createTextFiled("ＦＵＮＹＡ", 112, 120) );
			
			katsume = createImage(CharaType.katsume);
			katsume.x = 178;
			katsume.y = 50;
			katsume.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(katsume);
			addChild( createTextFiled("ＫＡＴＳＵＭＥ", 183, 120) );
			
			if(Yotiyoti.clear) {
				yotiyoti = createImage(CharaType.yotiyoti);
				yotiyoti.x = 190;
				yotiyoti.y = 160;
				yotiyoti.addEventListener(TouchEvent.TOUCH, onTouch);
				addChild(yotiyoti);
			}
			
			var tf:TextField = new TextField(200, 40, "つかうキャラをタッチしてね！", "_等幅", 12, 0x663300);
			tf.x = 34;
			tf.y = 130;
			addChild(tf);
		}
		
		private function createTextFiled(text:String, tx:int, ty:int):TextField {
			var textLife:TextField = new TextField(100, 30, text);
			textLife.fontName = FontManager.FONT_FAMANIA.name;
			textLife.fontSize = BitmapFont.NATIVE_SIZE;
			textLife.color = Color.WHITE;
			textLife.vAlign = VAlign.TOP;
			textLife.hAlign = HAlign.LEFT;
			textLife.x = tx;
			textLife.y = ty;
			return textLife;
		}
		
		private function createImage(chara_type:String):Image {
			var tex:Texture;
			
			if(chara_type == CharaType.yotiyoti) tex = MainTexture.getTexture("enemy_yotiyoti1");
			else tex = MainTexture.getTexture(chara_type + "_banzai002");
			
			var img:Image = new Image(tex);
			img.scaleX = 2;
			img.scaleY = 2;
			img.smoothing = TextureSmoothing.NONE;
			img.addEventListener(TouchEvent.TOUCH, onTouch);
			return img;
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var t:Touch = e.getTouch(this, TouchPhase.ENDED);
			
			if(t != null && selected == null) {
				XSoundManager.instance.playBgm( new XSound(new EmbedSounds.mp3oo(), "oo") );
				
				if(t.target == funya) {
					selected = CharaType.funya;
					Yotiyoti.selecteChara = selected;
					Director.instance.replaceScene( new GameScene() );
				}
				else if(t.target == okazaki) {
					selected = CharaType.okazaki;
					Yotiyoti.selecteChara = selected;
					Director.instance.replaceScene( new GameScene() );
				}
				else if(t.target == katsume) {
					selected = CharaType.katsume;
					Yotiyoti.selecteChara = selected;
					Director.instance.replaceScene( new GameScene() );
				}
				else if(t.target == yotiyoti) {
					selected = CharaType.yotiyoti;
					Yotiyoti.selecteChara = selected;
					Director.instance.replaceScene( new GameScene() );
					
				}
			}
			
		}
		
	}
}
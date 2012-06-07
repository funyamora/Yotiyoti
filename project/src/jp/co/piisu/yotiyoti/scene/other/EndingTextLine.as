package jp.co.piisu.yotiyoti.scene.other
{
	import jp.co.piisu.yotiyoti.FontManager;
	import jp.co.piisu.yotiyoti.GameConst;
	import jp.co.piisu.yotiyoti.core.ActorSprite;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class EndingTextLine extends ActorSprite
	{
		public function EndingTextLine(text:String)
		{
			super();
			addChild( createTextFiled(text, 0, 0) );
			
			updateFunc = updateDefault;
		}
		
		private function updateDefault(delta:Number):void
		{
			y -= delta * 10;
			if(y < -30) removeFromParent;
		}
		
		private function createTextFiled(text:String, tx:int, ty:int):TextField {
			var textLife:TextField = new TextField(GameConst.WIDTH, 20, text);
			textLife.fontName = FontManager.FONT_FAMANIA.name;
			textLife.fontSize = BitmapFont.NATIVE_SIZE;
			textLife.color = Color.WHITE;
			textLife.vAlign = VAlign.TOP;
			textLife.hAlign = HAlign.CENTER;
			textLife.x = tx;
			textLife.y = ty;
			return textLife;
		}
		
	}
}
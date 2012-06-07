package jp.co.piisu.yotiyoti
{
	import flash.display.Bitmap;
	
	import starling.text.BitmapChar;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	/**
	 * ビットマップフォントの管理クラス
	 * @author koji
	 */
	public class FontManager
	{
		[Embed(source="./resources/famania_0.png")]
		private static var BitmapChars:Class;
		
		[Embed(source="./resources/famania.fnt", mimeType="application/octet-stream")]
		private static var FamaniaXML:Class;
		
		public static var FONT_FAMANIA:BitmapFont;
		
		public function FontManager()
		{
		}
		
		public static function init():void {
			if(FONT_FAMANIA == null) {
				var bitmap:Bitmap = Bitmap(new BitmapChars());
				var texture:Texture = Texture.fromBitmap(bitmap);
				var xml:XML = XML(new FamaniaXML());
				FONT_FAMANIA = new BitmapFont(texture, xml);
				FONT_FAMANIA.smoothing = TextureSmoothing.NONE;
				TextField.registerBitmapFont(FONT_FAMANIA);
			}
		}
	}
}
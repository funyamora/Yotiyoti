package jp.co.piisu.yotiyoti.scene.game
{
	import flash.display.Bitmap;
	import flash.errors.IllegalOperationError;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class MainTexture
	{
		[Embed(source='./resources/spritesheet.png')]
		private static var sheet:Class;
		
		[Embed(source="./resources/atlas.xml", mimeType="application/octet-stream")]
		private static var atlasXml:Class;
		
		private static var alreadyInit:Boolean;
		
		private static var _texture:Texture;
		private static var _textureAtlas:TextureAtlas;
		
		public function MainTexture()
		{
			throw new IllegalOperationError("インスタンスは生成できません");
		}
		
		private static function init():void {
			var bitmap:Bitmap = new sheet();
			_texture = Texture.fromBitmap(bitmap);
			
			var xml:XML = XML(new atlasXml());
			_textureAtlas = new TextureAtlas(_texture, xml);
			
			alreadyInit = true;
		}
		
		public static function get texture():Texture {
			if(!alreadyInit) init();
			return _texture;
		}
		
		public static function get textureAtlas():TextureAtlas {
			if(!alreadyInit) init();
			return _textureAtlas;
		}
		
		public static function getTexture(name:String):Texture {
			if(!alreadyInit) init();
			return _textureAtlas.getTexture(name);
		}
		
		public static function getTextures(prefix:String):Vector.<Texture> {
			if(!alreadyInit) init();
			return _textureAtlas.getTextures(prefix);
		}
	}
}
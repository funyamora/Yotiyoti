package jp.co.piisu.yotiyoti
{
	import starling.textures.TextureSmoothing;

	/**
	 * アプリに関する設定項目を保持しておくクラス
	 * @author koji
	 */
	public class Config
	{
		/**
		 *  アプリ内で使うテクスチャのスムージングの設定値
		 */
		public static var smoothing:String = TextureSmoothing.NONE;
		
		public function Config()
		{
		}
	}
}
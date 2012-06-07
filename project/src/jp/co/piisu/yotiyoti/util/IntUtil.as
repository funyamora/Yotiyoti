package jp.co.piisu.yotiyoti.util
{
	import flash.errors.IllegalOperationError;

	/**
	 * 整数に関するユーティリティ
	 * @author koji
	 */
	public class IntUtil
	{
		private static const HAN2ZEN:Vector.<String> = new <String>[
			"０", "１", "２", "３", "４", "５", "６", "７", "８", "９"
		];
		
		public function IntUtil()
		{
			throw new IllegalOperationError("インスタンスを作成することができません");
		}
		
		/**
		 * 数値を全角数字の文字列に変換して返す
		 * @param value 数値
		 * @return 全角文字列
		 */
		public static function toZenkaku(value:int):String {
			var as_str:String = new String(value);
			var zenkaku:String = "";
			
			for(var i=0; i<as_str.length; i++) {
				var v:int = int( as_str.charAt(i) );
				zenkaku += HAN2ZEN[v];
			}
			
			return zenkaku;
		}
	}
}
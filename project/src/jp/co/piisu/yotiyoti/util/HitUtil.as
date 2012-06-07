package jp.co.piisu.yotiyoti.util
{
	import flash.errors.IllegalOperationError;
	import flash.geom.Rectangle;

	/**
	 * 当たり判定についてのユーティリティ
	 * @author koji
	 */
	public class HitUtil
	{
		public function HitUtil()
		{
			throw new IllegalOperationError("インスタンスを作成することができません");
		}
		
		/**
		 * 2つの矩形が重なっているかどうかを返す
		 * @param r1 矩形1
		 * @param r2 矩形2
		 * @return 重なっているかどうか
		 */
		public static function isHit(r1:Rectangle, r2:Rectangle):Boolean {
			return r1.left < r2.right 
				&& r1.right > r2.left
				&& r1.top < r2.bottom
				&& r1.bottom > r2.top;
		}
	}
}
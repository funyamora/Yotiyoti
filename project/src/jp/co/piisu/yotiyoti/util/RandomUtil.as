package jp.co.piisu.yotiyoti.util
{
	import flash.errors.IllegalOperationError;

	/**
	 * 乱数に関するユーティリティ
	 * @author koji
	 */
	public class RandomUtil
	{
		public function RandomUtil()
		{
			throw new IllegalOperationError("インスタンスを作成することができません");
		}
		
		/**
		 * min以上、max以下のランダムな整数を生成する
		 * @param min 生成する乱数の最小値
		 * @param max 生成する乱数の最大値
		 * @return 乱数
		 */
		public static function generateUint(min:uint, max:uint):uint {
			return Math.random() * (max-min+1) + min;
		}
	}
}
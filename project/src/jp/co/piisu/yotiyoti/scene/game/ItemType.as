package jp.co.piisu.yotiyoti.scene.game
{
	import flash.errors.IllegalOperationError;

	public class ItemType
	{
		public static const CANDLE:String = "candle";
		public static const ICHIGO:String = "ichigo";
		public static const CAKE:String = "cake";
		public static const ONEUP:String = "1up";
		
		public function ItemType()
		{
			throw new IllegalOperationError("インスタンスは作成できません");
		}
	}
}
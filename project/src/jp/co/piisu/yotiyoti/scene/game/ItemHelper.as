package jp.co.piisu.yotiyoti.scene.game
{
	public class ItemHelper
	{
		public function ItemHelper()
		{
		}
		
		public static function getY(bar_pos:uint):int {
			return Background.BAR_Y[bar_pos] - Item.ITEM_HEIGHT;
		}
	}
}
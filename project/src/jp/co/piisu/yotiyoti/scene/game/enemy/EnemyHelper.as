package jp.co.piisu.yotiyoti.scene.game.enemy
{
	import jp.co.piisu.yotiyoti.scene.game.Background;

	public class EnemyHelper
	{
		public function EnemyHelper()
		{
		}
		
		public static function getY(bar_pos:uint):int {
			return Background.BAR_Y[bar_pos] - Enemy.ENEMY_HEIGHT;
		}
	}
}
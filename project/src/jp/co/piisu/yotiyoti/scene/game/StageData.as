package jp.co.piisu.yotiyoti.scene.game
{
	import jp.co.piisu.yotiyoti.scene.game.enemy.Enemy;
	import jp.co.piisu.yotiyoti.scene.game.enemy.EnemyType;

	public class StageData
	{
		static var gameScene:GameScene;
		static var enemies:Vector.<Enemy>;
		static var items:Vector.<Item>;
		
		public function StageData()
		{
		}
		
		public static function initStage(stage_num:int, scene:GameScene):void {
			gameScene = scene;
			gameScene.restPartsItemNum = 0;
			enemies = new Vector.<Enemy>();
			items = new Vector.<Item>();
			
			if(stage_num == 0) {
				e(EnemyType.HANIWA, 210, 1);
				e(EnemyType.HANIWA, 45, 2);
				e(EnemyType.HANIWA, 180, 3);
				e(EnemyType.HANIWA, 100, 4);
				i(ItemType.CANDLE, 52, 1);
				i(ItemType.CANDLE, 140, 1);
				i(ItemType.CANDLE, 32, 2);
				i(ItemType.CANDLE, 172, 3);
				i(ItemType.CANDLE, 220, 4);
				
			} else if(stage_num == 1) {
				e(EnemyType.HANIWA, 130, 1);
				e(EnemyType.HANIWA, 170, 2);
				e(EnemyType.HOPPING, 220, 2);
				e(EnemyType.HANIWA, 50, 3);
				e(EnemyType.HANIWA, 150, 4);
				i(ItemType.CANDLE, 90, 1);
				i(ItemType.CANDLE, 128, 2);
				i(ItemType.CANDLE, 35, 3);
				i(ItemType.ICHIGO, 229, 4);
				i(ItemType.ONEUP, 204, 2);
				
			} else if(stage_num == 2) {
				e(EnemyType.OR2, 150, 1);
				e(EnemyType.HOPPING, 210, 1);
				e(EnemyType.HOPPING, 80, 2);
				e(EnemyType.HANIWA, 145, 2);
				e(EnemyType.HANIWA, 80, 3);
				e(EnemyType.OR2, 140, 4);
				i(ItemType.CANDLE, 125, 1);
				i(ItemType.CANDLE, 72, 2);
				i(ItemType.ICHIGO, 30, 3);
				i(ItemType.ICHIGO, 110, 4);
				i(ItemType.ONEUP, 190, 2);
				
			} else if(stage_num == 3) {
				e(EnemyType.HANIWA, 90, 1);
				e(EnemyType.HOPPING, 220, 2);
				e(EnemyType.OR2, 48, 3);
				e(EnemyType.HOPPING, 122, 3);
				e(EnemyType.OBAKE, 80, 4);
				i(ItemType.CANDLE, 135, 1);
				i(ItemType.CAKE, 195, 1);
				i(ItemType.CAKE, 25, 2);
				i(ItemType.ONEUP, 70, 2);
				i(ItemType.ICHIGO, 170, 2);
				i(ItemType.ICHIGO, 80, 3);
				i(ItemType.CAKE, 150, 4);
				
			} else if(stage_num == 4) {
				e(EnemyType.HANIWA, 120, 1);
				e(EnemyType.YOTIYOTI, 85, 2);
				e(EnemyType.HOPPING, 65, 3);
				e(EnemyType.OR2, 180, 4);
				e(EnemyType.OBAKE, 60, 4);
				e(EnemyType.OBAKE, 210, 4);
				i(ItemType.CAKE, 10, 1);
				i(ItemType.CAKE, 35, 2);
				i(ItemType.CAKE, 140, 2);
				i(ItemType.CAKE, 210, 2);
				i(ItemType.ONEUP, 95, 3);
				i(ItemType.CAKE, 120, 4);
				i(ItemType.CAKE, 180, 4);
			}
			
		}
		
		private static function e(enemy_type:String, x:int, bar_pos:int) {
			var e:Enemy = new Enemy(enemy_type, gameScene.funya);
			e.x = x;
			e.barPos = bar_pos;
			
			e.sigHit.add(gameScene.hitEnemy);
			gameScene.enemyLayer.addChild(e);
			enemies.push(e);
		}
		
		private static function i(item_type:String, x:int, bar_pos:int) {
			var i:Item = new Item(item_type, gameScene.funya);
			i.x = x;
			i.y = ItemHelper.getY(bar_pos);
			i.sigGet.addOnce(gameScene.hitItem);
			gameScene.itemLayer.addChild(i);
			items.push(i);
			
			if(item_type != ItemType.ONEUP) gameScene.restPartsItemNum++;
		}
	}
}
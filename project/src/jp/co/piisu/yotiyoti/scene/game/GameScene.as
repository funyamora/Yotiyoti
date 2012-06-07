package jp.co.piisu.yotiyoti.scene.game
{
	import flash.geom.Point;
	import flash.system.System;
	
	import flashx.textLayout.formats.Direction;
	
	import jp.co.piisu.yotiyoti.EmbedSounds;
	import jp.co.piisu.yotiyoti.FontManager;
	import jp.co.piisu.yotiyoti.GameConst;
	import jp.co.piisu.yotiyoti.core.Director;
	import jp.co.piisu.yotiyoti.core.Scene;
	import jp.co.piisu.yotiyoti.core.XSound;
	import jp.co.piisu.yotiyoti.core.XSoundManager;
	import jp.co.piisu.yotiyoti.scene.game.enemy.Enemy;
	import jp.co.piisu.yotiyoti.scene.game.enemy.EnemyHelper;
	import jp.co.piisu.yotiyoti.scene.game.enemy.EnemyType;
	import jp.co.piisu.yotiyoti.scene.other.EndingScene;
	import jp.co.piisu.yotiyoti.scene.other.TitleScene;
	import jp.co.piisu.yotiyoti.util.IntUtil;
	
	import org.osflash.signals.Signal;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class GameScene extends Scene
	{
		var funya:Funya;
		var touchLayer:TouchLayer;
		var itemLayer:Sprite;
		var enemyLayer:Sprite;
		var spBtn:SpecialButton;
		
		var enemies:Vector.<Enemy>;
		var items:Vector.<Item>;
		
		private var _stageNum:int;
		private var _score:int;
		private var _restLife:int;
		
		var sigUpdateStageNum:Signal = new Signal(int);
		var sigUpdateScore:Signal = new Signal(int);
		var sigUpdateLife:Signal = new Signal(int);

		var textScore:TextField;
		var textStage:TextField;
		var textLife:TextField;
		
		var restPartsItemNum:int;
		var taxiMeter:Number;
		
		const MAX_STAGE:uint = 5;
		
		public function GameScene()
		{
			super();
			
			_restLife = GameConst.defaultLife;
			
			touchLayer = new TouchLayer();
			funya = new Funya(touchLayer, Yotiyoti.selecteChara);
			itemLayer = new Sprite();
			enemyLayer = new Sprite();
			
			addChild( new Background() );
			addChild(itemLayer);
			addChild(enemyLayer);
			addChild( funya );
			
			textScore = new TextField(200, 100, "ＳＣＯＲＥ　０");
			textScore.fontName = FontManager.FONT_FAMANIA.name;
			textScore.fontSize = BitmapFont.NATIVE_SIZE;
			textScore.color = Color.WHITE;
			textScore.vAlign = VAlign.TOP;
			textScore.hAlign = HAlign.LEFT;
			textScore.x = 10;
			textScore.y = 4;
			addChild(textScore);
			
			textStage = new TextField(200, 100, "ＳＴＡＧＥ　１");
			textStage.fontName = FontManager.FONT_FAMANIA.name;
			textStage.fontSize = BitmapFont.NATIVE_SIZE;
			textStage.color = Color.WHITE;
			textStage.vAlign = VAlign.TOP;
			textStage.hAlign = HAlign.LEFT;
			textStage.x = 10;
			textStage.y = 15;
			addChild(textStage);
			
			textLife = new TextField(200, 100, "ＬＩＦＥ　" + IntUtil.toZenkaku(_restLife) );
			textLife.fontName = FontManager.FONT_FAMANIA.name;
			textLife.fontSize = BitmapFont.NATIVE_SIZE;
			textLife.color = Color.WHITE;
			textLife.vAlign = VAlign.TOP;
			textLife.hAlign = HAlign.LEFT;
			textLife.x = 90;
			textLife.y = 15;
			addChild(textLife);
			
			updateFunc = updateInitStage;
			
			sigUpdateScore.add(function(value:int):void {
				textScore.text = "ＳＣＯＲＥ　" + IntUtil.toZenkaku(value);
			});
			
			sigUpdateStageNum.add(function(value:int):void {
				textStage.text = "ＳＴＡＧＥ　" + IntUtil.toZenkaku(value + 1);
			});
			
			sigUpdateLife.add(function(value:int):void {
				textLife.text = "ＬＩＦＥ　" + IntUtil.toZenkaku(value);
			});
			
			addChild( new HideCurtain() );
			addChild( touchLayer );
			
			if(Yotiyoti.selecteChara == CharaType.katsume) {
				spBtn = new SpecialButton( MainTexture.getTexture("taxi") );
				spBtn.x = GameConst.WIDTH - spBtn.width - 1;
				spBtn.y = -2;
				spBtn.sigTouch.add(pushTaxiButton);
				addChild(spBtn);
			} else if(Yotiyoti.selecteChara == CharaType.yotiyoti) {
				spBtn = new SpecialButton( MainTexture.getTexture("enemy_yotiyoti1") );
				spBtn.x = GameConst.WIDTH - spBtn.width - 1;
				spBtn.y = 0;
				spBtn.sigTouch.add(pushYotiYotiButton);
				addChild(spBtn);
			}
		}
		
		private function pushTaxiButton():void {
			if(taxiMeter >= 8) {
				funya.goTaxi();
				taxiMeter = 0
				spBtn.refreshDisableView();
			}
		}
		
		private function pushYotiYotiButton():void {
			if(taxiMeter >= 8) {
				funya.yotiyotiWave();
				taxiMeter = 0;
				spBtn.refreshDisableView();
			}
		}
		
		private function updateInitStage(delta:Number):void {
			taxiMeter = 8;
			StageData.initStage(stageNum, this);
			enemies = StageData.enemies;
			items = StageData.items;
			funya.init();
			sleepAll();
			
			if(spBtn != null) spBtn.refreshAbleView();
			
			updateFunc = updateBeforeStage;
			System.gc();
			sleep(1);
		}
		
		private function updateBeforeStage(delta:Number):void {
			wakeupAll();
			updateFunc = updateGaming;
			XSoundManager.instance.playBgmLoop( new XSound(new EmbedSounds.mp3FunyaThema(), "funya") );
		}
		
		private function updateGaming(delta:Number):void {
//			taxiMeter += delta;
			if(taxiMeter > 8) {
				taxiMeter = 8;
				if(spBtn != null) spBtn.refreshAbleView();
			}
		}
		
		private function updateHitEnemy(delta:Number):void {
			restLife = restLife - 1;
			
			XSoundManager.instance.stopBgm();
			XSoundManager.instance.playSe(new XSound(new EmbedSounds.mp3Shock(), "shock"));
			
			if(restLife > 0) {
				updateFunc = updateRestart;
				sleep(2.5);
			}
			else {
				updateFunc = updateGameover;
				sleep(3);
			}
		}
		
		private function updateRestart(delta:Number):void {
			enemyLayer.removeChildren();
			itemLayer.removeChildren();
			updateInitStage(delta);
		}
		
		private function updateGameover(delta:Number):void {
			Director.instance.replaceScene( new TitleScene() );
			sleepForever();
		}
		
		private function updateStageClear(delta:Number):void {
			XSoundManager.instance.stopBgm();
			
			stageNum++;
			if(stageNum == MAX_STAGE) {
				Director.instance.replaceScene(new EndingScene());
				sleepForever();
			} else {
				updateFunc = updateRestart;
			}
		}
		
		override public function set updateFunc(value:Function):void
		{
			super.updateFunc = value;
			
			if(updateFunc == updateStageClear) {
				
				XSoundManager.instance.playBgm( new XSound(new EmbedSounds.mp3oo(), "oo") );
				
				funya.banzai();
				sleepAll();
			}
		}
		
		private function sleepAll():void {
			for(var i:uint=0; i<enemies.length; i++) enemies[i].sleepForever();
			funya.sleepForever();
		}
		
		private function wakeupAll():void {
			for(var i:uint=0; i<enemies.length; i++) enemies[i].wakeup();
			funya.wakeup();
		}
		
		function hitEnemy(enemy:Enemy):void {
			if(updateFunc == updateGaming && funya.updateFunc != funya.updateGoTaxi) {
				updateFunc = updateHitEnemy;
				funya.hitEnemy();
				sleepAll();
			}
		}
		
		function hitAttackWave():void {
			hitEnemy(null);
		}
		
		function hitItem(item_type:String):void {
			if(updateFunc == updateGaming) {
				if(item_type != ItemType.ONEUP) {
					restPartsItemNum--;
					if(restPartsItemNum == 0) {
						updateFunc = updateStageClear;
						sleep(2.5);
					}
					
					score += 100;
				} else if(item_type == ItemType.ONEUP) {
					restLife = restLife + 1;
				}
			}
		}
		
		public function get stageNum():int
		{
			return _stageNum;
		}
		
		public function set stageNum(value:int):void
		{
			_stageNum = value;
			sigUpdateStageNum.dispatch(_stageNum);
		}
		
		public function get score():int
		{
			return _score;
		}

		public function set score(value:int):void
		{
			_score = value;
			sigUpdateScore.dispatch(_score);
		}
		
		public function get restLife():int
		{
			return _restLife;
		}
		
		public function set restLife(value:int):void
		{
			_restLife = value;
			sigUpdateLife.dispatch(value);
		}
		
		
		
//		var itm:Item = new Item(ItemType.CANDLE, funya);
//		itm.y = 50;
//		addChild(itm);
//		
//		var e:Enemy = new Enemy(EnemyType.YOTIYOTI, funya);
//		e.x = 120;
//		e.barPos = 3;
//		addChild(e);
		
		
	}
}
package jp.co.piisu.yotiyoti.scene.game.enemy
{
	import flash.geom.Rectangle;
	
	import jp.co.piisu.yotiyoti.Config;
	import jp.co.piisu.yotiyoti.GameConst;
	import jp.co.piisu.yotiyoti.core.ActorSprite;
	import jp.co.piisu.yotiyoti.scene.game.AttackWave;
	import jp.co.piisu.yotiyoti.scene.game.Background;
	import jp.co.piisu.yotiyoti.scene.game.Funya;
	import jp.co.piisu.yotiyoti.scene.game.MainTexture;
	import jp.co.piisu.yotiyoti.util.RandomUtil;
	
	import org.osflash.signals.Signal;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	
	public class Enemy extends ActorSprite
	{
		private var funya:Funya;
		private var enemyType:String;
		private var clip:MovieClip;
		
		private var vx:int;
		private var vy:int;
		private var funcAi:Function;
		private var _barPos:int;
		
		private var _sigHit:Signal = new Signal(Enemy);		//ヒットした敵のインスタンス
		private var thinkInterval:Number;
		
		private var speed:int;
		private var watchRange:int;
		private var sleepSpecial:Number = 0;
		
		public static const ENEMY_WIDTH:uint = 32;
		public static const ENEMY_HEIGHT:uint = 32;
		public static const MAX_X:int = GameConst.WIDTH - ENEMY_WIDTH + 16;
		public static const MIN_X:int = -16;
		
		public function Enemy(enemy_type:String, funya:Funya)
		{
			super();
			
			this.enemyType = enemy_type;
			this.funya = funya;
			
			clip = createMovieClip(enemy_type);
			clip.smoothing = Config.smoothing;
			Starling.juggler.add(clip);
			addChild(clip);
			
			updateFunc = updateDefault;
			funcAi = getAiFunc(enemy_type);
			init();
		}
		
		private function init():void {
			if(enemyType == EnemyType.HANIWA) {
				if(RandomUtil.generateUint(0,100) < 50) vx = 60;
				else vx = -60;
			} else if(enemyType == EnemyType.OBAKE) {
				thinkInterval = RandomUtil.generateUint(0, 10)*0.1 + 2;
			} else if(enemyType == EnemyType.OR2) {
				speed = 20;
			} else if(enemyType == EnemyType.YOTIYOTI) {
				speed = 5;
				watchRange = 82;
			} else if(enemyType == EnemyType.HOPPING) {
				watchRange = 48;
			}
		}
		
		private function updateDefault(delta:Number):void
		{
			funcAi(delta);
			
			x += vx * delta;
			y += vy * delta;
			
			if(x > MAX_X) x = MAX_X;
			else if(x < MIN_X) x = MIN_X;
			
			if(funya.checkHit( new Rectangle(x+8, y+7, 16, 20) ) ) {
				_sigHit.dispatch(this);
			}
		}
		
		private function updateJump(delta:Number):void {
			updateDefault(delta);
			vy += 1400 * delta;
			
			if(vy >= 0 && y >= Background.BAR_Y[barPos]-ENEMY_HEIGHT) {
				y = Background.BAR_Y[barPos]-ENEMY_HEIGHT;
				vy = 0;
				updateFunc = updateDefault;
			}
		}
		
		private function updateAttackWave(delta:Number):void
		{
			var gap:Number = funya.x - this.x;
			var wave:AttackWave;
			if(gap > 0) {
				//右
				wave = new AttackWave(1, this.x, this.y, funya);
			} else {
				//左
				wave = new AttackWave(-1, this.x, this.y, funya);
			}
			parent.addChild(wave);
			
			var self:Enemy = this;
			wave.sigHit.addOnce(function():void {
				sigHit.dispatch(self);
			});
			updateFunc = updateDefault;
		}
		
		private function updateDown(delta:Number):void {
			updateDefault(delta);
			vy += 480 * delta;
			
			if(vy >= 0 && y >= Background.BAR_Y[barPos]-ENEMY_HEIGHT) {
				y = Background.BAR_Y[barPos]-ENEMY_HEIGHT;
				vy = 0;
				updateFunc = updateDefault;
			}
		}
		
		override public function set updateFunc(value:Function):void
		{
			super.updateFunc = value;
			
			if(value == updateJump) {
				vy = -350;
				vx = 0;
				_barPos--;
			} else if(value == updateDown) {
				vy = 200;
				vx = 0;
				_barPos++;
			}
			
		}
		
		private function get isJumping():Boolean {
			return updateFunc == updateJump;
		}
		
		private function get isDown():Boolean {
			return updateFunc == updateDown;
		}
		
		private function createMovieClip(enemy_type:String):MovieClip {
			var texs:Vector.<Texture> = MainTexture.getTextures("enemy_" + enemy_type);
			var clip:MovieClip = new MovieClip(texs, 4);
			
			return clip;
		}
		
		private function getAiFunc(enemy_type:String):Function {
			if(enemy_type == EnemyType.HANIWA) return thinkByHaniwa;
			else if(enemy_type == EnemyType.HOPPING) return thinkByHopping;
			else if(enemy_type == EnemyType.OBAKE) return thinkByOabke;
			else if(enemy_type == EnemyType.OR2) return thinkByOr2;
			else if(enemy_type == EnemyType.YOTIYOTI) return thinkByYotiyoti;
			
			throw new Error("illegal enemy_type=" + enemy_type);
		}
		
		private function thinkByHaniwa(delta:Number):void {
			if( RandomUtil.generateUint(0, 45) == 0 || 
				x == MIN_X || x == MAX_X) vx *= -1;
		}
		
		private function thinkByHopping(delta:Number):void {
			thinkJumpOrDown(delta);
		}
		
		private function thinkJumpOrDown(delta:Number):void {
			var gap:Number = Math.abs( (x+16) - (funya.x+16) );
			
			if(!isJumping && !isDown) {
				if(gap <= watchRange) {
					if( RandomUtil.generateUint(0, 20) == 0 ) {
						if(funya.barPos > _barPos) updateFunc = updateDown;
						else if(funya.barPos < barPos) updateFunc = updateJump;
					}
				} else {
					var r:int = RandomUtil.generateUint(0, 1000);
					if(r > 985 && _barPos < 4) updateFunc = updateDown;
					else if(r > 970 && _barPos > 1) updateFunc = updateJump;
				}
			}
		}
		
		private function thinkAttackWave(delta:Number):void {
			sleepSpecial -= delta;
			
			if(!isJumping && !isDown && sleepSpecial <= 0) {
				updateFunc = updateAttackWave;
				sleepSpecial = 3;
			}
		}
		
		private function thinkByOabke(delta:Number):void {
			thinkInterval -= delta;
			
			if(thinkInterval < 0) {
				var tx:int = RandomUtil.generateUint(0, GameConst.WIDTH-ENEMY_WIDTH);
				var ty:int = 0;
				do {
					ty = EnemyHelper.getY( RandomUtil.generateUint(1, 4) );
				} while(ty == y);
				
				if(tx > x) {
					if(clip.scaleX != -1) {
						clip.scaleX = -1;
						clip.x += clip.width;
					}
				} else if(tx < x) {
					if(clip.scaleX != 1) {
						clip.scaleX = 1;
						clip.x -= clip.width;
					}
				}
				
				var tw:Tween = new Tween(this, 3, Transitions.EASE_IN_OUT_ELASTIC);
				tw.moveTo(tx, ty);
				Starling.juggler.add(tw);
				
				thinkInterval = RandomUtil.generateUint(0, 10)*0.2 + 5;
			}
		}
		
		private function thinkByOr2(delta:Number):void {
			thinkTrace(delta);
		}
		
		private function thinkTrace(delta:Number):void {
			if( Math.abs(funya.x - x) < 0.5 ) x = funya.x;
			
			if(funya.x > x) {
				vx = speed;
				if(clip.scaleX != -1) {
					clip.scaleX = -1;
					clip.x += clip.width;
				}
			}
			else if(funya.x < x) {
				vx = -speed;
				if(clip.scaleX != 1) {
					clip.scaleX = 1;
					clip.x -= clip.width;
				}
			}
			else vx = 0;
		}
		
		private function thinkByYotiyoti(delta:Number):void {
			thinkTrace(delta);
			thinkJumpOrDown(delta);
			thinkAttackWave(delta);
		}
		
		public function get barPos():int
		{
			return _barPos;
		}
		
		public function set barPos(value:int):void
		{
			_barPos = value;
			y = EnemyHelper.getY(_barPos);
		}
		
		public function get sigHit():Signal
		{
			return _sigHit;
		}
		
		
	}
}
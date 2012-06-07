package jp.co.piisu.yotiyoti.scene.game
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	
	import jp.co.piisu.yotiyoti.GameConst;
	import jp.co.piisu.yotiyoti.core.ActorSprite;
	
	import org.osflash.signals.Signal;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.ParticleDesignerPS;
	import starling.extensions.ParticleSystem;
	import starling.textures.Texture;

	public class AttackWave extends ActorSprite
	{
		[Embed(source='./resources/particle_texture.png')]
		private static var particle:Class;
		
		[Embed(source="./resources/attack_wave.pex", mimeType="application/octet-stream")]
		private static var config:Class;
		
		private static var bitmap:Bitmap;
		private static var psConfig:XML;
		
		private var particleSystem:ParticleDesignerPS;
		private var direct:int;
		private var funya:Funya;
		
		public var sigHit:Signal = new Signal();
		
		public function AttackWave(direct:int, x:int, y:int, funya:Funya)
		{
			this.funya = funya;
			this.direct = direct;
			if(bitmap == null) {
				psConfig = XML( new config());
				bitmap = Bitmap(new particle());
			}
			
			var psTexture:Texture = Texture.fromBitmap(bitmap);
			particleSystem = new ParticleDesignerPS(psConfig, psTexture);
			particleSystem.emitterX = 70;
			particleSystem.emitterY = 15;
			particleSystem.start();
			addChild(particleSystem);
			
			Starling.juggler.add(particleSystem);
			
			if(direct == 1) {
				particleSystem.scaleX = -1;
				particleSystem.emitterX -= 30;
			}
			this.x = x;
			this.y = y;
			
//			var q:Quad = new Quad(30, 30, 0x00FF00);
//			q.alpha = 0.6;
//			addChild(q);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onDispose);
			
			updateFunc = updateDefault;
		}
		
		private function updateDefault(delta:Number):void
		{
			x += delta * 80 * direct;
			
			if(funya.checkHit(new Rectangle(x,y,30,30))) sigHit.dispatch();
			
			if(x > GameConst.WIDTH+50) this.removeFromParent();
			else if(x < -50) this.removeFromParent();
		}
		
		private function onDispose(e:Event):void {
			Starling.juggler.remove(particleSystem);
			particleSystem.dispose();
		}
	}
}
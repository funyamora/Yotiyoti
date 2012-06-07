package jp.co.piisu.yotiyoti.scene.game
{
	import flash.geom.Rectangle;
	
	import jp.co.piisu.yotiyoti.Config;
	import jp.co.piisu.yotiyoti.core.ActorSprite;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Item extends ActorSprite
	{
		private var itemType:String;
		private var funya:Funya;
		
		public static const ITEM_WIDTH:uint = 16;
		public static const ITEM_HEIGHT:uint = 16;
		
		private var _sigGet:Signal = new Signal(String);		//引数はアイテムタイプを示す文字列
		
		public function Item(item_type:String, funya:Funya)
		{
			super();
			this.itemType = item_type;
			
			var image:Image = createImage(item_type);
			image.smoothing = Config.smoothing;
			addChild(image);
			
			this.funya = funya;
			updateFunc = updateDefault;
		}
		
		private function updateDefault(delta:Number):void
		{
			if( funya.checkHit( new Rectangle(x, y, ITEM_WIDTH, ITEM_HEIGHT) ) ) {
				updateFunc = updateHit;
			}
			
			
			
		}
		
		private function updateHit(delta:Number):void
		{
			sigGet.dispatch(itemType);
			removeFromParent();
		}
		
		private function createImage(item_type:String):Image {
			if(item_type == ItemType.CANDLE) return new Image( MainTexture.getTexture("item1") );
			else if(item_type == ItemType.ICHIGO) return new Image( MainTexture.getTexture("item2") );
			else if(item_type == ItemType.CAKE) return new Image( MainTexture.getTexture("item3") );
			else if(item_type == ItemType.ONEUP) return new Image( MainTexture.getTexture("1up") );
			
			throw new Error("illegal item type=" + item_type);
		}
		
		public function get sigGet():Signal
		{
			return _sigGet;
		}

		
	}
}
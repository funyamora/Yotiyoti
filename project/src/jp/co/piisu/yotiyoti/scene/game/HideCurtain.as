package jp.co.piisu.yotiyoti.scene.game
{
	import jp.co.piisu.yotiyoti.GameConst;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class HideCurtain extends Sprite
	{
		const CURTAIN_WIDTH:int = 100;
		const COLOR:uint = 0x000000;
		
		public function HideCurtain()
		{
			super();
			
			var q:Quad = new Quad(CURTAIN_WIDTH, GameConst.HEIGHT, COLOR);
			addChild(q);
			
			var q2:Quad = new Quad(CURTAIN_WIDTH, GameConst.HEIGHT, COLOR);
			q2.x = q.width + GameConst.WIDTH;
			addChild(q2);
			
			x = -CURTAIN_WIDTH;
			
			flatten();
		}
	}
}
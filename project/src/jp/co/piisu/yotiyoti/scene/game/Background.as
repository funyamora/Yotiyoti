package jp.co.piisu.yotiyoti.scene.game
{
	import jp.co.piisu.yotiyoti.FontManager;
	import jp.co.piisu.yotiyoti.GameConst;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class Background extends Sprite
	{
		public static const BAR_Y:Vector.<int> = new <int>[
			26, 26+40, 26+40*2, 26+40*3, 26+40*4
		];
		
		public function Background()
		{
			super();
			
			addChild( new Quad(GameConst.WIDTH, GameConst.HEIGHT, 0x333333) );
			
			var header:Quad = new Quad(GameConst.WIDTH, 26, 0xFB9A30);
			addChild(header);
			
			for(var i:uint=0; i<5; i++) {
				var bar:Quad = new Quad(GameConst.WIDTH, 7, 0xFBFBFB);
				bar.x = 0;
				bar.y = 26 + i*40;
				addChild(bar);
			}
			
			flatten();
		}
	}
}
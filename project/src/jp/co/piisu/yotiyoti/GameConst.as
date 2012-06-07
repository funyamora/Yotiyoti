package jp.co.piisu.yotiyoti
{
	import jp.co.piisu.yotiyoti.scene.game.CharaType;

	public class GameConst
	{
		public function GameConst()
		{
		}
		
		public static const WIDTH:int = 256;
		public static const HEIGHT:int = 192;
		
		public static function get defaultLife():int {
			if(Yotiyoti.selecteChara == CharaType.katsume) return 30;
			else if(Yotiyoti.selecteChara == CharaType.funya) return 23;
			else if(Yotiyoti.selecteChara == CharaType.okazaki) return 15;
			else if(Yotiyoti.selecteChara == CharaType.yotiyoti) return 99;
			
			throw new Error("illegal chara type=" + Yotiyoti.selecteChara);
		}
		
	}
}
package jp.co.piisu.yotiyoti
{
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import jp.co.piisu.yotiyoti.util.ScreenUtil;
	
	import starling.core.Starling;

	public class StarlingFactory
	{
		public function StarlingFactory()
		{
			throw new IllegalOperationError("インスタンスは作成できません");
		}
		
		public static function create(root_class:Class, stage:Stage):Starling {
			Starling.multitouchEnabled = true;
			Starling.handleLostContext = true;
			var sta:Starling = new Starling(MainSprite, stage);
			
			Starling.current.showStats = true;
			sta.antiAliasing = 0;
			return sta;
		}
	}
}
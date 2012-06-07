package jp.co.piisu.yotiyoti.util
{
	import flash.desktop.NativeApplication;
	import flash.display.StageOrientation;
	import flash.errors.IllegalOperationError;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import starling.core.Starling;

	public class ScreenUtil
	{
		private static const EMULATOR_DEVICE_WIDTH:uint = 502;
		private static const EMULATOR_DEVICE_HEIGHT:uint = 960;
		
		public function ScreenUtil()
		{
			throw new IllegalOperationError("インスタンスは作成できません");
		}
		
		public static function getScreenFitRectWithFixedAspectRatio(width:uint, height:uint):Rectangle {
			var rx:Number = screenResolutionX / width;
			var ry:Number = screenResolutionY / height;
			
			trace("o " + Capabilities.screenResolutionX + "," + Capabilities.screenResolutionY);
			trace("a " + screenResolutionX + "," + screenResolutionY);
			trace("r " + rx + "," + ry);
			
			var x:Number;
			var y:Number;
			var w:Number;
			var h:Number;
			if(rx < ry) {
				w = screenResolutionX;
				h = int(height * rx);
				x = 0;
				y = int( (screenResolutionY- h) / 2 );
			} else {
				w = width * ry;
				h = screenResolutionY;
				x = int( (screenResolutionX - w) / 2 );
				y = 0;
			}
			
			return new Rectangle(x, y, w, h);
		}
		
		public static function get screenResolutionX():Number {
			if(isEmulator) return EMULATOR_DEVICE_HEIGHT;
			return Capabilities.screenResolutionY;
		}
		
		public static function get screenResolutionY():Number {
			if(isEmulator) return EMULATOR_DEVICE_WIDTH;
			return Capabilities.screenResolutionX;
		}
		
		private static function get isEmulator():Boolean {
			return Capabilities.os.indexOf("Windows") >= 0 || Capabilities.os.indexOf("Mac") >= 0;
		}
		
	}
}
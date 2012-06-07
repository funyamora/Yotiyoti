package jp.co.piisu.yotiyoti.core
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ActorSprite extends Sprite implements Actor
	{
		protected var life:Number;
		protected var age:Number;
		protected var updateTime:Number;		//updateFuncが切り替わってからの時間
		
		private var _updateFunc:Function;
		private var _sleepTime:Number;
		
		public function ActorSprite()
		{
			super();
			updateFunc = noWork;
			
			addEventListener(Event.ADDED_TO_STAGE, onActive);
			addEventListener(Event.REMOVED_FROM_STAGE, onDeactive);
		}
		
		private function onActive(e:Event):void {
			Director.instance.addActor(this);
		}
		
		private function onDeactive(e:Event):void {
			Director.instance.removeActor(this);
		}

		public function update(delta:Number):void
		{
			updateTime += delta;
			
			if(life <= 0) removeFromParent();
			else {
				if(_sleepTime > 0) {
					_sleepTime -= delta;
				} else {
					updateFunc(delta);
				}
			}
			
			age += delta;
		}
		
		protected final function noWork(delta:Number):void {}

		public function get updateFunc():Function
		{
			return _updateFunc;
		}

		public function set updateFunc(value:Function):void
		{
			updateTime = 0;
			_updateFunc = value;
		}
		
		public function sleep(time:Number):void {
			_sleepTime = time;
		}
		
		public function sleepForever():void {
			sleep(Number.MAX_VALUE);
		}
		
		public function wakeup():void {
			_sleepTime = 0;
		}
		
		override public function removeFromParent(dispose:Boolean=false):void
		{
			super.removeFromParent(dispose);
			Director.instance.removeActor(this);
		}
		
	}
}
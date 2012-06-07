package jp.co.piisu.yotiyoti.core
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.events.GenericEvent;
	import org.osflash.signals.natives.NativeSignal;

	public class XSound
	{
		private var _sound:Sound;
		private var _channel:SoundChannel;
		private var _transform:SoundTransform;
		private var _volume:Number;
		
		private var _sigNativeComplete:NativeSignal;
		private var _sigCompletePlay:DeluxeSignal;
		private var _sigCompleteFadeOut:DeluxeSignal;
		private var _sigCompleteFadeIn:DeluxeSignal;
		
		private var _lastPosition = -1;
		private var _count:int;
		private var _name:String;
		
		private var _toVolume:Number;
		private var _stepVolume:Number;
		
		private var timer:Timer;
		
		public function XSound(sound:Sound, name:String, volume:Number=1)
		{
			_sound = sound;
			_name = name;
			_volume = volume;
			_transform = new SoundTransform();
			
			_sigCompletePlay = new DeluxeSignal(this);
			_sigCompleteFadeIn = new DeluxeSignal(this);
			_sigCompleteFadeOut = new DeluxeSignal(this);
		}
		
		public function play(count:uint=1, position:uint=0):void {
			if(_channel != null) stop();
			
			_lastPosition = -1;
			_count = count;
			_transform.volume = _volume;
			
			if(position != 0 && count > 1) {
				_channel = _sound.play(position, 1, _transform);
				
				_sigNativeComplete = new NativeSignal(_channel, Event.SOUND_COMPLETE, Event);
				_sigNativeComplete.addOnce(onCompleteFirstPlay);
				
			} else {
				_channel = _sound.play(position, count, _transform);
				_sigNativeComplete = new NativeSignal(_channel, Event.SOUND_COMPLETE, Event);
				_sigNativeComplete.addOnce(onComplete);
			}
		}
		
		public function fade(volume:Number, time:Number) :void {
			if(_channel != null && this.volume != volume) {
				_toVolume = volume;
				_stepVolume = (volume - _volume) / (time * 20);
				
				if(timer != null) {
					disposeTimer();
					_sigCompleteFadeIn.removeAll();
					_sigCompleteFadeOut.removeAll();
				}
				
				timer = new Timer(50, 0);
				timer.addEventListener(TimerEvent.TIMER, onFade);
				timer.start();
			}
		}
		
		private function onFade(e:TimerEvent):void {
			volume +=_stepVolume;
			
			if(volume >= _toVolume && _stepVolume > 0) {
				volume = _toVolume;
				disposeTimer();
				_sigCompleteFadeIn.dispatch(new GenericEvent());
				
			} else if(volume <= _toVolume && _stepVolume < 0){
				volume = _toVolume;
				disposeTimer();
				_sigCompleteFadeOut.dispatch(new GenericEvent());
			}
		}
		
		private function disposeTimer():void {
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, onFade);
			timer = null;
		}
		
		public function playLoop():void {
			play(int.MAX_VALUE);
		}
		
		public function stop():void {
			if(_channel != null) {
				recLastPosition();
				_channel.stop();
				_channel = null;
			}
		}
		
		internal function recLastPosition():void {
			_lastPosition = _channel.position;
		}
		
		public function resume():void {
//			if(_channel != null) return;
			if(_lastPosition == -1) return;
			if(timer != null) disposeTimer();
			
			play(_count, _lastPosition);
		}
		
		public function get volume()
		{
			return _volume;
		}
		
		public function set volume(value):void
		{
			if(value >= 1) value = 1;
			else if(value <= 0) value = 0;
			
			_volume = value;
			
			if(_channel != null) {
				_transform.volume = _volume;
				_channel.soundTransform = _transform;
			}
		}
		
		private function onComplete(e:Event):void {
			_sigCompletePlay.dispatch(new GenericEvent());
		}
		
		private function onCompleteFirstPlay(e:Event):void {
			play(--_count, 0);
		}

		public function get sigCompletePlay():DeluxeSignal
		{
			return _sigCompletePlay;
		}

		public function set sigCompletePlay(value:DeluxeSignal):void
		{
			_sigCompletePlay = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get sigCompleteFadeOut():DeluxeSignal
		{
			return _sigCompleteFadeOut;
		}

		public function set sigCompleteFadeOut(value:DeluxeSignal):void
		{
			_sigCompleteFadeOut = value;
		}

		public function get sigCompleteFadeIn():DeluxeSignal
		{
			return _sigCompleteFadeIn;
		}

		public function set sigCompleteFadeIn(value:DeluxeSignal):void
		{
			_sigCompleteFadeIn = value;
		}

		
	}
}
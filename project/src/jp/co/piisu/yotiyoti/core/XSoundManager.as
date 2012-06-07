package jp.co.piisu.yotiyoti.core
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.events.GenericEvent;

	public class XSoundManager
	{
		private static var _instance :XSoundManager;
		private static var callFromGetInstance :Boolean;
		
		private var _bgmVolume:Number = 0.5;
		private var _seVolume:Number = 0.5;
		
		private var _currentBgm:XSound;
		private var _oldBgm:XSound;
		private var _isPlayingBgm:Boolean;
		
		private var _isPausing:Boolean;
		private var _isResuming:Boolean;
		
		private var _playingSeVector:Vector.<XSound> = new Vector.<XSound>();
		
		public function XSoundManager()
		{
			if(!callFromGetInstance) throw new IllegalOperationError("XSoundManagerのコンストラクタは直接、呼び出せません。 XSoundManager.instanceを使用してインスタンスを取得してください");
		}
		
		public static function get instance() :XSoundManager {
			if(_instance == null) {
				callFromGetInstance = true;
				_instance = new XSoundManager();
				callFromGetInstance = false;
			}
			
			return _instance;
		}
		
		public function playBgm(sound:XSound, fade_time:Number=0):void {
			_play(1, sound, fade_time);
		}
		
		public function playBgmLoop(sound:XSound, fade_time:Number=0):void {
			_play(int.MAX_VALUE, sound, fade_time);
		}
		
		private function _play(count:uint, sound:XSound, fade_time:Number):void {
			if(_currentBgm == sound) {
				if(!_isPlayingBgm) resumeBgm(fade_time);
				return;
			}
			if(_currentBgm != null) stopBgm(fade_time);
			
			if(fade_time > 0 && !_isPausing && !_isResuming) {
				//フェードで切り替え
				_currentBgm = sound;
				_currentBgm.volume = 0;
				_currentBgm.play(count);
				_currentBgm.fade(_bgmVolume, fade_time);
				
			} else {
				//すぐにBGM切り替え
				_currentBgm = sound;
				_currentBgm.volume = _bgmVolume;
				_currentBgm.play(count);
				_isPausing = false;
				_isResuming = false;
			}
			
			_isPlayingBgm = true;
		}
		
		public function stopBgm(fade_time:Number=0):void {
			if(_currentBgm != null) {
				if(fade_time > 0) {
					//フェードアウトしてからstop
					_oldBgm = _currentBgm;
					_oldBgm.fade(0, fade_time);
					_oldBgm.sigCompleteFadeOut.addOnce(function(e:GenericEvent):void {
						if(_oldBgm != null) {
							trace("complete fade out & dispose _oldBgm:" + _oldBgm.name);
							_oldBgm.stop();
							_oldBgm = null;
						}
					});
					_currentBgm = null;
					
				} else {
					//すぐにstop
					_currentBgm.stop();
					_currentBgm = null;
				}
				_isPlayingBgm = false;
			} else {
			}
		}
		
		public function pauseBgm(fade_time:Number=0):void {
			if(_currentBgm != null) {
				if(fade_time > 0 && !_isPausing && !_isResuming) {
					//フェードアウトしてからstop
					_isPausing = true;
					_currentBgm.recLastPosition();
					_currentBgm.fade(0, fade_time);
					_currentBgm.sigCompleteFadeOut.addOnce(function(e:GenericEvent):void {
						if(_currentBgm != null) _currentBgm.stop();
						_isPausing = false;
					});
					
				} else {
					//すぐにstop
					_currentBgm.stop();
					_isPausing = false;
					_isResuming = false;
				}
				_isPlayingBgm = false;
			} else {
			}
		}
		
		public function resumeBgm(fade_time:Number=0):void {
			if(_isPlayingBgm) {
				return;
			}
			
			if(_currentBgm != null) {
				trace("resumeBgm:" + fade_time + "," + _isPausing + "," + _isResuming);
				if(fade_time > 0 && !_isPausing && !_isResuming) {
					_isResuming = true;
					_currentBgm.volume = 0;
					_currentBgm.resume();
					_currentBgm.fade(bgmVolume, fade_time);
					_currentBgm.sigCompleteFadeIn.addOnce(function(e:GenericEvent):void {
						_isResuming = false;
					});
					
				} else {
					_currentBgm.resume();
					_currentBgm.volume = bgmVolume;
					_isPausing = false;
					_isResuming = false;
				}
				_isPlayingBgm = true;
			} else {
			}
		}
		
		public function playSe(sound:XSound):void {
//			if(_playingSeVector.indexOf(sound) == -1) {
//				_playingSeVector.push(sound);
//				sound.volume = _seVolume;
//				sound.play();
//				sound.sigCompletePlay.add(function(e:GenericEvent):void {
//					var index:int = _playingSeVector.indexOf(sound);
//					_playingSeVector.splice(index, 1);
//				});
//			}
			
			sound.volume = _seVolume;
			sound.play();
		}
		
		public function allSeStop():void {
			for(var i:uint=0; i<_playingSeVector.length; i++) {
				var snd:XSound = _playingSeVector[i];
				snd.stop();
			}
			_playingSeVector.splice(0, _playingSeVector.length);
		}
		
		public function allFadeOut(fade_time:Number):void {
			pauseBgm(fade_time);
			for(var i:uint=0; i<_playingSeVector.length; i++) {
				var snd:XSound = _playingSeVector[i];
				snd.fade(0, fade_time);
			}
		}
		
		public function get isPlayingBgm():Boolean {
			return false;
		}
		
		public function get bgmVolume():Number
		{
			return _bgmVolume;
		}

		public function set bgmVolume(value:Number):void
		{
			_bgmVolume = value;
		}

		public function get seVolume():Number
		{
			return _seVolume;
		}

		public function set seVolume(value:Number):void
		{
			_seVolume = value;
		}
		
	}
}
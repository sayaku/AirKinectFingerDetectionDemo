package com.as3nui.nativeExtensions.air.kinect.extensions.gesture 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Gray Liao
	 */
	public class GestureRecognizerManager extends Object 
	{
		/**
		 * @private
		 *
		 */
		protected static var _canInit:Boolean = false;
		
		/**
		 * @private
		 *
		 */
		protected static var _instance:GestureRecognizerManager;
		
		private var _gestureRecognizers:Vector.<KinectGestureRecognizer>;
		private var _timer:Timer;
		
		public function GestureRecognizerManager() 
		{
			if (_canInit == false) 
			{
				throw new Error("GestureRecognizerManager is an singleton and cannot be instantiated.");
			}
			_gestureRecognizers = new <KinectGestureRecognizer>[];
			_timer = new Timer(33);
		}
		
		//Public API
		
		public static function addGesture(gestureRecognizer:KinectGestureRecognizer):void
		{
			getInstance().addGesture(gestureRecognizer);
		}
		
		public static function removeGesture(gestureRecognizer:KinectGestureRecognizer):void
		{
			getInstance().removeGesture(gestureRecognizer);
		}
		
		
		//Protected methods
		
		/**
		 * @private
		 *
		 */
		protected function addGesture(gestureRecognizer:KinectGestureRecognizer):void
		{
			var index:int = _gestureRecognizers.indexOf(gestureRecognizer);
			if (index < 0)
			{
				_gestureRecognizers.push(gestureRecognizer);
			}
			checkForStarting();
		}
		
		/**
		 * @private
		 *
		 */
		protected function removeGesture(gestureRecognizer:KinectGestureRecognizer):void
		{
			var index:int = _gestureRecognizers.indexOf(gestureRecognizer);
			if (index > -1)
			{
				_gestureRecognizers.splice(index, 1);
			}
			checkForStopping();
		}
		
		/**
		 * @private
		 *
		 */
		private function checkForStarting():void 
		{
			if (_gestureRecognizers.length > 0 && !_timer.running)
			{
				_timer.start();
				_timer.addEventListener(TimerEvent.TIMER, loop);
			}
		}
		
		/**
		 * @private
		 *
		 */
		private function checkForStopping():void 
		{
			if (_gestureRecognizers.length == 0 && _timer.running)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, loop);
			}
		}
		
		/**
		 * @private
		 *
		 */
		private function loop(e:TimerEvent):void 
		{
			var l:int = _gestureRecognizers.length;
			for (var i:int = 0; i < l; i++)
			{
				_gestureRecognizers[i].calculate();
			}
		}
		
		/**
		 * @private
		 *
		 */
		protected static function getInstance():GestureRecognizerManager {
			if (_instance == null) {
				_canInit = true;
				_instance = new GestureRecognizerManager();
				_canInit = false;
			}
			return _instance;
		}
	}

}
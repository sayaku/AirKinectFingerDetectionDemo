package com.as3nui.nativeExtensions.air.kinect.extensions.display 
{
	import com.as3nui.nativeExtensions.air.kinect.data.SkeletonJoint;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.extensions.events.CursorEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Gray Liao
	 */
	public class KinectCursor extends MovieClip 
	{
		private var _timer:Timer;
		private var _holdingTime:Number;
		private var _user:User;
		private var _offsetX:Number;
		private var _offsetY:Number;
		private var _rangeWidth:Number;
		private var _rangeHeight:Number;
		private var _startHoldingTime:int;
		private var _range:Rectangle;
		private var _savedFilteredJointPosition:Point;
        private var _savedTrend:Point;
        private var _savedBasePosition:Point;
        private var _frameCount:int;
		private var _trendSmoothingFactor:Number;
		private var _jitterRadius:Number;
		private var _dataSmoothingFactor:Number;
		private var _predictionFactor:Number;
		public var isTracking:Boolean;
		public var isHolding:Boolean;
		public var holdingButton:KinectButton;
		
		public function KinectCursor() 
		{
			init();
			
		}
		
		private function init():void 
		{
			_holdingTime = 1000;
			isTracking = false;
			_savedFilteredJointPosition = new Point();
			_savedTrend = new Point();
			_savedBasePosition = new Point();
			_trendSmoothingFactor = 0.25;
			_jitterRadius = 0.05;
			_dataSmoothingFactor = 0.5;
			_predictionFactor = 0.5;
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}
		
		private function addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			CursorManager.addCursor(this);
		}
		
		private function removedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			CursorManager.removeCursor(this);
		}
		
		public function startTracking(user:User, range:Rectangle = null):void
		{
			_user = user;
			if (range)
			{
				_range = range;
			}else {
				_range = new Rectangle(0.5, 0.2, 0.35, 0.6);
			}
			isTracking = true;
		}
		
		public function stopTracking():void
		{
			isTracking = false;
		}
		
		public function set holdingTime(time:Number):void
		{
			_holdingTime = time;
		}
		
		public function startHolding():void
		{
			if (!_timer)
			{
				_timer = new Timer(_holdingTime, 1);
			}
			isHolding = true;
			_timer.reset();
			_timer.delay = _holdingTime;
			_startHoldingTime = getTimer();
			
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			
			_timer.start();
		}
		
		public function updateHolding():void
		{
			var currentTime:int = getTimer();
			var percent:Number = (currentTime-_startHoldingTime) / _holdingTime;
			if (percent > 1)
			{
				percent = 1;
			}
			updatePercent(percent);
		}
		
		public function stopHolding():void
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			isHolding = false;
			setNormal();
			holdingButton = null;
		}
		
		private function onTimerComplete(e:TimerEvent):void 
		{
			trace("onTimerComplete");
			if (holdingButton)
			{
				holdingButton.atSelected();
				holdingButton.dispatchEvent(new CursorEvent(CursorEvent.SELECTED));
			}
			stopHolding();
		}
		
		public function updatePosition():void
		{
			var hand:SkeletonJoint = _user.getJointByName(SkeletonJoint.RIGHT_HAND);
			
			var filteredJointPosition:Point;
			var differenceVector:Point;
            var currentTrend:Point;
            var distance:Number;

			var baseJointPosition:Point = hand.position.rgbRelative;
			var prevFilteredJointPosition:Point = _savedFilteredJointPosition;
			var previousTrend:Point = _savedTrend;
			var previousBaseJointPosition:Point = _savedBasePosition;
			
			
			if (stage)
			{
				//x = (hand.position.rgbRelative.x - _range.x) / _range.width * stage.stageWidth;
				//y = (hand.position.rgbRelative.y - _range.y) / _range.height * stage.stageHeight;
				
				var tempPoint:Point;
				var tempPoint2:Point;
				// Checking frames count
				if (_frameCount == 0)
				{
					filteredJointPosition = baseJointPosition;
					currentTrend = new Point(0, 0);
				}else if (_frameCount == 1) {
					tempPoint = baseJointPosition.add(previousBaseJointPosition);
					filteredJointPosition =  new Point(tempPoint.x * 0.5, tempPoint.y * 0.5);
					differenceVector = filteredJointPosition.subtract(prevFilteredJointPosition);
					
					tempPoint = new Point(differenceVector.x * _trendSmoothingFactor, differenceVector.y * _trendSmoothingFactor);
					tempPoint2 = new Point(previousTrend.x * (1 - _trendSmoothingFactor), previousTrend.y * (1 - _trendSmoothingFactor));
					currentTrend = tempPoint.add(tempPoint2);
				}else {
					// Jitter filter
					differenceVector = baseJointPosition.subtract(prevFilteredJointPosition);
					distance = Math.abs(differenceVector.length);
					
					if (distance <= _jitterRadius)
					{
						tempPoint = new Point(baseJointPosition.x * (distance / _jitterRadius), baseJointPosition.y * (distance / _jitterRadius));
						tempPoint2 = new Point(prevFilteredJointPosition.x * (1 - (distance / _jitterRadius)), prevFilteredJointPosition.y * (1 - (distance / _jitterRadius)));
						filteredJointPosition = tempPoint.add(tempPoint2);
					}else {
						filteredJointPosition = baseJointPosition;
					}
					
					// Double exponential smoothing filter
					tempPoint = new Point(filteredJointPosition.x * (1 - _dataSmoothingFactor), filteredJointPosition.y * (1 - _dataSmoothingFactor));
					tempPoint2 = prevFilteredJointPosition.add(previousTrend);
					tempPoint2.x *= _dataSmoothingFactor;
					tempPoint2.y *= _dataSmoothingFactor;
					filteredJointPosition = tempPoint.add(tempPoint2);
					
					differenceVector = filteredJointPosition.subtract(prevFilteredJointPosition);
					tempPoint = new Point(differenceVector.x * _trendSmoothingFactor, differenceVector.y * _trendSmoothingFactor);
					tempPoint2 = new Point(previousTrend.x * (1 - _trendSmoothingFactor), previousTrend.y * (1 - _trendSmoothingFactor));
					currentTrend = tempPoint.add(tempPoint2);
				}
				
				// Compute potential new position
				tempPoint = new Point(currentTrend.x * _predictionFactor, currentTrend.y * _predictionFactor);
				var potentialNewPosition:Point = filteredJointPosition.add(tempPoint);
				x = (potentialNewPosition.x - _range.x) / _range.width * stage.stageWidth;
				y = (potentialNewPosition.y - _range.y) / _range.height * stage.stageHeight;
				
				// Cache current value
				_savedBasePosition = baseJointPosition;
				_savedFilteredJointPosition = filteredJointPosition;
				_savedTrend = currentTrend;
				_frameCount++;
				
			}
		}
		
		public function updatePercent(percent:Number):void
		{
			
		}
		
		public function setNormal():void
		{
			
		}
		
		public function dispose():void
		{
			if (!_timer)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				_timer = null;
			}
		}
	}

}
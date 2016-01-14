package com.as3nui.nativeExtensions.air.kinect.extensions.gesture 
{
	import com.as3nui.nativeExtensions.air.kinect.data.SkeletonJoint;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Gray Liao
	 */
	public class SwipeGestureRecognizer extends KinectGestureRecognizer
	{
		private var _isStarted:Boolean;
		private var _user:User;
		private var _hand:String;
		private var _swipeMinLength:Number;
		private var _swipeMaxHeight:Number;
		private var _swipeMinDuration:int;
		private var _swipeMaxDuration:int;
		public var direction:int;
		
		public static const DIRECTION_NONE:int = 0;
		public static const DIRECTION_RIGHT:int = 1;
		public static const DIRECTION_LEFT:int = 2;
		
		public function SwipeGestureRecognizer(user:User, hand:String = SkeletonJoint.RIGHT_HAND , onStart:Function = null, onStop:Function = null, onUpdate:Function = null) 
		{
			super(user, onStart, onStop, onUpdate);
			_user = user;
			if (hand == SkeletonJoint.RIGHT_HAND || hand == SkeletonJoint.LEFT_HAND)
			{
				_hand = hand;
			}else {
				_hand = SkeletonJoint.RIGHT_HAND;
			}
			_swipeMinLength = 400;
            _swipeMaxHeight = 20;
            _swipeMinDuration = 250;
            _swipeMaxDuration = 1500;
			periodBetweenGestures = 1000;
			//記錄座標點的長度
			_positionDataSize = 20;
		}
		
		override public function calculate():void 
		{
			//dynamic gesture 需要呼叫 addPosition 將一段時間內的位置記錄下來
			addPosition([_hand, SkeletonJoint.TORSO]);
			
			if (_user)
			{
				var l:int = _positionDatas.length;
				var startIndex:int = 0;
				var isSussess:Boolean = false;
				var duration:int = 0;
				var nowDirection:int = DIRECTION_NONE;
				
				if (_positionDatas[l - 1].positions[0].y > _positionDatas[l - 1].positions[1].y)
				{
					//swipe to right
					for (var i:int = 1; i < l - 1; i++)
					{
						if (!(_positionDatas[i].positions[0].y - _positionDatas[0].positions[0].y < _swipeMaxHeight))
						{
							startIndex = i;
						}
						if (!(_positionDatas[i + 1].positions[0].x - _positionDatas[i].positions[0].x > -1))
						{
							startIndex = i;
						}
						if (Math.abs(_positionDatas[i].positions[0].x - _positionDatas[startIndex].positions[0].x) > _swipeMinLength)
						{
							duration = _positionDatas[i].time - _positionDatas[startIndex].time;
							if (duration >= _swipeMinDuration && duration <= _swipeMaxDuration)
							{
								isSussess = true;
								nowDirection = DIRECTION_RIGHT;
								break;
							}
						}
					}
					
					if (!isSussess)
					{
						startIndex = 0;
						duration = 0;
						//swipe to left
						for (i = 1; i < l - 1; i++)
						{
							if (!(_positionDatas[i].positions[0].y - _positionDatas[0].positions[0].y < _swipeMaxHeight))
							{
								startIndex = i;
							}
							if (!(_positionDatas[i + 1].positions[0].x - _positionDatas[i].positions[0].x < 1))
							{
								startIndex = i;
							}
							if (Math.abs(_positionDatas[i].positions[0].x - _positionDatas[startIndex].positions[0].x) > _swipeMinLength)
							{
								duration = _positionDatas[i].time - _positionDatas[startIndex].time;
								if (duration >= _swipeMinDuration && duration <= _swipeMaxDuration)
								{
									isSussess = true;
									nowDirection = DIRECTION_LEFT;
									break;
								}
							}
						}
					}
				}
				
				var nowTime:int = getTimer();
				if (isSussess)
				{
					if (!_isStarted)
					{
						if (nowTime - _lastGestureTime > periodBetweenGestures)
						{
							_lastGestureTime = nowTime;
							_isStarted = true;
							direction = nowDirection;
							onStart();
						}
					}else {
						if (nowDirection != direction)//不同方向
						{
							onStop();
							direction = nowDirection;
							onStart();
						}
						direction = nowDirection;
						onUpdate();
					}
				}else {
					if (_isStarted)
					{
						_isStarted = false;
						onStop();
						direction = DIRECTION_NONE;
					}
				}
			}
			
		}
		
		override public function dispose():void 
		{
			super.dispose();
			//自行清除這個子類別用到的資源
		}
	}

}
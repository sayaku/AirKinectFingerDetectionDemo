package com.as3nui.nativeExtensions.air.kinect.extensions.gesture 
{
	import com.as3nui.nativeExtensions.air.kinect.data.SkeletonJoint;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Gray Liao
	 */
	public class HelloGestureRecognizer extends KinectGestureRecognizer 
	{
		private var _isStarted:Boolean;
		private var _user:User;
		private var _hand:String;
		
		public function HelloGestureRecognizer(user:User, hand:String = SkeletonJoint.RIGHT_HAND, onStart:Function = null, onStop:Function = null, onUpdate:Function = null) 
		{
			super(user, onStart, onStop, onUpdate);
			_user = user;
			if (hand == SkeletonJoint.RIGHT_HAND || hand == SkeletonJoint.LEFT_HAND)
			{
				_hand = hand;
			}else {
				_hand = SkeletonJoint.RIGHT_HAND;
			}
			periodBetweenGestures = 500;
		}
		
		override public function calculate():void 
		{
			//Gesture 開始時呼叫
			//onStart();
			
			//Gesture 停止時呼叫
			//onStop();
			
			//Gesture 更新時呼叫
			//onUpdate();
			if (_user)
			{
				var handPos:Vector3D = _user.getJointByName(_hand).position.world;
				var headPos:Vector3D = _user.getJointByName(SkeletonJoint.HEAD).position.world;
				
				var nowTime:int = getTimer();
				if (Math.abs(handPos.y - headPos.y) < 100)
				{
					if (!_isStarted)
					{
						if (nowTime - _lastGestureTime > periodBetweenGestures)
						{
							_lastGestureTime = nowTime;
							_isStarted = true;
							onStart();
						}
					}else {
						onUpdate();
					}
				}else {
					if (_isStarted)
					{
						_isStarted = false;
						onStop();
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
package com.as3nui.nativeExtensions.air.kinect.extensions.gesture 
{
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Gray Liao
	 */
	public class KinectGestureRecognizer extends EventDispatcher 
	{
		private var _user:User;
		private var _onStart:Function;
		private var _onStop:Function;
		private var _onUpdate:Function;
		protected var _positionDatas:Vector.<PositionData>;
		protected var _positionDataSize:uint;
		protected var _lastGestureTime:uint;
		public var periodBetweenGestures:uint;
		
		public function KinectGestureRecognizer(user:User, onStart:Function = null, onStop:Function = null, onUpdate:Function = null) 
		{
			periodBetweenGestures = 0;
			_lastGestureTime = 0;
			_user = user;
			_onStart = onStart;
			_onStop = onStop;
			_onUpdate = onUpdate;
			init();
		}
		
		private function init():void 
		{
			_positionDatas = new Vector.<PositionData>();
			_positionDataSize = 20;
			GestureRecognizerManager.addGesture(this);
		}
		
		protected function onStart():void
		{
			if (_onStart != null)
			{
				_onStart(this);
			}
		}
		
		protected function onStop():void
		{
			if (_onStop != null)
			{
				_onStop(this);
			}
		}
		
		protected function onUpdate():void
		{
			if (_onUpdate != null)
			{
				_onUpdate(this);
			}
		}
		
		public function pause():void
		{
			GestureRecognizerManager.removeGesture(this);
		}
		
		public function resume():void
		{
			GestureRecognizerManager.addGesture(this);
		}
		
		protected function addPosition(jointNames:Array):void
		{
			var positionData:PositionData = new PositionData();
			positionData.time = getTimer();
			if (_user)
			{
				var l:int = jointNames.length;
				for (var i:int = 0; i < l; i++)
				{
					positionData.positions.push(_user.getJointByName(jointNames[i]).position.world.clone());
				}
			}
			
			_positionDatas.push(positionData);
			if (_positionDatas.length > _positionDataSize)
			{
				_positionDatas.shift();
			}
		}
		
		public function calculate():void
		{
			
		}
		
		public function dispose():void
		{
			GestureRecognizerManager.removeGesture(this);
			_onStart = null;
			_onStop = null;
			_onUpdate = null;
			_positionDatas = null;
		}
	}

}
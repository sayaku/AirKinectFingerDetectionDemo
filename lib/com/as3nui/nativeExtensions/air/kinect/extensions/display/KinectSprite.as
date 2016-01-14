package com.as3nui.nativeExtensions.air.kinect.extensions.display 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Gray Liao
	 */
	public class KinectSprite extends Sprite 
	{
		protected var _connectStarted:Boolean;
		protected var _explicitWidth:Number = 800;
		protected var _explicitHeight:Number = 600;
		
		public function KinectSprite() 
		{
			init();
		}
		
		private function init():void 
		{
			_connectStarted = false;
			addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage, false, 0, true);
		}
		
		protected function addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			startConnect();
		}
		
		protected function removedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			stopConnect();
		}
		
		public function startConnect():void 
		{
			if (!_connectStarted)
			{
				_connectStarted = true;
				startConnectImplementation();
				layout();
			}
			
		}
		
		public function stopConnect():void 
		{
			if (_connectStarted)
			{
				_connectStarted = false;
				stopConnectImplementation();
			}
		}
		
		protected function startConnectImplementation():void 
		{
			trace("startConnectImplementation");
		}
		
		protected function stopConnectImplementation():void 
		{
			trace("stopConnectImplementation");
		}
		
		public function setSize(width:Number, height:Number):void
		{
			_explicitWidth = width;
			_explicitHeight = height;
			layout();
		}
		
		protected function layout():void 
		{
			
		}
	}

}
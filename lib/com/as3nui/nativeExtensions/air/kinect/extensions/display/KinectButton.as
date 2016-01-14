package com.as3nui.nativeExtensions.air.kinect.extensions.display 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Gray Liao
	 */
	public class KinectButton extends MovieClip 
	{
		public static const STATE_NORMAL:int = 0;
		public static const STATE_HOVER:int = 1;
		public static const STATE_SELECTED:int = 2;
		public var state:int;
		public var onHover:Function;
		public var onNormal:Function;
		public var onSelected:Function;
		
		public function KinectButton() 
		{
			init();
		}
		
		private function init():void 
		{
			state = STATE_NORMAL;
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}
		
		private function addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			CursorManager.addButton(this);
		}
		
		private function removedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			CursorManager.removeButton(this);
		}
		
		public function atHover():void
		{
			if (onHover != null)
			{
				onHover();
			}
		}
		
		public function atNormal():void
		{
			if (onNormal != null)
			{
				onNormal();
			}
		}
		
		public function atSelected():void
		{
			if (onSelected != null)
			{
				onSelected();
			}
		}
	}

}
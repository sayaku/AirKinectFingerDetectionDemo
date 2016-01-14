package com.sayaku.Event 
{
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author sayaku
	 */
	public class KinectFingerEvent extends Event 
	{
		public static const HAND_OPEN:String = "hand_open";
		public static const HAND_CLOSE:String = "hand_close";
		public var fingerPoint:Vector.<Point>=new <Point>[];
		public var fingertipNum:int=0;
		
		public function KinectFingerEvent(type:String,fingerPoint:Vector.<Point>,fingertipNum:int, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.fingerPoint = fingerPoint;
			this.fingertipNum = fingertipNum;
		} 
		
		public override function clone():Event 
		{ 
			return new KinectFingerEvent(type,fingerPoint,fingertipNum, bubbles, cancelable);
		} 
	
		
	}
	
}
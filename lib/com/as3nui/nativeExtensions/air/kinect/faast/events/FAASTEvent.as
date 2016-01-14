package com.as3nui.nativeExtensions.air.kinect.faast.events
{
	import flash.events.Event;
	
	public class FAASTEvent extends Event
	{
		public static const LEFT_ARM_FORWARD:String = "event:left_arm_forward";
		public static const LEFT_ARM_DOWN:String = "event:left_arm_down";
		public static const LEFT_ARM_UP:String = "event:left_arm_up";
		public static const LEFT_ARM_OUT:String = "event:left_arm_out";
		public static const LEFT_ARM_ACCROSS:String = "event:left_arm_across";
		
		public static const RIGHT_ARM_FORWARD:String = "event:right_arm_forward";
		public static const RIGHT_ARM_DOWN:String = "event:right_arm_down";
		public static const RIGHT_ARM_UP:String = "event:right_arm_up";
		public static const RIGHT_ARM_OUT:String = "event:right_arm_out";
		public static const RIGHT_ARM_ACCROSS:String = "event:right_arm_across";
		
		public static const LEFT_FOOT_FORWARD:String = "event:left_foot_forward";
		public static const LEFT_FOOT_SIDEWAYS:String = "event:left_foot_sideways";
		public static const LEFT_FOOT_BACKWARD:String = "event:left_foot_backward";
		public static const LEFT_FOOT_UP:String = "event:left_foot_up";
		
		public static const RIGHT_FOOT_FORWARD:String = "event:right_foot_forward";
		public static const RIGHT_FOOT_SIDEWAYS:String = "event:right_foot_sideways";
		public static const RIGHT_FOOT_BACKWARD:String = "event:right_foot_backward";
		public static const RIGHT_FOOT_UP:String = "event:right_foot_up";
		
		public static const JUMPING:String = "event:jumping";
		public static const CROUCHED:String = "event:crouched";
		public static const WALKING:String = "event:walking";
		
		public static const LEAN_LEFT:String = "event:lean_left";
		public static const LEAN_RIGHT:String = "event:lean_right";
		public static const LEAN_FORWARD:String = "event:lean_forward";
		public static const LEAN_BACKWARD:String = "event:lean_backward";
		
		public static const TURN_LEFT:String = "event:turn_left";
		public static const TURN_RIGHT:String = "event:turn_right";
		
		public var distance:Number = 0;
		public var distance2:Number = 0;
		public var angle:Number = 0;
		
		public function FAASTEvent(type:String, distance:Number = 0, distance2:Number = 0, angle:Number = 0, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.distance = distance;
			this.distance2 = distance2;
			this.angle = angle;
			super(type, bubbles, cancelable);
		}
	}
}
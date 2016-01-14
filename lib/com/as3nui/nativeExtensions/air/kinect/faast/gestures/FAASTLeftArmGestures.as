package com.as3nui.nativeExtensions.air.kinect.faast.gestures
{
	import flash.events.EventDispatcher;
	
	import com.as3nui.nativeExtensions.air.kinect.faast.events.FAASTEvent;
	import com.as3nui.nativeExtensions.air.kinect.objects.NUIPoint3D;
	import com.as3nui.nativeExtensions.air.kinect.objects.UserSkeleton;
	import com.as3nui.nativeExtensions.air.kinect.unit.math.NiPoint3DUtil;

	public class FAASTLeftArmGestures extends FAASTBasicGestures
	{
		public function FAASTLeftArmGestures(useInches:Boolean = false)
		{
			super(useInches);
		}
		
		override public function configure(skeleton:UserSkeleton):void
		{
			// Call the super.
			super.configure(skeleton);
			
			// Define Left Arm.
			var leftShoulder:NUIPoint3D = skeleton.leftShoulder;
			var leftElbow:NUIPoint3D = skeleton.leftElbow;
			var leftHand:NUIPoint3D = skeleton.leftHand;
			
			var leftArmRangeX:Number = (Math.max(leftShoulder.pointX, leftElbow.pointX, leftHand.pointX) - Math.min(leftShoulder.pointX, leftElbow.pointX, leftHand.pointX));
			var leftArmRangeY:Number = (Math.max(leftShoulder.pointY, leftElbow.pointY, leftHand.pointY) - Math.min(leftShoulder.pointY, leftElbow.pointY, leftHand.pointY));
			var leftArmRangeZ:Number = (Math.max(leftShoulder.pointZ, leftElbow.pointZ, leftHand.pointZ) - Math.min(leftShoulder.pointZ, leftElbow.pointZ, leftHand.pointZ));
			var leftArmRange:Number = (leftArmRangeX + leftArmRangeY + leftArmRangeZ)/3;
			
			// Left Arm Out.
			if(leftArmRangeY <= leftArmRange && leftHand.pointX < leftShoulder.pointX 
				&& leftArmRangeZ <= leftArmRange)
			{
				this.distance = (this.useInches) ? NiPoint3DUtil.convertMMToInches(leftArmRangeX) : leftArmRangeX;
				this.dispatchEvent(new FAASTEvent(FAASTEvent.LEFT_ARM_OUT, this.distance));
			}
			
			// Left Arm Across.
			if(leftArmRangeY <= leftArmRange && leftHand.pointX > leftShoulder.pointX 
				&& leftArmRangeZ <= leftArmRange)
			{
				this.distance = (this.useInches) ? NiPoint3DUtil.convertMMToInches(leftArmRangeX) : leftArmRangeX;
				this.dispatchEvent(new FAASTEvent(FAASTEvent.LEFT_ARM_ACCROSS, this.distance));
			}
			
			// Left Arm Forward.
			if(leftArmRangeX <= leftArmRange && leftHand.pointZ < leftShoulder.pointZ
				&& leftArmRangeY <= leftArmRange)
			{
				this.distance = (this.useInches) ? NiPoint3DUtil.convertMMToInches(leftArmRangeZ) : leftArmRangeZ;
				this.dispatchEvent(new FAASTEvent(FAASTEvent.LEFT_ARM_FORWARD, this.distance));
			}
			
			// Left Arm Up.
			if(leftArmRangeX <= leftArmRange && leftHand.pointY > leftShoulder.pointY 
				&& leftArmRangeZ <= leftArmRange)
			{
				this.distance = (this.useInches) ? NiPoint3DUtil.convertMMToInches(leftArmRangeY) : leftArmRangeY;
				this.dispatchEvent(new FAASTEvent(FAASTEvent.LEFT_ARM_UP, this.distance));
			}
			
			// Left Arm Down.
			if(leftArmRangeX <= leftArmRange && leftHand.pointY < leftShoulder.pointY 
				&& leftArmRangeZ <= leftArmRange)
			{
				this.distance = (this.useInches) ? NiPoint3DUtil.convertMMToInches(leftArmRangeY) : leftArmRangeY;
				this.dispatchEvent(new FAASTEvent(FAASTEvent.LEFT_ARM_DOWN, this.distance));
			}
		}
	}
}
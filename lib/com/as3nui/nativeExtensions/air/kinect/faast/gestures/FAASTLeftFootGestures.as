package com.as3nui.nativeExtensions.air.kinect.faast.gestures
{
	import flash.events.EventDispatcher;
	
    import com.as3nui.nativeExtensions.air.kinect.faast.events.FAASTEvent;
	import com.as3nui.nativeExtensions.air.kinect.objects.NUIPoint3D;
	import com.as3nui.nativeExtensions.air.kinect.objects.UserSkeleton;
	import com.as3nui.nativeExtensions.air.kinect.unit.math.NiPoint3DUtil;

	public class FAASTLeftFootGestures extends FAASTBasicGestures
	{
		public function FAASTLeftFootGestures(useInches:Boolean = false)
		{
			super(useInches);
		}
		
		override public function configure(skeleton:UserSkeleton):void
		{
			// Call the super.
			super.configure(skeleton);
			
			// Define Left Foot.
			var leftHip:NUIPoint3D = skeleton.leftHip;
			var leftKnee:NUIPoint3D = skeleton.leftKnee;
			var leftFoot:NUIPoint3D = skeleton.leftFoot;
			
			// Define Right Foot.
			var rightFoot:NUIPoint3D = skeleton.rightFoot;
			
			// Define Ranges.
			var leftFootRangeX:Number = (Math.max(leftHip.pointX, leftKnee.pointY, leftFoot.pointX) - Math.min(leftHip.pointX, leftKnee.pointX, leftFoot.pointX));
			var leftFootRangeY:Number = (Math.max(leftHip.pointY, leftKnee.pointY, leftFoot.pointY) - Math.min(leftHip.pointY, leftKnee.pointY, leftFoot.pointY));
			var leftFootRangeZ:Number = (Math.max(leftHip.pointZ, leftKnee.pointZ, leftFoot.pointZ) - Math.min(leftHip.pointZ, leftKnee.pointZ, leftFoot.pointZ));
			var leftFootRange:Number = (leftFootRangeX + leftFootRangeY + leftFootRangeZ)/3;
			
			// Left Foot Sideways.
			if(leftFootRangeY <= leftFootRange && leftFootRangeZ <= leftFootRange
				&& leftFoot.pointX < leftHip.pointX)
			{
				this.distance = (this.useInches) ? NiPoint3DUtil.convertMMToInches(leftFootRangeX) : leftFootRangeX;
				this.dispatchEvent(new FAASTEvent(FAASTEvent.LEFT_FOOT_SIDEWAYS, this.distance));
			}
			
			// Left Foot Forward.
			if(leftFootRangeX <= leftFootRange && leftFootRangeZ >= leftFootRange
				&& leftFoot.pointZ < rightFoot.pointZ)
			{
				var footHeight:Number = Math.abs(leftFoot.pointY-rightFoot.pointY);
				footHeight = (this.useInches) ? NiPoint3DUtil.convertMMToInches(footHeight) : footHeight;
				
				this.distance = (this.useInches) ? NiPoint3DUtil.convertMMToInches(leftFootRangeY) : leftFootRangeY;
				this.dispatchEvent(new FAASTEvent(FAASTEvent.LEFT_FOOT_FORWARD, this.distance, footHeight));
			}
			
			// Left Foot Backward.
			if(leftFootRangeX <= leftFootRange && leftFootRangeZ >= leftFootRange
				&& leftFoot.pointZ > rightFoot.pointZ)
			{
				this.distance = (this.useInches) ? NiPoint3DUtil.convertMMToInches(leftFootRangeY) : leftFootRangeY;
				this.dispatchEvent(new FAASTEvent(FAASTEvent.LEFT_FOOT_BACKWARD, this.distance));
			}
			
			// Left Foot Up.
			if(leftFootRangeX <= leftFootRange && leftFootRangeY <= leftFootRange
				&& leftFoot.pointY > rightFoot.pointY)
			{
				var val:Number = Math.abs(leftFoot.pointZ-rightFoot.pointZ);
				this.distance = (this.useInches) ? NiPoint3DUtil.convertMMToInches(val) : val;
				this.dispatchEvent(new FAASTEvent(FAASTEvent.LEFT_FOOT_UP, this.distance));
			}
		}
	}
}
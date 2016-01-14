package com.as3nui.nativeExtensions.air.kinect.faast.gestures
{
	import com.as3nui.nativeExtensions.air.kinect.faast.events.FAASTEvent;
	import com.as3nui.nativeExtensions.air.kinect.objects.NUIPoint3D;
	import com.as3nui.nativeExtensions.air.kinect.objects.UserSkeleton;
	import com.as3nui.nativeExtensions.air.kinect.unit.math.NiPoint3DUtil;
	import flash.events.EventDispatcher;
	
	

	
	public class FAASTFullBodyGestures extends FAASTBasicGestures
	{
		private var _configHeight:Number;
		
		private var _configLeftFoot:Number;
		private var _configRightFoot:Number;
		private var _configHead:NUIPoint3D;
		private var _configTorso:NUIPoint3D;
		private var _jumpTolerance:Number = 50;//跳躍差
		
		public function FAASTFullBodyGestures(useInches:Boolean = false)
		{
			super(useInches);
		}
		
		override public function configure(skeleton:UserSkeleton):void
		{
			// Call the super.
			super.configure(skeleton);
			
			// Define Feet and Head.
			var leftShoulder:NUIPoint3D = skeleton.leftShoulder;
			var leftFoot:NUIPoint3D = skeleton.leftFoot;
			var leftKnee:NUIPoint3D = skeleton.leftKnee;
			var rightFoot:NUIPoint3D = skeleton.rightFoot;
			var rightKnee:NUIPoint3D = skeleton.rightKnee;
			var rightShoulder:NUIPoint3D = skeleton.rightShoulder;
			var head:NUIPoint3D = skeleton.head;
			var torso:NUIPoint3D = skeleton.torso;
			
			// Define the heights.
			var fullBodyHeight:Number = (Math.max(leftFoot.pointY, rightFoot.pointY, head.pointY) - Math.min(leftFoot.pointY, rightFoot.pointY, head.pointY));
			var torsoHeight:Number = (Math.max(torso.pointY, head.pointY) - Math.min(torso.pointY, head.pointY));
			var topBodyRange:Number = (Math.max(torso.pointZ, leftShoulder.pointZ, rightShoulder.pointZ) - Math.min(torso.pointZ, leftShoulder.pointZ, rightShoulder.pointZ));
			
			// Grab the first recorded full body height.
			if(!_configHeight)
			{
				this._configHeight = fullBodyHeight;
				this._configHead = head;
				this._configTorso = torso;
		        this._configLeftFoot = leftFoot.pointY;
		        this._configRightFoot = rightFoot.pointY;
			}
			
			// Detect if the user is crouching.
			if(fullBodyHeight <= ((this._configHeight/2) + torsoHeight))
			{
				var diffHeight:Number = Math.abs(this._configHeight-fullBodyHeight);
				this.distance = (this.useInches) ? NiPoint3DUtil.convertMMToInches(diffHeight) : diffHeight;
				this.dispatchEvent(new FAASTEvent(FAASTEvent.CROUCHED, this.distance));
			}
			
			// Detect if the user is in the standing position first.
			if(fullBodyHeight >= (this._configHeight - torsoHeight))
			{
				
				// Detect if the user is jumping.
				if(head.pointY >= this._configHead.pointY)
				{
			
				
					var leftFootDis:Number = Math.abs(leftFoot.pointY - this._configLeftFoot);
					var rightFootDis:Number = Math.abs(rightFoot.pointY - this._configRightFoot);
					this._configLeftFoot = leftFoot.pointY;
					this._configRightFoot = rightFoot.pointY;
					
					if(leftFootDis >= this._jumpTolerance && rightFootDis >= this._jumpTolerance)
					{
						var sum:Number = (leftFootDis + rightFootDis)/2;
						this.distance = (this.useInches) ? NiPoint3DUtil.convertMMToInches(sum) : sum;
						this.dispatchEvent(new FAASTEvent(FAASTEvent.JUMPING, this.distance));
					}
				}
			}
			
			// Detect the full body Y-degrees.
			var fullBodyRadiansY:Number = Math.atan2((torso.pointY - this._configTorso.pointY), (torso.pointX - this._configTorso.pointX));
			var fullBodyDegreesY:Number = Math.abs(Math.round(fullBodyRadiansY*180/Math.PI));
			
			// Detect if the user leans left or right.
			if(fullBodyDegreesY < 180)
			{
				if(fullBodyDegreesY < 173 && fullBodyDegreesY > 167)
				{
					this.dispatchEvent(new FAASTEvent(FAASTEvent.LEAN_LEFT, 0, 0, fullBodyDegreesY));
				}
				
				if(fullBodyDegreesY > 5 && fullBodyDegreesY < 35)
				{
					this.dispatchEvent(new FAASTEvent(FAASTEvent.LEAN_RIGHT, 0, 0, fullBodyDegreesY));
				}
			}
			
			// Detect the full body Z-degrees.
			var fullBodyRadiansZ:Number = Math.atan2((torso.pointY - this._configTorso.pointY), (torso.pointZ - this._configTorso.pointZ));
			var fullBodyDegreesZ:Number = Math.abs(Math.round(fullBodyRadiansZ*180/Math.PI));
			
			// Detect if the user leans forward.
			if(torso.pointZ < leftFoot.pointZ && fullBodyDegreesZ < 170
				&& torso.pointZ < rightFoot.pointZ)
			{
				this.dispatchEvent(new FAASTEvent(FAASTEvent.LEAN_FORWARD, 0, 0, fullBodyDegreesZ));
			}
			
			// Detect the head Z-degrees.
			var headRadiansZ:Number = Math.atan2((head.pointY - this._configHead.pointY), (head.pointZ - this._configHead.pointZ));
			var headDegreesZ:Number = Math.abs(Math.round(headRadiansZ*180/Math.PI));
			
			// Detect if the user leans backward.
			if(head.pointZ > leftFoot.pointZ 
				&& headDegreesZ > 10 && headDegreesZ < 35
				&& head.pointZ > rightFoot.pointZ)
			{
				this.dispatchEvent(new FAASTEvent(FAASTEvent.LEAN_BACKWARD, 0, 0, fullBodyDegreesZ));
			}
			
			// Detect the left side X-degrees.
			var leftSideRadians:Number = Math.atan2((leftShoulder.pointY - torso.pointY), (leftShoulder.pointZ - torso.pointZ));
			var leftSideDegrees:Number = Math.abs(Math.round(leftSideRadians*180/Math.PI));
			
			// Detect the right side X-degrees.
			var rightSideRadians:Number = Math.atan2((rightShoulder.pointY - torso.pointY), (rightShoulder.pointZ - torso.pointZ));
			var rightSideDegrees:Number = Math.abs(Math.round(rightSideRadians*180/Math.PI));
			
			// Detect if the user turns left.
			if(leftShoulder.pointZ > torso.pointZ
				&& rightShoulder.pointZ < torso.pointZ
				&& topBodyRange > 75)
			{
				this.dispatchEvent(new FAASTEvent(FAASTEvent.TURN_LEFT, 0, 0, leftSideDegrees));
			}
			
			// Detect if the user turns right.
			if(leftShoulder.pointZ < torso.pointZ
				&& rightShoulder.pointZ > torso.pointZ
				&& topBodyRange > 75)
			{
				this.dispatchEvent(new FAASTEvent(FAASTEvent.TURN_RIGHT, 0, 0, rightSideDegrees));
			}
		}
	}
}
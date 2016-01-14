package com.as3nui.nativeExtensions.air.kinect.objects 
{
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	/**
	 * ...
	 * @author sayaku
	 */
	public class UserSkeleton 
	{
		public var userID:Number;
		public var user:User;
		public var head:NUIPoint3D;
		public var neck:NUIPoint3D;
		public var torso:NUIPoint3D;
		
		public var leftShoulder:NUIPoint3D;
		public var leftElbow:NUIPoint3D;
		public var leftHand:NUIPoint3D;
		
		public var rightShoulder:NUIPoint3D;
		public var rightElbow:NUIPoint3D;
		public var rightHand:NUIPoint3D;
		
		public var leftHip:NUIPoint3D;
		public var leftKnee:NUIPoint3D;
		public var leftFoot:NUIPoint3D;
		
		public var rightHip:NUIPoint3D;
		public var rightKnee:NUIPoint3D;
		public var rightFoot:NUIPoint3D;
		public function UserSkeleton() 
		{
			this.head = new NUIPoint3D();
			this.neck = new NUIPoint3D();
			this.torso = new NUIPoint3D();
			
			this.leftShoulder = new NUIPoint3D();
			this.leftElbow = new NUIPoint3D();
			this.leftHand = new NUIPoint3D();
			
			this.rightShoulder = new NUIPoint3D();
			this.rightElbow = new NUIPoint3D();
			this.rightHand = new NUIPoint3D();
			
			this.leftHip = new NUIPoint3D();
			this.leftKnee = new NUIPoint3D();
			this.leftFoot = new NUIPoint3D();
			
			this.rightHip = new NUIPoint3D();
			this.rightKnee = new NUIPoint3D();
			this.rightFoot = new NUIPoint3D();
		}
		
		public function update(user:User):void
		{
			this.head.pointX = user.head.position.world.x;
			this.head.pointY = user.head.position.world.y;
			this.head.pointZ = user.head.position.world.z;
			
			this.neck.pointX = user.neck.position.world.x;
			this.neck.pointY = user.neck.position.world.y;
			this.neck.pointZ = user.neck.position.world.z;
			
			this.torso.pointX = user.torso.position.world.x;
			this.torso.pointY = user.torso.position.world.y;
			this.torso.pointZ = user.torso.position.world.z;
			
			this.leftShoulder.pointX = user.leftShoulder.position.world.x;
			this.leftShoulder.pointY = user.leftShoulder.position.world.y;
			this.leftShoulder.pointZ = user.leftShoulder.position.world.z;
			
			this.leftElbow.pointX = user.leftElbow.position.world.x;
			this.leftElbow.pointY = user.leftElbow.position.world.y;
			this.leftElbow.pointZ = user.leftElbow.position.world.z;
			
			this.leftHand.pointX = user.leftHand.position.world.x;
			this.leftHand.pointY = user.leftHand.position.world.y;
			this.leftHand.pointZ = user.leftHand.position.world.z;
			
			this.rightShoulder.pointX = user.rightShoulder.position.world.x;
			this.rightShoulder.pointY = user.rightShoulder.position.world.y;
			this.rightShoulder.pointZ = user.rightShoulder.position.world.z;
			
			this.rightElbow.pointX = user.rightElbow.position.world.x;
			this.rightElbow.pointY = user.rightElbow.position.world.y;
			this.rightElbow.pointZ = user.rightElbow.position.world.z;
			
			this.rightHand.pointX = user.rightHand.position.world.x;
			this.rightHand.pointY = user.rightHand.position.world.y;
			this.rightHand.pointZ = user.rightHand.position.world.z;
			
			this.leftHip.pointX = user.leftHip.position.world.x;
			this.leftHip.pointY = user.leftHip.position.world.y;
			this.leftHip.pointZ = user.leftHip.position.world.z;
			
			this.leftKnee.pointX = user.leftKnee.position.world.x;
			this.leftKnee.pointY = user.leftKnee.position.world.y;
			this.leftKnee.pointZ = user.leftKnee.position.world.z;
			
			this.leftFoot.pointX = user.leftFoot.position.world.x;
			this.leftFoot.pointY = user.leftFoot.position.world.y;
			this.leftFoot.pointZ = user.leftFoot.position.world.z;
			
			this.rightHip.pointX = user.rightHip.position.world.x;
			this.rightHip.pointY = user.rightHip.position.world.y;
			this.rightHip.pointZ = user.rightHip.position.world.z;
			
			this.rightKnee.pointX = user.rightKnee.position.world.x;
			this.rightKnee.pointY = user.rightKnee.position.world.y;
			this.rightKnee.pointZ = user.rightKnee.position.world.z;
			
			this.rightFoot.pointX = user.rightFoot.position.world.x;
			this.rightFoot.pointY = user.rightFoot.position.world.y;
			this.rightFoot.pointZ = user.rightFoot.position.world.z;
			
			this.userID = user.userID;
			this.user= user;
		}
		
	}

}
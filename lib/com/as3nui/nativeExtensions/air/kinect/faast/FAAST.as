package com.as3nui.nativeExtensions.air.kinect.faast
{
	import com.as3nui.nativeExtensions.air.kinect.faast.events.FAASTEvent;
	import com.as3nui.nativeExtensions.air.kinect.faast.gestures.FAASTFullBodyGestures;
	import com.as3nui.nativeExtensions.air.kinect.faast.gestures.FAASTLeftArmGestures;
	import com.as3nui.nativeExtensions.air.kinect.faast.gestures.FAASTLeftFootGestures;
	import com.as3nui.nativeExtensions.air.kinect.faast.gestures.FAASTRightArmGestures;
	import com.as3nui.nativeExtensions.air.kinect.faast.gestures.FAASTRightFootGestures;
	import com.as3nui.nativeExtensions.air.kinect.objects.UserSkeleton;
	import flash.events.EventDispatcher;
	

	//import org.as3openni.objects.NiSkeleton;
	
	public class FAAST extends EventDispatcher
	{
		private var _leftArmGestures:FAASTLeftArmGestures;
		private var _rightArmGestures:FAASTRightArmGestures;
		private var _leftFootGestures:FAASTLeftFootGestures;
		private var _rightFootGestures:FAASTRightFootGestures;
		private var _fullBodyGestures:FAASTFullBodyGestures;
		
		private var _leftFootForwardTick:Number = 0;
		private var _leftFootForwardDis:Number = 0;
		private var _rightFootForwardTick:Number = 0;
		private var _rightFootForwardDis:Number = 0;
		
		private var _configHeight:Number;
		private var _fullBodyHeight:Number;
		private var _torsoHeight:Number;
		public var getSkeleton:UserSkeleton;
		
		public function FAAST(useInches:Boolean = false)
		{
			super();
			this.setupFAAST(useInches);
		}
		
		public function configure(skeleton:UserSkeleton):void
		{
			if(skeleton)
			{
				// Get the full body height.
				this._fullBodyHeight = 
				(
					Math.max(skeleton.leftFoot.pointY, skeleton.rightFoot.pointY, skeleton.head.pointY) 
					- Math.min(skeleton.leftFoot.pointY, skeleton.rightFoot.pointY, skeleton.head.pointY)
				);
				
				this._torsoHeight = 
				(
					Math.max(skeleton.torso.pointY, skeleton.head.pointY) 
					- Math.min(skeleton.torso.pointY, skeleton.head.pointY)
				);
				
				// Grab the first recorded full body height.
				if(!this._configHeight)
				{
					this._configHeight = this._fullBodyHeight;
				}
				
				// If the user is standing straight up.
				if(this._configHeight && this._fullBodyHeight)
				{
					if(this._fullBodyHeight >= (this._configHeight - this._torsoHeight))
					{
						this._leftArmGestures.configure(skeleton);
						this._rightArmGestures.configure(skeleton);
						this._leftFootGestures.configure(skeleton);
						this._rightFootGestures.configure(skeleton);
					}
				}
				
				// Global body gestures.
				this._fullBodyGestures.configure(skeleton);
				getSkeleton = skeleton;
			}
		}
		
		protected function setupFAAST(useInches:Boolean = false):void
		{
			// Setup the gestures.
			this._leftArmGestures = new FAASTLeftArmGestures(useInches);
			this._rightArmGestures = new FAASTRightArmGestures(useInches);
			this._leftFootGestures = new FAASTLeftFootGestures(useInches);
			this._rightFootGestures = new FAASTRightFootGestures(useInches);
			this._fullBodyGestures = new FAASTFullBodyGestures(useInches);
			
			// Add listeners.
			this.addCustomListeners();
			this.addUpperBodyListeners();
			this.addLowerBodyListeners();
			this.addFullBodyListeners();	
		}
		
		protected function addLowerBodyListeners():void
		{
			// Left Leg.
			this._leftFootGestures.addEventListener(FAASTEvent.LEFT_FOOT_SIDEWAYS, onFAASTEvent);
			this._leftFootGestures.addEventListener(FAASTEvent.LEFT_FOOT_FORWARD, onFAASTEvent);
			this._leftFootGestures.addEventListener(FAASTEvent.LEFT_FOOT_BACKWARD, onFAASTEvent);
			this._leftFootGestures.addEventListener(FAASTEvent.LEFT_FOOT_UP, onFAASTEvent);
			
			// Right Leg.
			this._rightFootGestures.addEventListener(FAASTEvent.RIGHT_FOOT_SIDEWAYS, onFAASTEvent);
			this._rightFootGestures.addEventListener(FAASTEvent.RIGHT_FOOT_FORWARD, onFAASTEvent);
			this._rightFootGestures.addEventListener(FAASTEvent.RIGHT_FOOT_BACKWARD, onFAASTEvent);
			this._rightFootGestures.addEventListener(FAASTEvent.RIGHT_FOOT_UP, onFAASTEvent);
		}
		
		protected function addUpperBodyListeners():void
		{
			// Left Arm.
			this._leftArmGestures.addEventListener(FAASTEvent.LEFT_ARM_OUT, onFAASTEvent);
			this._leftArmGestures.addEventListener(FAASTEvent.LEFT_ARM_UP, onFAASTEvent);
			this._leftArmGestures.addEventListener(FAASTEvent.LEFT_ARM_DOWN, onFAASTEvent);
			this._leftArmGestures.addEventListener(FAASTEvent.LEFT_ARM_FORWARD, onFAASTEvent);
			this._leftArmGestures.addEventListener(FAASTEvent.LEFT_ARM_ACCROSS, onFAASTEvent);
			
			// Right Arm.
			this._rightArmGestures.addEventListener(FAASTEvent.RIGHT_ARM_OUT, onFAASTEvent);
			this._rightArmGestures.addEventListener(FAASTEvent.RIGHT_ARM_UP, onFAASTEvent);
			this._rightArmGestures.addEventListener(FAASTEvent.RIGHT_ARM_DOWN, onFAASTEvent);
			this._rightArmGestures.addEventListener(FAASTEvent.RIGHT_ARM_FORWARD, onFAASTEvent);
			this._rightArmGestures.addEventListener(FAASTEvent.RIGHT_ARM_ACCROSS, onFAASTEvent);
		}
		
		protected function addFullBodyListeners():void
		{
			this._fullBodyGestures.addEventListener(FAASTEvent.CROUCHED, onFAASTEvent);
			this._fullBodyGestures.addEventListener(FAASTEvent.JUMPING, onFAASTEvent);
			this._fullBodyGestures.addEventListener(FAASTEvent.LEAN_LEFT, onFAASTEvent);
			this._fullBodyGestures.addEventListener(FAASTEvent.LEAN_RIGHT, onFAASTEvent);
			this._fullBodyGestures.addEventListener(FAASTEvent.LEAN_FORWARD, onFAASTEvent);
			this._fullBodyGestures.addEventListener(FAASTEvent.LEAN_BACKWARD, onFAASTEvent);
			this._fullBodyGestures.addEventListener(FAASTEvent.TURN_LEFT, onFAASTEvent);
			this._fullBodyGestures.addEventListener(FAASTEvent.TURN_RIGHT, onFAASTEvent);
		}
		
		protected function addCustomListeners():void
		{
			this._leftFootGestures.addEventListener(FAASTEvent.LEFT_FOOT_FORWARD, onWalkDetection);
			this._rightFootGestures.addEventListener(FAASTEvent.RIGHT_FOOT_FORWARD, onWalkDetection);
		}
		
		protected function onFAASTEvent(event:FAASTEvent):void
		{
			this.dispatchEvent(new FAASTEvent(event.type, event.distance, event.distance2, event.angle, event.bubbles, event.cancelable));
		}
		
		protected function onWalkDetection(event:FAASTEvent):void
		{
			if(this._configHeight && this._fullBodyHeight)
			{
				if(this._fullBodyHeight >= (this._configHeight - this._torsoHeight))
				{
					if(event.type == FAASTEvent.LEFT_FOOT_FORWARD)
					{
						this._leftFootForwardTick = .5;
						this._leftFootForwardDis = event.distance2;
					}
					
					if(event.type == FAASTEvent.RIGHT_FOOT_FORWARD)
					{
						this._rightFootForwardTick = .5;
						this._rightFootForwardDis = event.distance2;
					}
					
					var total:Number = this._leftFootForwardTick + this._rightFootForwardTick;
					if(total == 1 && this._leftFootForwardDis > 0 && this._rightFootForwardDis > 0)
					{
						this.dispatchEvent(new FAASTEvent(FAASTEvent.WALKING, this._leftFootForwardDis, this._rightFootForwardDis));
						this._leftFootForwardDis = 0;
						this._rightFootForwardDis = 0;
					}
				}
			}
		}
	}
}
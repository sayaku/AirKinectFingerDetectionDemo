package com.as3nui.nativeExtensions.air.kinect.faast.gestures
{
	import com.as3nui.nativeExtensions.air.kinect.objects.UserSkeleton;
	import flash.events.EventDispatcher;
	
	//import org.as3openni.objects.NiSkeleton;

	public class FAASTBasicGestures extends EventDispatcher
	{
		public var distance:Number = 0;
		public var useInches:Boolean = false;
		public var skeleton:UserSkeleton;
		
		public function FAASTBasicGestures(useInches:Boolean = false)
		{
			this.useInches = useInches;
		}
		
		public function configure(skeleton:UserSkeleton):void
		{
			this.skeleton = skeleton;
		}
	}
}
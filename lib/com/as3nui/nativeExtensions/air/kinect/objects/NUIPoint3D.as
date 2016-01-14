package com.as3nui.nativeExtensions.air.kinect.objects 
{
	/**
	 * ...
	 * @author sayaku
	 */
	public class NUIPoint3D 
	{
		public var user:Number;
		public var pointX:Number;
		public var pointY:Number;
		public var pointZ:Number;
		public var pointTime:Number;
		public function NUIPoint3D() 
		{
			
		}
		public function toString():String
		{
			var str:String = "id: " + user + 
							 ", x: " + this.pointX + 
							 ", y: " + this.pointY + 
							 ", z: " + this.pointZ;
			return str;
		}
		
	}

}
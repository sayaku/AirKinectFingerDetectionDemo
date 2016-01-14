package com.as3nui.nativeExtensions.air.kinect.extensions.gesture 
{
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Gray Liao
	 */
	public class PositionData extends Object
	{
		public var time:int;
		public var positions:Vector.<Vector3D>;
		public function PositionData() 
		{
			positions = new Vector.<Vector3D>();
		}
		
	}

}
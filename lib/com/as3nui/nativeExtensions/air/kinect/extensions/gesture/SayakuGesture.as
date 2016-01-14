package com.as3nui.nativeExtensions.air.kinect.extensions.gesture 
{
	import com.as3nui.nativeExtensions.air.kinect.faast.events.FAASTEvent;
	import com.as3nui.nativeExtensions.air.kinect.faast.FAAST;
	import flash.events.Event;
	/**
	 * ...
	 * @author sayaku
	 */
	public class SayakuGesture extends FAAST
	{
		private var _isFirst:Boolean=true;
		private var _tolerance:Number = 50 ;
		private var _firstDistance:Number;
		private var _currentDistance:Number;
		private var isRIGHT_ARM_FORWARD:Boolean;
		public function SayakuGesture(useInches:Boolean = false) 
		{
			super(useInches);
	
			
		}
		
	
		
		private function onRender():void 
		{
			
			
			if (isRIGHT_ARM_FORWARD) {
				
				if (_isFirst) {
			    _firstDistance = _currentDistance;
				_isFirst=false;
			   }
				 var dis:Number = _currentDistance-_firstDistance;
				 _firstDistance = _currentDistance;
				  if (dis > _tolerance) {
				    trace(dis);
				    trace("click");
					}
				isRIGHT_ARM_FORWARD = false;	
				return;
				}
				
				
				_isFirst=true;
		}
	
		override protected function onFAASTEvent(event:FAASTEvent):void 
		{
		   
		  super.onFAASTEvent(event);
		  onRender();
			if(event.type==FAASTEvent.RIGHT_ARM_FORWARD){
		        isRIGHT_ARM_FORWARD = true;  
				_currentDistance = event.distance;
			}
			
			
		}
	}

}
package com.as3nui.nativeExtensions.air.kinect.unit.math 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author sayaku
	 */
	public class NiPoint3DUtil 
	{
		
		public function NiPoint3DUtil() 
		{
			
		}
		public static function getAngle(p1:Point, p2:Point):Number {
    
        var x:Number = p2.x-p1.x;
        var y:Number = p2.y-p1.y;
        var hypotenuse:Number = Math.sqrt(Math.pow(x, 2)+Math.pow(y, 2));
       
        var cos:Number = x/hypotenuse;
        var radian:Number = Math.acos(cos);
      
        var angle:Number = 180/(Math.PI/radian);
            
       if (y<0) {
                angle = -angle;
        } else if ((y == 0) && (x<0)) {
                angle = 180;
        }
        return angle;
        }
		
		public static function convertMMToInches(value:Number):Number
		{
			return value * 0.0393700787;
		}
		
	}

}
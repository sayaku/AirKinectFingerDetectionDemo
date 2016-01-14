package com.sayaku.fingerDetction 
{
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.sayaku.Event.KinectFingerEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author sayaku
	 */
	public class KinectFingerDetection extends EventDispatcher 
	{
		public var finger:Vector.<Point>=new <Point>[];//指尖與凹陷處座標
		public var fingerTip:int = 0;//指尖數
		public var k:int = 15;//K曲率的k值
		public var degree:Number = 65;//K曲率偵測角度
		
		public function KinectFingerDetection() 
		{
			super();
		}
		
		public function onFingerDetection(_bmd:BitmapData,hand:Point):BitmapData 
		{
			var vector:Vector.<Point> = new <Point>[];
			var color:uint = _bmd.getPixel(hand.x, hand.y);
			var frect:Rectangle = new Rectangle(0, 0, _bmd.width, _bmd.height);
            var pt:Point = new Point(0, 0);
            //臨界值，num是user調整出來，0~1的值。
            var threshold:uint = extractBlue(color);
            //開一個新的Bitmapdata，先填滿透明色
            var _bitmapDataNew:BitmapData = new BitmapData(_bmd.width, _bmd.height, true, 0x00000000);
            //指定來源，範圍，起始點，運算子小於等於，剛算出的臨界值，符合條件的用白色取代，mask選擇最低位數的B Channel
            _bitmapDataNew.threshold(_bmd, frect, pt, ">=", threshold + 5, 0xff000000, 0x000000FF);
			//先過濾掉比該色階要大的顏色,範圍為5;0xFFE21818
    
			_bitmapDataNew.threshold(_bmd, frect, pt, "<=", threshold - 5, 0xff000000, 0x000000FF);
			//再過濾掉比該色階要小的顏色,範圍為5;
			var newBitmap:Bitmap = new Bitmap();
            newBitmap.bitmapData = _bitmapDataNew;
			 
			//擷取手掌範圍的圖像
			var recbmd:BitmapData = new BitmapData(120, 120, false);//要畫圖片的大小
			var rect:Rectangle = new Rectangle(hand.x-60, hand.y-60, 120, 120);//要在被畫的圖片上的位置與範圍
            var matrix:Matrix = new Matrix();//做一矩陣
			matrix.translate( -rect.x, -rect.y);//運算
			recbmd.draw(newBitmap, matrix);//開始畫
			//模糊去雜訊
			var blur:BlurFilter = new BlurFilter(); 
            blur.blurX = 1.2; 
            blur.blurY = 1.2; 
            blur.quality = BitmapFilterQuality.LOW; 
			recbmd.applyFilter( recbmd,  recbmd.rect, new Point(), blur);
			
			//影像二極化
			recbmd.threshold( recbmd,  recbmd.rect, new Point(), ">", 0xff000000, 0xffffffff, 0x000000FF);
			var newRec:Rectangle = recbmd.getColorBoundsRect(0xFFFFFF, 0xFFFFFF, true);
			var _maxW:int = newRec.x + newRec.width;
		    var _maxH:int = newRec.y + newRec.height;
		    //var maxYPoint:Array=[];
			var maxYPoint:Point;
			var centerPoint:Point = new Point(_maxW * .5, _maxH * .5);
		    var bmd:BitmapData = new BitmapData(120 ,120, false, 0);
	        
	        //取出輪廓線
			for (var i:int = newRec.x; i < _maxW; i++ ) {
				for (var j:int = newRec.y; j < _maxH; j++ ) {
				
					if (recbmd.getPixel(i, j) == 0xFFFFFF)
					{
						if (recbmd.getPixel(i, j - 1) != 0xFFFFFF ||
						    recbmd.getPixel(i + 1, j) != 0xFFFFFF ||
							recbmd.getPixel(i, j + 1) != 0xFFFFFF ||
							recbmd.getPixel(i - 1, j) != 0xFFFFFF 
						)
						{
						if (j + 1 == int(centerPoint.y + centerPoint.y * .8)) { 
							//maxYPoint.push({p:new Point(i + 1, j + 1),tolerance:Math.abs(i + 1-centerPoint.x)});
							maxYPoint = new Point(i + 1, j + 1);
							}	
					    vector.push(new Point(i+1 , j+1 ));
						bmd.setPixel(i + 1, j + 1  , 0xFFFFFF);
						}
					}
				}
			}
			//if(maxYPoint[0] == null)return bmd;
			//maxYPoint.sortOn("tolerance", Array.NUMERIC);
			//輪廓線pixel順時針排序
			//var vector2:Vector.<Point> = clockwiseOrder(maxYPoint[0].p, vector.length, bmd);
			var vector2:Vector.<Point> = clockwiseOrder(maxYPoint, vector.length, bmd);
			//指尖偵測
			finger = fingerDetection(vector2);
			if (finger == null) return bmd;
			switch(finger.length) {
				case 1:fingerTip = 1;
				       this.dispatchEvent(new KinectFingerEvent(KinectFingerEvent.HAND_OPEN,finger, fingerTip, true));
				       break;
				case 3:fingerTip = 2;
				       this.dispatchEvent(new KinectFingerEvent(KinectFingerEvent.HAND_OPEN,finger, fingerTip, true));
				       break;
				case 5:fingerTip = 3;
				       this.dispatchEvent(new KinectFingerEvent(KinectFingerEvent.HAND_OPEN,finger, fingerTip, true));
				       break;	   
				case 7:fingerTip = 4;
				       this.dispatchEvent(new KinectFingerEvent(KinectFingerEvent.HAND_OPEN,finger, fingerTip, true));
				       break;
			    case 9:fingerTip = 5;
				       this.dispatchEvent(new KinectFingerEvent(KinectFingerEvent.HAND_OPEN, finger ,fingerTip, true));
				       break;
				case 0:fingerTip = 0;
				       this.dispatchEvent(new KinectFingerEvent(KinectFingerEvent.HAND_CLOSE,finger ,fingerTip, true));
				       break;
				}
			return bmd;
		}
		
		//取出藍色色板
		private function extractBlue(c:uint):uint {
                return ( c & 0xFF );
            }
			
		private function clockwiseOrder(contourStartPoint:Point,contourPointlength:int,bmd:BitmapData):Vector.<Point> {
			var vector:Vector.<Point> = new <Point>[];
			var prePointX:int;
			var prePointY:int;
			var prePointX2:int;
			var prePointY2:int;
			var id:Boolean = false;
			vector.push(contourStartPoint);
			//優先判別距離為1的pixel再判別剩下pixel
			for (var i:int = 0; i < contourPointlength; i++)
			{
				if (i>vector.length-1||vector[i]==null ) break;
				if (bmd.getPixel(vector[i].x , vector[i].y - 1) == 0xFFFFFF) {
					//(i,i-1) 上中
					  /*
					  * ┌───┬───┬───┐
					  * │   │ X │   │
					  * ├───┼───┼───┤
					  * │   │ i │   │
					  * ├───┼───┼───┤
					  * │   │   │   │
					  * └───┴───┴───┘
					  * 
					  * */
					 // id為判別是否跑第一次迴圈
					  if (id) {
						  
						
						   if ((vector[i].x == prePointX && vector[i].y - 1 == prePointY)|| (vector[i].x == prePointX2 && vector[i].y - 1 == prePointY2) )
						  {
						  }else{
						    vector.push(new Point(vector[i].x, vector[i].y - 1));
							prePointX2 = prePointX;
							prePointY2 = prePointY;
							prePointX = vector[i].x;
			                prePointY = vector[i].y;
						
							continue;
						  }
						
					  }else {
							vector.push(new Point(vector[i].x, vector[i].y - 1));
						    prePointX = vector[i].x;
			                prePointY = vector[i].y;
						    prePointX2 = vector[i].x;
							prePointY2 = vector[i].y;
							id = true;
							continue;
					  }
					          
					}
					if (bmd.getPixel(vector[i].x + 1, vector[i].y ) == 0xFFFFFF) {
					//(i+1,i)中右
					  /*
					  * ┌───┬───┬───┐
					  * │   │   │   │
					  * ├───┼───┼───┤
					  * │   │ i │ X │
					  * ├───┼───┼───┤
					  * │   │   │   │
					  * └───┴───┴───┘
					  * 
					  * */
					      if (id) {
						  if ((vector[i].x+1 == prePointX && vector[i].y  == prePointY)||(vector[i].x+1 == prePointX2 && vector[i].y  == prePointY2) )
						  {
						  }else{
						    vector.push(new Point(vector[i].x+1, vector[i].y ));
						    prePointX2 = prePointX;
							prePointY2 = prePointY;
							prePointX = vector[i].x;
			                prePointY = vector[i].y;
							continue;
						  }
						  }else {
							vector.push(new Point(vector[i].x+1, vector[i].y ));
						    prePointX2 = vector[i].x;
							prePointY2 = vector[i].y;
							prePointX = vector[i].x;
			                prePointY = vector[i].y;
						
							id = true;
							continue;
							  }
					         
					}
				if (bmd.getPixel(vector[i].x, vector[i].y + 1) == 0xFFFFFF) {
					//(i,i+1)下中
					 /*
					  * ┌───┬───┬───┐
					  * │   │   │   │
					  * ├───┼───┼───┤
					  * │   │ i │   │
					  * ├───┼───┼───┤
					  * │   │ X │   │
					  * └───┴───┴───┘
					  * 
					  * */
					 if (id) {
						 if((vector[i].x == prePointX && vector[i].y + 1 == prePointY)||(vector[i].x == prePointX2 && vector[i].y + 1 == prePointY2) )
						  {
						  }else{
						    vector.push(new Point(vector[i].x, vector[i].y+1 ));
						    prePointX2 = prePointX;
							prePointY2 = prePointY;
							prePointX = vector[i].x;
			                prePointY = vector[i].y;
							continue;
						  }
						  }else {
							vector.push(new Point(vector[i].x, vector[i].y+1 ));
					        prePointX = vector[i].x;
			                prePointY = vector[i].y;
						   prePointX2 = vector[i].x;
							prePointY2 = vector[i].y;
							id = true;
							continue;
							  }
					          
					}
				if (bmd.getPixel(vector[i].x - 1, vector[i].y ) == 0xFFFFFF) {
					//(i-1,i) 中左
					  /*
					  * ┌───┬───┬───┐
					  * │   │   │   │
					  * ├───┼───┼───┤
					  * │ X │ i │   │
					  * ├───┼───┼───┤
					  * │   │   │   │
					  * └───┴───┴───┘
					  * 
					  * */
					  
					        if (id) {
						 if ((vector[i].x-1 == prePointX && vector[i].y  == prePointY)|| (vector[i].x-1 == prePointX2 && vector[i].y  == prePointY2))
						  {
						  }else{
						    vector.push(new Point(vector[i].x-1, vector[i].y ));
					        prePointX2 = prePointX;
							prePointY2 = prePointY;
							prePointX = vector[i].x;
			                prePointY = vector[i].y;
							continue;
						  }
						  }else {
							vector.push(new Point(vector[i].x-1, vector[i].y ));
					        prePointX = vector[i].x;
			                prePointY = vector[i].y;
					        prePointX2 = vector[i].x;
							prePointY2 = vector[i].y;
							id = true;
							continue;
							  }
					}
					
				if (bmd.getPixel(vector[i].x - 1, vector[i].y - 1) == 0xFFFFFF) {
					//(i-1,i-1) 上左
					  /*
					  * ┌───┬───┬───┐
					  * │ X │   │   │
					  * ├───┼───┼───┤
					  * │   │ i │   │
					  * ├───┼───┼───┤
					  * │   │   │   │
					  * └───┴───┴───┘
					  * 
					  * */
					     
					        if (id) {
						  if ((vector[i].x-1 == prePointX && vector[i].y - 1 == prePointY) ||(vector[i].x-1 == prePointX2 && vector[i].y - 1 == prePointY2))
						
						  {
						  }else{
						    vector.push(new Point(vector[i].x-1, vector[i].y-1 ));
					        prePointX2 = prePointX;
							prePointY2 = prePointY;
							prePointX = vector[i].x;
			                prePointY = vector[i].y;
							continue;
						  }
						  }else {
							vector.push(new Point(vector[i].x-1, vector[i].y-1 ));
						    prePointX = vector[i].x;
			                prePointY = vector[i].y;
						    prePointX2 = vector[i].x;
							prePointY2 = vector[i].y;
							id = true;
							continue;
							  } 
					}
					
				if (bmd.getPixel(vector[i].x + 1, vector[i].y - 1) == 0xFFFFFF) {
					//(i+1,i-1) 上右
					 /*
					  * ┌───┬───┬───┐
					  * │   │   │ X │
					  * ├───┼───┼───┤
					  * │   │ i │   │
					  * ├───┼───┼───┤
					  * │   │   │   │
					  * └───┴───┴───┘
					  * 
					  * */
					       
					        if (id) {
						 if ((vector[i].x+1 == prePointX && vector[i].y - 1 == prePointY)|| (vector[i].x+1 == prePointX2 && vector[i].y - 1 == prePointY2))
						
						  {
						  }else{
						    vector.push(new Point(vector[i].x+1, vector[i].y-1 ));
						    prePointX2 = prePointX;
							prePointY2 = prePointY;
							prePointX = vector[i].x;
			                prePointY = vector[i].y;
							continue;
						  }
						  }else {
							vector.push(new Point(vector[i].x+1, vector[i].y-1 ));
					        prePointX = vector[i].x;
			                prePointY = vector[i].y;
						    prePointX2 = vector[i].x;
							prePointY2 = vector[i].y;
							id = true;
							continue;
							  }
					          
					}	
					if (bmd.getPixel(vector[i].x + 1, vector[i].y + 1) == 0xFFFFFF) {
					//(i+1,i+1)下右
					  /*
					  * ┌───┬───┬───┐
					  * │   │   │   │
					  * ├───┼───┼───┤
					  * │   │ i │   │
					  * ├───┼───┼───┤
					  * │   │   │ X │
					  * └───┴───┴───┘
					  * 
					  * */
					       if (id) {
						  if ((vector[i].x+1 == prePointX && vector[i].y +1 == prePointY)|| (vector[i].x+1 == prePointX2 && vector[i].y +1 == prePointY2))
						
						  {
						  }else{
						    vector.push(new Point(vector[i].x+1, vector[i].y+1 ));
						    prePointX2 = prePointX;
							prePointY2 = prePointY;
							prePointX = vector[i].x;
			                prePointY = vector[i].y;
							continue;
						  }
						  }else {
							vector.push(new Point(vector[i].x+1, vector[i].y+1 ));
				            prePointX = vector[i].x;
			                prePointY = vector[i].y;
						    prePointX2 = vector[i].x;
							prePointY2 = vector[i].y;
							id = true;
							continue;
							  }
					          
					}
				if (bmd.getPixel(vector[i].x - 1, vector[i].y + 1) == 0xFFFFFF) {
					 //(i-1,i+1)下左
					 /*
					  * ┌───┬───┬───┐
					  * │   │   │   │   
					  * ├───┼───┼───┤
					  * │   │ i │   │
					  * ├───┼───┼───┤
					  * │ X │   │   │
					  * └───┴───┴───┘
					  * 
					  * */   
					        if (id) {
						 if ((vector[i].x-1 == prePointX && vector[i].y + 1 == prePointY) ||(vector[i].x-1 == prePointX2 && vector[i].y + 1 == prePointY2))
						
						  {
						  }else{
						    vector.push(new Point(vector[i].x-1, vector[i].y+1 ));
						    prePointX2 = prePointX;
							prePointY2 = prePointY;
							prePointX = vector[i].x;
			                prePointY = vector[i].y;
							continue;
						  }
						  }else {
							vector.push(new Point(vector[i].x-1, vector[i].y+1 ));
						    prePointX = vector[i].x;
			                prePointY = vector[i].y;
						    prePointX2 = vector[i].x;
							prePointY2 = vector[i].y;
							id = true;
							continue;
							  }
					    }
				}//for end
				
				return vector;
			}	
			
			private function fingerDetection(vec:Vector.<Point>):Vector.<Point>
		{
			//k-curvature演算法
			var lng:int = vec.length;
			var index:int = 0;
			var fingertip:Vector.<Point> = new <Point>[];
			var arr:Array = [];
			for (var i:int = k; i < lng; i+=1)
			{
				if (i + k > lng - 1) break;
				if (i - k < 0) continue;
				var kp:Point = vec[i + k];
				var km:Point = vec[i - k];
				
				var v1:Point = new Point(vec[i + k].x-vec[i].x,vec[i + k].y-vec[i].y);
				var v2:Point = new Point(vec[i - k].x-vec[i].x,vec[i - k].y-vec[i].y);
				var dp:Number = v1.x * v2.x + v1.y * v2.y;
				var cosAngle:Number = dp / (v1.length * v2.length);
				
				if (Math.acos(cosAngle) * 180 / Math.PI < degree) {
				  
					arr.push(new Point(vec[i].x, vec[i].y));
				
				}else {
					if (arr.length >= 1) {
						fingertip.push(arr[int(arr.length * .5)]);
						arr.length = 0;
						}
					}	
			}
			return fingertip;
		}
		
	}

}
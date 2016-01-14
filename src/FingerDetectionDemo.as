package 
{
	import com.as3nui.nativeExtensions.air.kinect.constants.CameraResolution;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.UserEvent;
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import com.sayaku.Event.KinectFingerEvent;
	import com.sayaku.fingerDetction.KinectFingerDetection;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author sayaku
	 */
	public class FingerDetectionDemo extends Sprite 
	{
		private var openCloseText:TextField;//顯示現在是Open/Close狀態文字框
		private var fingerTipText:TextField;//顯示手指個數
		private var kfd:KinectFingerDetection;//手指辨識
		private var device:Kinect;//kinect
		private var rgbImg:Bitmap;//色彩影像
		private var depImg:Bitmap;//深度影像
		private var dotSp:Sprite;//裝偵測點的容器
		private var user:User;//使用者骨架
		private var rightHand:Point;//使用者的右手關節座標
		public function FingerDetectionDemo():void 
		{
			initUI();//初始化介面
			initKinect();//初始化Kinect
			initListener();//初始化偵聽事件
		}
		
		private function initUI():void 
		{
			rgbImg = new Bitmap();
			depImg = new Bitmap();
			dotSp = new Sprite();
			depImg.x = -500;//一開始讓他看不見
			addChild(rgbImg);
			addChild(depImg);
			addChild(dotSp);
			kfd = new KinectFingerDetection();//初始化手指偵測
			rightHand = new Point();
			openCloseText = new TextField();
			openCloseText.textColor = 0xF20F0F;
			openCloseText.scaleX = openCloseText.scaleY = 5;
			openCloseText.text = "none";
			addChild(openCloseText);
			openCloseText.y = 480;
			
			fingerTipText = new TextField();
			fingerTipText.textColor = 0xF20F0F;
			fingerTipText.scaleX = fingerTipText.scaleY = 5;
			fingerTipText.text = "0";
			addChild(fingerTipText);
			fingerTipText.y = 480;
			fingerTipText.x = 300;
		}
		
		private function initKinect():void 
		{
			if (Kinect.isSupported()) {
				//實體化
				device = Kinect.getDevice();
				//設置KINECT參數
				var settings:KinectSettings = new KinectSettings();
				settings.skeletonEnabled = true;
				settings.depthEnabled = true;
				settings.rgbEnabled = true;
				settings.nearModeEnabled = true;
				settings.depthResolution = CameraResolution.RESOLUTION_640_480;
				settings.depthShowUserColors = false;//取消人體輪廓上色,節省效能
				device.start(settings);
				}
		}
		
		private function initListener():void 
		{
			device.addEventListener(DeviceEvent.STARTED, deviceStart);//偵測Kinect裝置啟動時
			device.addEventListener(UserEvent.USERS_WITH_SKELETON_ADDED, skeletonsAddedHandler);
			device.addEventListener(UserEvent.USERS_WITH_SKELETON_REMOVED, skeletonsRemovedHandler);
			device.addEventListener(CameraImageEvent.DEPTH_IMAGE_UPDATE, onDepthImageUpdate);
			device.addEventListener(CameraImageEvent.RGB_IMAGE_UPDATE, onRGBImageUpdate);
			this.addEventListener(Event.ENTER_FRAME, onRender);
			kfd.addEventListener(KinectFingerEvent.HAND_OPEN, onkinectOpen);
			kfd.addEventListener(KinectFingerEvent.HAND_CLOSE, onkinectClose);
		}
		
		//Kinect啟動時執行
		private function deviceStart(e:DeviceEvent):void 
		{
			if(device.capabilities.hasCameraElevationSupport) {
	           device.cameraElevationAngle = 10;//kinect往上移10度
			}
		}
		//當偵測到骨架時執行
		private function skeletonsAddedHandler(e:UserEvent):void 
		{
			for each(var addedUser:User in e.users)
			{
				user = addedUser;
				}
		}
		
		private function skeletonsRemovedHandler(e:UserEvent):void 
		{
			
		}
		
		//更新深度影像
		private function onDepthImageUpdate(e:CameraImageEvent):void 
		{
			depImg.bitmapData = kfd.onFingerDetection(e.imageData, rightHand);
			//指尖辨識,參數1:深度影像,參數二:要辨識手指指尖的關節座標,回傳輪廓影像的bitmapData
			
		}
		
		//更新RGB影像
		private function onRGBImageUpdate(e:CameraImageEvent):void 
		{
			rgbImg.bitmapData = e.imageData;
		}
		
		//更新
		private function onRender(e:Event):void 
		{
			if (user) {
				rightHand.x=user.rightHand.position.depth.x;
				rightHand.y = user.rightHand.position.depth.y;
				depImg.x = rightHand.x - depImg.width * .5;
				depImg.y = rightHand.y - depImg.height * .5;
				}
		}
		
		//當手掌為Close時發生的事件
		private function onkinectClose(e:KinectFingerEvent):void 
		{
			openCloseText.text = "Close";
			fingerTipText.text = String(e.fingertipNum);
			dotSp.graphics.clear();
		}
		
		//當手掌為Open時發生的事件
		private function onkinectOpen(e:KinectFingerEvent):void 
		{
			openCloseText.text = "Open";
			fingerTipText.text = String(e.fingertipNum);
			dotSp.graphics.clear();
			for (var i:int = 0; i < e.fingerPoint.length; i++)
			{	
				if (e.fingerPoint[i] == null) break;
				dotSp.graphics.beginFill(0xDB0000);
		        dotSp.graphics.drawCircle(e.fingerPoint[i].x+depImg.x, e.fingerPoint[i].y+depImg.y, 5);
		        dotSp.graphics.endFill();
				}
		}
	}
	
}
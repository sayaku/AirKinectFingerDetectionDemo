package com.as3nui.nativeExtensions.air.kinect.extensions.events{
	import flash.events.Event;
	
	/**
	 * 使用 KinectCursor 與 KinectButton 時會觸發的事件。CursorEvent 有：CursorEvent.SELECTED。
	 */
	public class CursorEvent extends Event {
		/**
		 * 定義 cursorSelected 事件物件的 type 屬性值。
		 * 
		 * @eventType cursorSelected
		 */
		static public const SELECTED:String = "cursorSelected";
		
		private var _type:String;
		private var _bubbles:Boolean;
		private var _cancelable:Boolean;
		private var _value:Number;
		
		/**
		 * 建立 CursorEvent 物件，以當作參數傳遞至事件偵聽程式。
		 * 
		 * @param	type
		 * 事件類型。事件偵聽程式可以透過繼承的 type 屬性來存取此資訊。可能的值包括： CursorEvent.SELECTED 。
		 * @param	bubbles
		 * 判斷 Event 物件是否參與事件流程的反昇階段。事件偵聽程式可以透過繼承的 bubbles 屬性來存取此資訊。
		 * @param	cancelable
		 * 判斷是否可以取消 Event 物件。事件偵聽程式可以透過繼承的 cancelable 屬性來存取此資訊。
		 */
		public function CursorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			_type=type;
			_bubbles=bubbles;
			_cancelable=cancelable;
			super(type,bubbles,cancelable);
		}
		
		/**
		 * Component 值。
		 */
		public function get value():Number{
			return _value;
		}
		
		public function set value(v:Number):void{
			_value = v;
		}
		
		/**
		 * 傳回包含 CursorEvent 物件所有屬性的字串。
		 * 
		 * @return
		 * 包含 CursorEvent 物件所有屬性的字串。
		 */
		override public function toString():String{
			return formatToString("CursorEvent", "type", "bubbles", "cancelable", "eventPhase", "value");
		}
		
		/**
		 * 建立 CursorEvent 物件的副本，並將每個屬性的值設為符合原始物件的屬性值。
		 * 
		 * @return
		 * 新的 CursorEvent 物件，其屬性值符合原始物件的屬性值。
		 */
		override public function clone():Event{
			var tmpEvt:CursorEvent=new CursorEvent(_type, _bubbles, _cancelable);
			tmpEvt._type=_type;
			tmpEvt._bubbles=_bubbles;
			tmpEvt._cancelable=_cancelable;
			tmpEvt._value=_value;
			return tmpEvt;
		}
	}
}
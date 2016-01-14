package com.as3nui.nativeExtensions.air.kinect.extensions.display 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Gray Liao
	 */
	public class CursorManager extends Object 
	{
		/**
		 * @private
		 *
		 */
		
		protected static var _canInit:Boolean = false;
		/**
		 * @private
		 *
		 */
		protected static var _instance:CursorManager;
		
		private var _cursors:Vector.<KinectCursor>;
		private var _buttons:Vector.<KinectButton>;
		private var _timer:Timer;
		
		public function CursorManager() 
		{
			if (_canInit == false) 
			{
				throw new Error("CursorManager is an singleton and cannot be instantiated.");
			}
			_cursors = new <KinectCursor>[];
			_buttons = new <KinectButton>[];
			_timer = new Timer(33);
			
		}
		
		//Public API
		
		public static function addCursor(cursor:KinectCursor):void
		{
			getInstance().addCursor(cursor);
		}
		
		public static function removeCursor(cursor:KinectCursor):void
		{
			getInstance().removeCursor(cursor);
		}
		
		public static function addButton(button:KinectButton):void
		{
			getInstance().addButton(button);
		}
		
		public static function removeButton(button:KinectButton):void
		{
			getInstance().removeButton(button);
		}
		
		//Protected methods
		
		/**
		 * @private
		 *
		 */
		protected function addCursor(cursor:KinectCursor):void
		{
			var index:int = _cursors.indexOf(cursor);
			if (index < 0)
			{
				_cursors.push(cursor);
			}
			checkForStarting();
		}
		
		/**
		 * @private
		 *
		 */
		protected function removeCursor(cursor:KinectCursor):void
		{
			var index:int = _cursors.indexOf(cursor);
			if (index > -1)
			{
				_cursors.splice(index, 1);
			}
			checkForStopping();
		}
		
		/**
		 * @private
		 *
		 */
		protected function addButton(button:KinectButton):void
		{
			var index:int = _buttons.indexOf(button);
			if (index < 0)
			{
				_buttons.push(button);
			}
			checkForStarting();
		}
		
		/**
		 * @private
		 *
		 */
		protected function removeButton(button:KinectButton):void
		{
			var index:int = _buttons.indexOf(button);
			if (index > -1)
			{
				_buttons.splice(index, 1);
			}
			checkForStopping();
		}
		
		/**
		 * @private
		 *
		 */
		protected function checkForStarting():void
		{
			if (_cursors.length > 0 && _buttons.length > 0 && !_timer.running)
			{
				_timer.start();
				_timer.addEventListener(TimerEvent.TIMER, loop);
			}
		}
		
		/**
		 * @private
		 *
		 */
		protected function checkForStopping():void
		{
			if ((_cursors.length == 0 || _buttons.length == 0) && _timer.running)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, loop);
			}
		}
		
		/**
		 * @private
		 *
		 */
		protected function loop(e:TimerEvent):void
		{
			var cursorsLength:int = _cursors.length;
			var buttonsLength:int = _buttons.length;
			var i:int;
			var j:int;
			var isHitted:Boolean;
			if (cursorsLength > 0 && buttonsLength > 0)
			{
				for (i = 0; i < cursorsLength; i++)
				{
					isHitted = false;
					for (j = 0; j < buttonsLength; j++)
					{
						if (_buttons[j].state != KinectButton.STATE_SELECTED)
						{
							if (_buttons[j].hitTestPoint(_cursors[i].x, _cursors[i].y))
							{
								if (_buttons[j].state != KinectButton.STATE_HOVER)
								{
									_buttons[j].state = KinectButton.STATE_HOVER;
									_buttons[j].atHover();
									_cursors[i].startHolding();
									_cursors[i].holdingButton = _buttons[j];
								}
								isHitted = true;
							}else {
								if (_buttons[j].state != KinectButton.STATE_NORMAL)
								{
									_buttons[j].state = KinectButton.STATE_NORMAL;
									_buttons[j].atNormal();
								}
							}
						}
					}
					if (!isHitted && _cursors[i].isHolding)
					{
						_cursors[i].stopHolding();
						_cursors[i].holdingButton = null;
					}
				}
			}else {
				
			}
			
			for (i = 0; i < cursorsLength; i++)
			{
				if (_cursors[i].isTracking)
				{
					_cursors[i].updatePosition();
				}
				if (_cursors[i].isHolding)
				{
					_cursors[i].updateHolding();
				}
			}
		}
		
		
		/**
		 * @private
		 *
		 */
		protected static function getInstance():CursorManager {
			if (_instance == null) {
				_canInit = true;
				_instance = new CursorManager();
				_canInit = false;
			}
			return _instance;
		}
	}

}
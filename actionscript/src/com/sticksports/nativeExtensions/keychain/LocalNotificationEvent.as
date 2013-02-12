package com.sticksports.nativeExtensions.keychain
{
	import flash.events.Event;
	
	public class LocalNotificationEvent extends Event
	{

		public static const LAUNCHED_BY_NOTIFICATION:String = "LAUNCHED_BY_NOTIFICATION";
		public static const RETURNED_FROM_BKG_BY_NOTIFICATION:String = "RETURNED_FROM_BKG_BY_NOTIFICATION";
	
		// json encoded string (if any)
		public var data:String;
		
		public function LocalNotificationEvent(type:String, data:String = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
	}
}
package com.sticksports.nativeExtensions.keychain
{
	import flash.external.ExtensionContext;
	import flash.events.StatusEvent;
	import flash.events.EventDispatcher;

	public class Keychain
	{
		private static var extensionContext: ExtensionContext;
		private static var _twitterCallback: Function;
		private static var _eventDispacther: EventDispatcher = new EventDispatcher();;

		private static function initInternal() : void
		{
			if ( !extensionContext )
			{
				extensionContext = ExtensionContext.createExtensionContext( "com.sticksports.nativeExtensions.Keychain", null );
				extensionContext.addEventListener(StatusEvent.STATUS, onStatus);				
			}
		}

		public static function init():void {
			initInternal();
			extensionContext.call("initExtension");
		}

		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_eventDispacther.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public static function get( key : String, kSecAttrAccessibleType:String, accessGroup : String = null ) : String
		{
			initInternal();
			if( accessGroup )
			{
				return extensionContext.call( NativeMethods.fetchString, key, kSecAttrAccessibleType, accessGroup ) as String;
			}
			else
			{
				return extensionContext.call( NativeMethods.fetchString, key, kSecAttrAccessibleType ) as String;
			}
		}

		public static function insert( key : String, value : String, kSecAttrAccessibleType:String, accessGroup : String = null ) : int
		{
			initInternal();
			if( accessGroup )
			{
				return extensionContext.call( NativeMethods.insertString, key, value, kSecAttrAccessibleType, accessGroup ) as int;
			}
			else
			{
				return extensionContext.call( NativeMethods.insertString, key, value, kSecAttrAccessibleType ) as int;
			}
		}

		public static function update( key : String, value : String, kSecAttrAccessibleType:String, accessGroup : String = null ) : int
		{
			initInternal();
			if( accessGroup )
			{
				return extensionContext.call( NativeMethods.updateString, key, value, kSecAttrAccessibleType, accessGroup ) as int;
			}
			else
			{
				return extensionContext.call( NativeMethods.updateString, key, value, kSecAttrAccessibleType ) as int;
			}
		}

		public static function insertOrUpdate( key : String, value : String, kSecAttrAccessibleType:String, accessGroup : String = null ) : int
		{
			initInternal();
			if( accessGroup )
			{
				return extensionContext.call( NativeMethods.insertOrUpdateString, key, value, kSecAttrAccessibleType, accessGroup ) as int;
			}
			else
			{
				return extensionContext.call( NativeMethods.insertOrUpdateString, key, value, kSecAttrAccessibleType ) as int;
			}
		}

		public static function remove( key : String, kSecAttrAccessibleType:String, accessGroup : String = null ) : int
		{
			initInternal();
			if( accessGroup )
			{
				return extensionContext.call( NativeMethods.deleteString, key, kSecAttrAccessibleType, accessGroup ) as int;
			}
			else
			{
				return extensionContext.call( NativeMethods.deleteString, key, kSecAttrAccessibleType ) as int;
			}
		}
		
		public static function getUserLanguageAndLocale() : String
		{
			initInternal();
			return extensionContext.call("getUserLanguageAndLocale") as String;
		}
		
		public static function mobileAppTrackerInitialize(advertiserId:String, appKey:String, userId:String) : String
		{
			initInternal();
			return extensionContext.call("mobileAppTrackerInitialize", advertiserId, appKey, userId) as String;
		}
		
		public static function mobileAppTrackerTrackInstall() : int
		{
			initInternal();
			extensionContext.call("mobileAppTrackerTrackInstall");
			
			return 1;
		}
		public static function mobileAppTrackerTrackUpdate() : int
		{
			initInternal();
			extensionContext.call("mobileAppTrackerTrackUpdate");
			
			return 1;
		}
		public static function mobileAppTrackerTrackOpen() : int
		{
			initInternal();
			extensionContext.call("mobileAppTrackerTrackOpen");
			
			return 1;
		}
		public static function mobileAppTrackerTrackClose() : int
		{
			initInternal();
			extensionContext.call("mobileAppTrackerTrackClose");
			
			return 1;
		}
		
		public static function mobileAppTrackerTrackInAppPurchase(localizedTitle:String, currencyCode:String, unitPrice:Number, quantity:int, extraRevenue:Number, transactionIdentifier:String, isSuccess:Boolean) : int
		{
			initInternal();
			extensionContext.call("mobileAppTrackerTrackInAppPurchase", localizedTitle, currencyCode, unitPrice, quantity, extraRevenue, transactionIdentifier, isSuccess);
			
			return 1;
		}

		public static function sendTweet( message : String, cb : Function) : void
		{
			initInternal();
			_twitterCallback = cb;
			extensionContext.call("sendTweet", message);
		}

		public static function canSendTweet() : Boolean
		{
			initInternal();
			return extensionContext.call("canSendTweet") as Boolean;
		}

		private static function onStatus( event : StatusEvent ) : void
		{
			if (event.code.indexOf("CANCEL") != -1)
			{
				_twitterCallback("CANCEL");
			}
			else if (event.code == "DONE")
			{
				_twitterCallback("DONE");
			}
			else if (event.code == "LAUNCHED_BY_NOTIFICATION")
			{
				_eventDispacther.dispatchEvent(new LocalNotificationEvent(LocalNotificationEvent.LAUNCHED_BY_NOTIFICATION));
			}
			else if (event.code == "RETURNED_FROM_BKG_BY_NOTIFICATION")
			{
				_eventDispacther.dispatchEvent(new LocalNotificationEvent(LocalNotificationEvent.RETURNED_FROM_BKG_BY_NOTIFICATION));
			}
		}		
	}
}
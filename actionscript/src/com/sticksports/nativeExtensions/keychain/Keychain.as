package com.sticksports.nativeExtensions.keychain
{
	import flash.external.ExtensionContext;

	public class Keychain
	{
		private static var extensionContext : ExtensionContext;
		
		private static function init() : void
		{
			if ( !extensionContext )
			{
				extensionContext = ExtensionContext.createExtensionContext( "com.sticksports.nativeExtensions.Keychain", null );
			}
		}

		public static function get( key : String, kSecAttrAccessibleType:String, accessGroup : String = null ) : String
		{
			init();
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
			init();
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
			init();
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
			init();
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
			init();
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
			init();
			return extensionContext.call("getUserLanguageAndLocale") as String;
		}
		
		public static function mobileAppTrackerInitialize(advertiserId:String, appKey:String, userId:String) : String
		{
			init();
			return extensionContext.call("mobileAppTrackerInitialize", advertiserId, appKey, userId) as String;
		}
		
		public static function mobileAppTrackerTrackInstall() : int
		{
			init();
			extensionContext.call("mobileAppTrackerTrackInstall");
			
			return 1;
		}
		public static function mobileAppTrackerTrackUpdate() : int
		{
			init();
			extensionContext.call("mobileAppTrackerTrackUpdate");
			
			return 1;
		}
		public static function mobileAppTrackerTrackOpen() : int
		{
			init();
			extensionContext.call("mobileAppTrackerTrackOpen");
			
			return 1;
		}
		public static function mobileAppTrackerTrackClose() : int
		{
			init();
			extensionContext.call("mobileAppTrackerTrackClose");
			
			return 1;
		}
		
		public static function mobileAppTrackerTrackInAppPurchase(localizedTitle:String, currencyCode:String, unitPrice:Number, quantity:int, extraRevenue:Number, transactionIdentifier:String, isSuccess:Boolean) : int
		{
			init();
			extensionContext.call("mobileAppTrackerTrackInAppPurchase", localizedTitle, currencyCode, unitPrice, quantity, extraRevenue, transactionIdentifier, isSuccess);
			
			return 1;
		}
	}
}
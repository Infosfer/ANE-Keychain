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

		public static function getUserLanguageAndLocale() : String
		{
			init();
			return extensionContext.call("getUserLanguageAndLocale") as String;
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
	}
}
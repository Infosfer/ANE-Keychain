//
//  KeychainIosExtension.m
//  KeychainIosExtension
//
//  Created by Richard Lord on 03/05/2012.
//  Copyright (c) 2012 Stick Sports Ltd. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import "KeychainFRETypeConversion.h"
#import "KeychainAccessor.h"

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }

KeychainAccessor* keychainAccessor;

DEFINE_ANE_FUNCTION( insertStringInKeychain )
{
    NSString* key;
    if( keychain_FREGetObjectAsString( argv[0], &key ) != FRE_OK ) return NULL;
    
    NSString* value;
    if( keychain_FREGetObjectAsString( argv[1], &value ) != FRE_OK ) return NULL;
    
    NSString* kSecAttrAccessibleType;
    if( keychain_FREGetObjectAsString( argv[2], &kSecAttrAccessibleType ) != FRE_OK ) return NULL;
    
    OSStatus status;
    
    if( argc >= 4 )
    {
        NSString* accessGroup;
        if( keychain_FREGetObjectAsString( argv[3], &accessGroup ) != FRE_OK ) return NULL;
        status = [keychainAccessor insertObject:value forKey:key kSecAttrAccessibleType:kSecAttrAccessibleType withAccessGroup:accessGroup];
    }
    else
    {
        status = [keychainAccessor insertObject:value forKey:key kSecAttrAccessibleType:kSecAttrAccessibleType];
    }
    
    FREObject result;
    if ( FRENewObjectFromInt32( status, &result ) == FRE_OK )
    {
        return result;
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( updateStringInKeychain )
{
    NSString* key;
    if( keychain_FREGetObjectAsString( argv[0], &key ) != FRE_OK ) return NULL;
    
    NSString* value;
    if( keychain_FREGetObjectAsString( argv[1], &value ) != FRE_OK ) return NULL;
    
    NSString* kSecAttrAccessibleType;
    if( keychain_FREGetObjectAsString( argv[2], &kSecAttrAccessibleType ) != FRE_OK ) return NULL;
    
    OSStatus status;
    if( argc >= 4 )
    {
        NSString* accessGroup;
        if( keychain_FREGetObjectAsString( argv[3], &accessGroup ) != FRE_OK ) return NULL;
        status = [keychainAccessor updateObject:value forKey:key kSecAttrAccessibleType:kSecAttrAccessibleType withAccessGroup:accessGroup];
    }
    else
    {
        status = [keychainAccessor updateObject:value forKey:key kSecAttrAccessibleType:kSecAttrAccessibleType];
    }
    
    FREObject result;
    if ( FRENewObjectFromInt32( status, &result ) == FRE_OK )
    {
        return result;
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( insertOrUpdateStringInKeychain )
{
    NSString* key;
    if( keychain_FREGetObjectAsString( argv[0], &key ) != FRE_OK ) return NULL;
    
    NSString* value;
    if( keychain_FREGetObjectAsString( argv[1], &value ) != FRE_OK ) return NULL;
    
    NSString* kSecAttrAccessibleType;
    if( keychain_FREGetObjectAsString( argv[2], &kSecAttrAccessibleType ) != FRE_OK ) return NULL;
    
    OSStatus status;
    if( argc >= 4 )
    {
        NSString* accessGroup;
        if( keychain_FREGetObjectAsString( argv[3], &accessGroup ) != FRE_OK ) return NULL;
        status = [keychainAccessor insertOrUpdateObject:value forKey:key kSecAttrAccessibleType:kSecAttrAccessibleType withAccessGroup:accessGroup];
    }
    else
    {
        status = [keychainAccessor insertOrUpdateObject:value forKey:key kSecAttrAccessibleType:kSecAttrAccessibleType];
    }
    
    FREObject result;
    if ( FRENewObjectFromInt32( status, &result ) == FRE_OK )
    {
        return result;
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( fetchStringFromKeychain )
{
    NSString* key;
    if( keychain_FREGetObjectAsString( argv[0], &key ) != FRE_OK ) return NULL;
    
    NSString* kSecAttrAccessibleType;
    if( keychain_FREGetObjectAsString( argv[1], &kSecAttrAccessibleType ) != FRE_OK ) return NULL;
    
    NSString* value;
    if( argc >= 3 )
    {
        NSString* accessGroup;
        if( keychain_FREGetObjectAsString( argv[2], &accessGroup ) != FRE_OK ) return NULL;
        value = [keychainAccessor objectForKey:key kSecAttrAccessibleType:kSecAttrAccessibleType withAccessGroup:accessGroup];
    }
    else
    {
        value = [keychainAccessor objectForKey:key kSecAttrAccessibleType:kSecAttrAccessibleType];
    }

    if( value == nil )
    {
        return NULL;
    }
    
    FREObject asValue;
    if ( keychain_FRENewObjectFromString( value, &asValue ) == FRE_OK )
    {
        return asValue;
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( deleteStringFromKeychain )
{
    NSString* key;
    if( keychain_FREGetObjectAsString( argv[0], &key ) != FRE_OK ) return NULL;
    
    NSString* kSecAttrAccessibleType;
    if( keychain_FREGetObjectAsString( argv[1], &kSecAttrAccessibleType ) != FRE_OK ) return NULL;
    
    OSStatus status;
    if( argc >= 3 )
    {
        NSString* accessGroup;
        if( keychain_FREGetObjectAsString( argv[2], &accessGroup ) != FRE_OK ) return NULL;
        status = [keychainAccessor deleteObjectForKey:key kSecAttrAccessibleType:kSecAttrAccessibleType withAccessGroup:accessGroup];
    }
    else
    {
        status = [keychainAccessor deleteObjectForKey:key kSecAttrAccessibleType:kSecAttrAccessibleType];
    }
    
    FREObject result;
    if ( FRENewObjectFromInt32( status, &result ) == FRE_OK )
    {
        return result;
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( getUserLanguageAndLocale )
{
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    NSString *value = [NSString stringWithFormat:@"%@_%@", language, countryCode];
    
    FREObject asValue;
    if ( keychain_FRENewObjectFromString( value, &asValue ) == FRE_OK )
    {
        return asValue;
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( mobileAppTrackerInitialize )
{
    NSString* advertiserId;
    if( keychain_FREGetObjectAsString( argv[0], &advertiserId ) != FRE_OK ) return NULL;
    
    NSString* appkey;
    if( keychain_FREGetObjectAsString( argv[1], &appkey ) != FRE_OK ) return NULL;
    
    NSString* userId;
    if( keychain_FREGetObjectAsString( argv[2], &userId ) != FRE_OK ) return NULL;

    NSString *error;
    
    error = [keychainAccessor mobileAppTrackerInitialize:advertiserId appkey:appkey userId:userId];
    
    FREObject result;
    if (keychain_FRENewObjectFromString( error, &result ) == FRE_OK )
    {
        return result;
    }
    
    return NULL;
}

DEFINE_ANE_FUNCTION(mobileAppTrackerTrackInstall)
{
    [keychainAccessor mobileAppTrackerTrackInstall];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(mobileAppTrackerTrackUpdate)
{
    [keychainAccessor mobileAppTrackerTrackUpdate];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(mobileAppTrackerTrackOpen)
{
    [keychainAccessor mobileAppTrackerTrackOpen];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(mobileAppTrackerTrackClose)
{
    [keychainAccessor mobileAppTrackerTrackClose];
    
    return NULL;
}

DEFINE_ANE_FUNCTION( mobileAppTrackerTrackInAppPurchase )
{
    NSString* localizedTitle;
    if( keychain_FREGetObjectAsString( argv[0], &localizedTitle ) != FRE_OK ) return NULL;
    
    NSString* currencyCode;
    if( keychain_FREGetObjectAsString( argv[1], &currencyCode ) != FRE_OK ) return NULL;
    
    float unitPrice;
    if( keychain_FREGetObjectAsFloat( argv[2], &unitPrice ) != FRE_OK ) return NULL;
    
    int quantity;
    if( keychain_FREGetObjectAsInt( argv[3], &quantity ) != FRE_OK ) return NULL;
    
    float extraRevenue;
    if( keychain_FREGetObjectAsFloat( argv[4], &extraRevenue ) != FRE_OK ) return NULL;

    NSString* transactionIdentifier;
    if( keychain_FREGetObjectAsString( argv[5], &transactionIdentifier ) != FRE_OK ) return NULL;
    
    int isSuccess;
    if( keychain_FREGetObjectAsInt( argv[6], &isSuccess ) != FRE_OK ) return NULL;
    
    [keychainAccessor mobileAppTrackerTrackInAppPurchase:localizedTitle currencyCode:currencyCode unitPrice:unitPrice quantity:quantity extraRevenue:extraRevenue transactionIdentifier:transactionIdentifier isSuccess:isSuccess];
    
    return NULL;
}

void KeychainContextInitializer( void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet )
{
    static FRENamedFunction functionMap[] =
    {
        MAP_FUNCTION( insertStringInKeychain, NULL ),
        MAP_FUNCTION( updateStringInKeychain, NULL ),
        MAP_FUNCTION( insertOrUpdateStringInKeychain, NULL ),
        MAP_FUNCTION( fetchStringFromKeychain, NULL ),
        MAP_FUNCTION( getUserLanguageAndLocale, NULL ),
        MAP_FUNCTION( deleteStringFromKeychain, NULL ),
        
        MAP_FUNCTION( mobileAppTrackerInitialize, NULL),
        MAP_FUNCTION( mobileAppTrackerTrackInstall, NULL),
        MAP_FUNCTION( mobileAppTrackerTrackUpdate, NULL),
        MAP_FUNCTION( mobileAppTrackerTrackOpen, NULL),
        MAP_FUNCTION( mobileAppTrackerTrackClose, NULL),
        MAP_FUNCTION( mobileAppTrackerTrackInAppPurchase, NULL)        
    };
    
	*numFunctionsToSet = sizeof( functionMap ) / sizeof( FRENamedFunction );
	*functionsToSet = functionMap;
}

void KeychainContextFinalizer( FREContext ctx )
{
	return;
}

void KeychainExtensionInitializer( void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet ) 
{ 
    extDataToSet = NULL;  // This example does not use any extension data. 
    *ctxInitializerToSet = &KeychainContextInitializer;
    *ctxFinalizerToSet = &KeychainContextFinalizer;
    
    keychainAccessor = [[KeychainAccessor alloc] init];
}

void KeychainExtensionFinalizer()
{
    return;
}
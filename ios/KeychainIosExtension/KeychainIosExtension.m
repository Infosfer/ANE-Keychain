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
#import "NotificationChecker.h"
#import <objc/runtime.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }

KeychainAccessor* keychainAccessor;
FREContext AirCtx = nil;

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

DEFINE_ANE_FUNCTION(mobileAppTrackerTrackInAppPurchase)
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

DEFINE_ANE_FUNCTION(sendTweet)
{
    NSString* message;
    if( keychain_FREGetObjectAsString( argv[0], &message ) != FRE_OK ) return NULL;
    
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    // Set up the built-in twitter composition view controller.
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    // Set the initial tweet text. See the framework for additional properties that can be set.
    [tweetViewController setInitialText:message];
    
    // Create the completion handler block.
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        NSString *output;
        
        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                // The cancel button was tapped.
                output = @"CANCEL";
                break;
            case TWTweetComposeViewControllerResultDone:
                // The tweet was sent.
                output = @"DONE";
                break;
            default:
                break;
        }
        
        FREDispatchStatusEventAsync(AirCtx, (const uint8_t *)[output UTF8String], (const uint8_t *)[output UTF8String]);
        
        // Dismiss the tweet composition view controller.
        [rootViewController dismissModalViewControllerAnimated:YES];
    }];
    
    // Present the tweet composition view controller modally.
    [rootViewController presentModalViewController:tweetViewController animated:YES];
    
    return NULL;
}

int canSendTweetInternal(void) {
    BOOL result = NO;
    
    //On pre iOS 3.0 devices MFMailComposeViewController does not exists
    Class mailClass = (NSClassFromString(@"TWTweetComposeViewController"));
    if (mailClass != nil) {
        // We must always check whether the current device is configured for sending emails
        if ([TWTweetComposeViewController canSendTweet]) {
            result = YES;
        }
        else {
            result = NO;
        }
    }
    //this will never happen since Adobe AIR requires at least iOS 4.0
    else {
        result = NO;
    }
    return (int)result;
}
        
DEFINE_ANE_FUNCTION(canSendTweet)
{
    BOOL ret = canSendTweetInternal();
    FREObject retVal;
    
    FRENewObjectFromBool(ret, &retVal);
    return retVal;
}

void didReceiveLocalNotification(id self, SEL _cmd, UIApplication* application, UILocalNotification *notification)
{
    NSLog(@"didReceiveLocalNotification");
    
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
        FREDispatchStatusEventAsync(AirCtx, (uint8_t*)[@"RETURNED_FROM_BKG_BY_NOTIFICATION" UTF8String], (uint8_t*)[@"RETURNED_FROM_BKG_BY_NOTIFICATION" UTF8String]);
    }
}

void patchAirApplicationDelegate() {
    NSLog(@"patchAirApplicationDelegate");
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    Class objectClass = object_getClass(delegate);
    
    NSString *newClassName = [NSString stringWithFormat:@"Custom_%@", NSStringFromClass(objectClass)];
    Class modDelegate = NSClassFromString(newClassName);
    if (modDelegate == nil) {
        // this class doesn't exist; create it
        // allocate a new class
        modDelegate = objc_allocateClassPair(objectClass, [newClassName UTF8String], 0);
        
        SEL selectorToOverride2 = @selector(application:didReceiveLocalNotification:);
        
        // get the info on the method we're going to override
        Method m2 = class_getInstanceMethod([KeychainAccessor class], selectorToOverride2);

        // add the method to the new class
        class_addMethod(modDelegate, selectorToOverride2, (IMP)didReceiveLocalNotification, method_getTypeEncoding(m2));
   
        // register the new class with the runtime
        objc_registerClassPair(modDelegate);
    }
    // change the class of the object
    object_setClass(delegate, modDelegate);
}

DEFINE_ANE_FUNCTION(initExtension)
{
    BOOL appLaunchedWithNotification = [NotificationChecker applicationWasLaunchedWithNotification];
    if(appLaunchedWithNotification)
    {
        //[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        // UILocalNotification *notification = [NotificationChecker getLocalNotification];
        //NSString *type = [notification.userInfo objectForKey:@"type"];
        
        FREDispatchStatusEventAsync(AirCtx, (uint8_t*)[@"LAUNCHED_BY_NOTIFICATION" UTF8String], (uint8_t*)[@"LAUNCHED_BY_NOTIFICATION" UTF8String]);
    }
    
    [NotificationChecker setAirCtx:AirCtx];
    [keychainAccessor setAirCtx:AirCtx];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(httpPostRequest)
{
    NSLog(@"httpPostRequest");

    NSString* url;
    if( keychain_FREGetObjectAsString( argv[0], &url ) != FRE_OK ) return NULL;
    
    NSString* data;
    if( keychain_FREGetObjectAsString( argv[1], &data ) != FRE_OK ) return NULL;

    NSLog(@"data: %@", data);
    
    NSURL *nsUrl = [NSURL URLWithString:url];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:nsUrl];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    __block UIBackgroundTaskIdentifier bgTask = nil;
    
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"bg task timeout. %u", bgTask);
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    }];
    
    NSLog(@"bg task identifier: %u", bgTask);
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:keychainAccessor];
    
    if (!conn) {
        NSLog(@"Connection creation failed.");
        FREDispatchStatusEventAsync(AirCtx, (uint8_t*)[@"HTTP_REQUEST_ERROR" UTF8String], (uint8_t*)[@"HTTP_REQUEST_ERROR" UTF8String]);
    }
    else {
        NSLog(@"Connection created successfully.");
    }
    
    return NULL;
}

void KeychainContextInitializer( void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet )
{
    NSLog(@"KeychainContextInitializer");
    
    static FRENamedFunction functionMap[] =
    {
        MAP_FUNCTION( initExtension, NULL ),
        MAP_FUNCTION( httpPostRequest, NULL ),
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
        MAP_FUNCTION( mobileAppTrackerTrackInAppPurchase, NULL),
        
        MAP_FUNCTION( sendTweet, NULL),
        MAP_FUNCTION( canSendTweet, NULL)
    };
    
	*numFunctionsToSet = sizeof( functionMap ) / sizeof( FRENamedFunction );
	*functionsToSet = functionMap;
    AirCtx = ctx;
    
    patchAirApplicationDelegate();
}

void KeychainContextFinalizer( FREContext ctx )
{
	return;
}

void KeychainExtensionInitializer( void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet ) 
{ 
    NSLog(@"KeychainExtensionInitializer");
    extDataToSet = NULL;  // This example does not use any extension data.
    *ctxInitializerToSet = &KeychainContextInitializer;
    *ctxFinalizerToSet = &KeychainContextFinalizer;
    
    keychainAccessor = [[KeychainAccessor alloc] init];
}

void KeychainExtensionFinalizer()
{
    return;
}
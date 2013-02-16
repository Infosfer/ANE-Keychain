//
//  KeychainAccessor.m
//  KeychainIosExtension
//
//  Created by Richard Lord on 03/05/2012.
//  Copyright (c) 2012 Stick Sports Ltd. All rights reserved.
//

#import "KeychainAccessor.h"
#import <MobileAppTracker/MobileAppTracker.h>
#import <UIKit/UIDevice.h>
#import <StoreKit/SKPaymentTransaction.h>

static FREContext AirCtx = nil;

@implementation KeychainAccessor

-(void)setAirCtx:(FREContext)airCtx
{
    AirCtx = airCtx;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Did Receive Response");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Did Receive Data");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Did Fail With Error %@", error.localizedDescription);
    
    // release the connection, and the data object
    [connection release];
    
    FREDispatchStatusEventAsync(AirCtx, (uint8_t*)[@"HTTP_REQUEST_ERROR" UTF8String], (uint8_t*)[@"HTTP_REQUEST_ERROR" UTF8String]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Did Finish Loading");

    // release the connection, and the data object
    [connection release];

    FREDispatchStatusEventAsync(AirCtx, (uint8_t*)[@"HTTP_REQUEST_SUCCESS" UTF8String], (uint8_t*)[@"HTTP_REQUEST_SUCCESS" UTF8String]);
}

-(NSMutableDictionary*)queryDictionaryForKey:(NSString*)key kSecAttrAccessibleTypeValue:(NSString*)kSecAttrAccessibleTypeValue
{
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    
    [query setObject:(id)kSecClassGenericPassword  forKey:(id)kSecClass];
    
    if ([kSecAttrAccessibleTypeValue isEqualToString:@"kSecAttrAccessibleWhenUnlocked"]) {
        [query setObject:(id)kSecAttrAccessibleWhenUnlocked forKey:(id)kSecAttrAccessible];
    }
    else if ([kSecAttrAccessibleTypeValue isEqualToString:@"kSecAttrAccessibleAfterFirstUnlock"]) {
        [query setObject:(id)kSecAttrAccessibleAfterFirstUnlock forKey:(id)kSecAttrAccessible];
    }
    else if ([kSecAttrAccessibleTypeValue isEqualToString:@"kSecAttrAccessibleAlways"]) {
        [query setObject:(id)kSecAttrAccessibleAlways forKey:(id)kSecAttrAccessible];
    }
    else if ([kSecAttrAccessibleTypeValue isEqualToString:@"kSecAttrAccessibleWhenUnlockedThisDeviceOnly"]) {
        [query setObject:(id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly forKey:(id)kSecAttrAccessible];
    }
    else if ([kSecAttrAccessibleTypeValue isEqualToString:@"kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly"]) {
        [query setObject:(id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly forKey:(id)kSecAttrAccessible];
    }
    else if ([kSecAttrAccessibleTypeValue isEqualToString:@"kSecAttrAccessibleAlwaysThisDeviceOnly"]) {
        [query setObject:(id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(id)kSecAttrAccessible];
    }
    
    [query setObject:key forKey:(id)kSecAttrService];

    return query;
}

-(NSMutableDictionary*)queryDictionaryForKey:(NSString*)key kSecAttrAccessibleTypeValue:(NSString*)kSecAttrAccessibleTypeValue accessGroup:(NSString*)accessGroup
{
    NSMutableDictionary* query = [self queryDictionaryForKey:key kSecAttrAccessibleTypeValue:kSecAttrAccessibleTypeValue];
    [query setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
    return query;
}

-(OSStatus)insertObject:(NSString*)obj forKey:(NSString*)key kSecAttrAccessibleType:(NSString*)kSecAttrAccessibleType
{
    NSMutableDictionary* query = [self queryDictionaryForKey:key kSecAttrAccessibleTypeValue:kSecAttrAccessibleType];
    
    [query setObject:[obj dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
    
    return SecItemAdd ((CFDictionaryRef) query, NULL);
}

-(OSStatus)updateObject:(NSString*)obj forKey:(NSString*) key kSecAttrAccessibleType:(NSString*)kSecAttrAccessibleType
{
    NSMutableDictionary* query = [self queryDictionaryForKey:key kSecAttrAccessibleTypeValue:kSecAttrAccessibleType];
    
    NSMutableDictionary* change = [NSMutableDictionary dictionary];
    [change setObject:[obj dataUsingEncoding:NSUTF8StringEncoding] forKey:(id) kSecValueData];
    
    return SecItemUpdate ( (CFDictionaryRef) query, (CFDictionaryRef) change);
}

-(OSStatus)insertOrUpdateObject:(NSString*)obj forKey:(NSString*)key kSecAttrAccessibleType:(NSString*)kSecAttrAccessibleType
{
    OSStatus status = [self insertObject:obj forKey:key kSecAttrAccessibleType:kSecAttrAccessibleType];
    if( status == errSecDuplicateItem )
    {
        status = [self updateObject:obj forKey:key kSecAttrAccessibleType:kSecAttrAccessibleType];
    }
    return status;
}

-(NSString*)objectForKey:(NSString*)key kSecAttrAccessibleType:(NSString*)kSecAttrAccessibleType
{
    NSMutableDictionary* query = [self queryDictionaryForKey:key kSecAttrAccessibleTypeValue:kSecAttrAccessibleType];
    [query setObject:(id) kCFBooleanTrue forKey:(id) kSecReturnData];
    
    NSData* data = nil;
    OSStatus status = SecItemCopyMatching ( (CFDictionaryRef) query, (CFTypeRef*) &data );
    
    if( status != errSecSuccess || !data )
    {
        return nil;
    }
    
    NSString* value = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return value;    
}

-(OSStatus)deleteObjectForKey:(NSString*)key kSecAttrAccessibleType:(NSString*)kSecAttrAccessibleType
{
    NSMutableDictionary* query = [self queryDictionaryForKey:key kSecAttrAccessibleTypeValue:kSecAttrAccessibleType];
    return SecItemDelete( (CFDictionaryRef) query );
}

-(OSStatus)insertObject:(NSString*)obj forKey:(NSString*)key kSecAttrAccessibleType:(NSString*)kSecAttrAccessibleType withAccessGroup:(NSString*)accessGroup
{
    NSMutableDictionary* query = [self queryDictionaryForKey:key kSecAttrAccessibleTypeValue:kSecAttrAccessibleType accessGroup:accessGroup];
    
    [query setObject:[obj dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
    
    return SecItemAdd ((CFDictionaryRef) query, NULL);
}

-(OSStatus)updateObject:(NSString*)obj forKey:(NSString*)key kSecAttrAccessibleType:(NSString*)kSecAttrAccessibleType withAccessGroup:(NSString*)accessGroup
{
    NSMutableDictionary* query = [self queryDictionaryForKey:key kSecAttrAccessibleTypeValue:kSecAttrAccessibleType accessGroup:accessGroup];
    
    NSMutableDictionary* change = [NSMutableDictionary dictionary];
    [change setObject:[obj dataUsingEncoding:NSUTF8StringEncoding] forKey:(id) kSecValueData];
    
    return SecItemUpdate ( (CFDictionaryRef) query, (CFDictionaryRef) change);
}

-(OSStatus)insertOrUpdateObject:(NSString*)obj forKey:(NSString*)key kSecAttrAccessibleType:(NSString*)kSecAttrAccessibleType withAccessGroup:(NSString*)accessGroup
{
    OSStatus status = [self insertObject:obj forKey:key kSecAttrAccessibleType:kSecAttrAccessibleType withAccessGroup:accessGroup];
    if( status == errSecDuplicateItem )
    {
        status = [self updateObject:obj forKey:key kSecAttrAccessibleType:kSecAttrAccessibleType];
    }
    return status;
}

-(NSString*)objectForKey:(NSString*)key kSecAttrAccessibleType:(NSString*)kSecAttrAccessibleType withAccessGroup:(NSString*)accessGroup
{
    NSMutableDictionary* query = [self queryDictionaryForKey:key kSecAttrAccessibleTypeValue:kSecAttrAccessibleType accessGroup:accessGroup];
    [query setObject:(id) kCFBooleanTrue forKey:(id) kSecReturnData];
    
    NSData* data = nil;
    OSStatus status = SecItemCopyMatching ( (CFDictionaryRef) query, (CFTypeRef*) &data );
    
    if( status != errSecSuccess || !data )
    {
        return nil;
    }
    
    NSString* value = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return value;    
}

-(OSStatus)deleteObjectForKey:(NSString*)key kSecAttrAccessibleType:(NSString*)kSecAttrAccessibleType withAccessGroup:(NSString*)accessGroup
{
    NSMutableDictionary* query = [self queryDictionaryForKey:key kSecAttrAccessibleTypeValue:kSecAttrAccessibleType accessGroup:accessGroup];
    return SecItemDelete( (CFDictionaryRef) query );
}

-(NSString *)mobileAppTrackerInitialize:(NSString*)advertiserId appkey:(NSString *)appKey userId:(NSString *)userId
{
    NSError *error = nil;
    BOOL isError = [[MobileAppTracker sharedManager] startTrackerWithAdvertiserId:advertiserId advertiserKey:appKey withError:&error];
    
    if (!isError) {
        /*if (isDebug) {
            [[MobileAppTracker sharedManager] setShouldDebugResponseFromServer:NO];
            [[MobileAppTracker sharedManager] setShouldAllowDuplicateRequests:NO];
        }*/
        
        if (userId != nil) {
            [[MobileAppTracker sharedManager] setUserId:userId];
        }
      
        /*
        if (useUniqueIdentifier) {
            [[MobileAppTracker sharedManager] setDeviceId:[[UIDevice currentDevice] uniqueIdentifier]];
        }
         */
        
        
        return @"";
    }
    else {
        return [error localizedDescription];
    }
}

-(void)mobileAppTrackerTrackInstall {
    [[MobileAppTracker sharedManager] trackInstall];
}

-(void)mobileAppTrackerTrackUpdate {
    [[MobileAppTracker sharedManager] trackUpdate];
}

-(void)mobileAppTrackerTrackOpen {
    [[MobileAppTracker sharedManager] trackActionForEventIdOrName:@"open" eventIsId:NO];
}

-(void)mobileAppTrackerTrackClose {
    [[MobileAppTracker sharedManager] trackActionForEventIdOrName:@"close" eventIsId:NO];
}

-(void)mobileAppTrackerTrackInAppPurchase:(NSString *)localizedTitle
    currencyCode:(NSString *)currencyCode
    unitPrice:(float)unitPrice
    quantity:(int)quantity
    extraRevenue:(float)extraRevenue
    transactionIdentifier:(NSString *)transactionIdentifier
    isSuccess:(int)isSuccess
{
    float revenue = unitPrice * quantity;
 
    NSDictionary *dictItem = @{
    @"item" : localizedTitle,
    @"unit_price" : [NSString stringWithFormat:@"%f", unitPrice],
    @"quantity" : [NSString stringWithFormat:@"%d", quantity],
    @"revenue" : [NSString stringWithFormat:@"%f", revenue]
    };
    
    NSArray *arrEventItems = @[ dictItem ];

    [[MobileAppTracker sharedManager]
        trackActionForEventIdOrName:@"purchase"
        eventIsId:NO
        eventItems:arrEventItems
        referenceId:transactionIdentifier
        revenueAmount:extraRevenue
        currencyCode:currencyCode
        transactionState:(isSuccess) ? SKPaymentTransactionStatePurchased : SKPaymentTransactionStateFailed
    ];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *) notification{}

@end

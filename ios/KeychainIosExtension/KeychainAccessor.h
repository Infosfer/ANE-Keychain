//
//  KeychainAccessor.h
//  KeychainIosExtension
//
//  Created by Richard Lord on 03/05/2012.
//  Copyright (c) 2012 Stick Sports Ltd. All rights reserved.
//
#import <Security/Security.h>
#import "UIKit/UIApplication.h"
#import "FlashRuntimeExtensions.h"

@interface KeychainAccessor : NSObject <NSURLConnectionDelegate>

-(OSStatus)insertObject:(NSString*)obj forKey:(NSString*)key kSecAttrAccessibleType:(NSString*)kSecAttrAccessibleType;
-(OSStatus)updateObject:(NSString *)obj forKey:(NSString *)key kSecAttrAccessibleType:(NSString*)kSecAttrAccessibleType;
-(OSStatus)insertOrUpdateObject:(NSString *)obj forKey:(NSString *)key kSecAttrAccessibleType:(NSString*)kSecAttrAccessibleType;
-(NSString *)objectForKey:(NSString *)key kSecAttrAccessibleType:(NSString*)kSecAttrAccessibleType;
-(OSStatus)deleteObjectForKey:(NSString *)key kSecAttrAccessibleType:(NSString*)kSecAttrAccessibleType;

-(OSStatus)insertObject:(NSString*)obj forKey:(NSString*)key kSecAttrAccessibleType:(NSString*)kSecAttrAccessibleType withAccessGroup:(NSString*)accessGroup;
-(OSStatus)updateObject:(NSString *)obj forKey:(NSString *)key kSecAttrAccessibleType:(NSString*)kSecAttrAccessibleType withAccessGroup:(NSString*)accessGroup;
-(OSStatus)insertOrUpdateObject:(NSString *)obj forKey:(NSString *)key kSecAttrAccessibleType:(NSString*)kSecAttrAccessibleType withAccessGroup:(NSString*)accessGroup;
-(NSString *)objectForKey:(NSString *)key kSecAttrAccessibleType:(NSString*)kSecAttrAccessibleType withAccessGroup:(NSString*)accessGroup;
-(OSStatus)deleteObjectForKey:(NSString *)key kSecAttrAccessibleType:(NSString*)kSecAttrAccessibleType withAccessGroup:(NSString*)accessGroup;

-(NSString *)mobileAppTrackerInitialize:(NSString*)advertiserId appkey:(NSString *)appKey userId:(NSString *)userId;
-(void)mobileAppTrackerTrackInstall;
-(void)mobileAppTrackerTrackUpdate;
-(void)mobileAppTrackerTrackOpen;
-(void)mobileAppTrackerTrackClose;
-(void)mobileAppTrackerTrackInAppPurchase:(NSString *)localizedTitle
                             currencyCode:(NSString *)currencyCode
                                unitPrice:(float)unitPrice
                                 quantity:(int)quantity
                             extraRevenue:(float)extraRevenue
                    transactionIdentifier:(NSString *)transactionIdentifier
                                isSuccess:(int)isSuccess;
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *) notification;
-(void)setAirCtx:(FREContext)airCtx;

@end

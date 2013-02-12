//
//  NotificationChecker.h
//  KeychainIosExtension
//
//  Created by cemuzunlar on 12.02.2013.
//  Copyright (c) 2013 Stick Sports Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UILocalNotification.h>
#import "FlashRuntimeExtensions.h"

@interface NotificationChecker : NSObject
+ (void)load;
+ (void)createNotificationChecker:(NSNotification *)notification;
+ (BOOL) applicationWasLaunchedWithNotification;
+ (UILocalNotification*) getLocalNotification;
+ (void)setAirCtx:(FREContext)airCtx;

@end

//
//  NotificationChecker.m
//  KeychainIosExtension
//
//  Created by cemuzunlar on 12.02.2013.
//  Copyright (c) 2013 Stick Sports Ltd. All rights reserved.
//

#import "NotificationChecker.h"

static BOOL _launchedWithNotification = NO;
static UILocalNotification *_localNotification = nil;
static FREContext AirCtx = nil;

@implementation NotificationChecker

+ (void)load
{
    NSLog(@"NotificationChecker::load");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createNotificationChecker:)
                                                 name:@"UIApplicationDidFinishLaunchingNotification" object:nil];
}

+ (void)createNotificationChecker:(NSNotification *)notification
{
    NSDictionary *launchOptions = [notification userInfo] ;
    
    // This code will be called immediately after application:didFinishLaunchingWithOptions:.
    UILocalNotification *localNotification = [launchOptions objectForKey: @"UIApplicationLaunchOptionsLocalNotificationKey"];
    if (localNotification)
    {
        NSLog(@"NotificationChecker::createNotificationChecker YES");
        _launchedWithNotification = YES;
        _localNotification = localNotification;
    }
    else
    {
        NSLog(@"NotificationChecker::createNotificationChecker NO");
        _launchedWithNotification = NO;
    }
    
    if (AirCtx) {
        FREDispatchStatusEventAsync(AirCtx, (uint8_t*)[@"LAUNCHED_BY_NOTIFICATION" UTF8String], (uint8_t*)[@"LAUNCHED_BY_NOTIFICATION" UTF8String]); 
    }
}

+(BOOL) applicationWasLaunchedWithNotification
{
    return _launchedWithNotification;
}

+(UILocalNotification*) getLocalNotification
{
    return _localNotification;
}

+ (void)setAirCtx:(FREContext)airCtx
{
    AirCtx = airCtx;
}

@end
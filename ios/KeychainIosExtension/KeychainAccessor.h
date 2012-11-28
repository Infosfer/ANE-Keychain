//
//  KeychainAccessor.h
//  KeychainIosExtension
//
//  Created by Richard Lord on 03/05/2012.
//  Copyright (c) 2012 Stick Sports Ltd. All rights reserved.
//
#import <Security/Security.h>

@interface KeychainAccessor : NSObject

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

@end

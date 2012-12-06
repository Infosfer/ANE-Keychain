//
//  KeychainAccessor.m
//  KeychainIosExtension
//
//  Created by Richard Lord on 03/05/2012.
//  Copyright (c) 2012 Stick Sports Ltd. All rights reserved.
//

#import "KeychainAccessor.h"

@implementation KeychainAccessor

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
@end

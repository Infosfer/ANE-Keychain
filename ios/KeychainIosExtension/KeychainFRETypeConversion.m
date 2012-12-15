//
//  FRETypeConversion.c
//  GameCenterIosExtension
//
//  Created by Richard Lord on 25/01/2012.
//  Copyright (c) 2012 Stick Sports Ltd. All rights reserved.
//

#import "KeychainFRETypeConversion.h"

FREResult keychain_FREGetObjectAsString( FREObject object, NSString** value )
{
    FREResult result;
    uint32_t length = 0;
    const uint8_t* tempValue = NULL;
    
    result = FREGetObjectAsUTF8( object, &length, &tempValue );
    if( result != FRE_OK ) return result;
    
    *value = [NSString stringWithUTF8String: (char*) tempValue];
    return FRE_OK;
}

FREResult keychain_FREGetObjectAsInt( FREObject object, int* value )
{
    FREResult result;
    
    result = FREGetObjectAsInt32(object, value);
    if( result != FRE_OK ) return result;
    
    return FRE_OK;
}

FREResult keychain_FREGetObjectAsFloat( FREObject object, float* value )
{
    FREResult result;
    double valueAsDouble;
    
    result = FREGetObjectAsDouble(object, &valueAsDouble);
    if( result != FRE_OK ) return result;
    
    *value = (float)valueAsDouble;
    
    return FRE_OK;
}

FREResult keychain_FRENewObjectFromString( NSString* string, FREObject* asString )
{
    const char* utf8String = string.UTF8String;
    unsigned long length = strlen( utf8String );
    return FRENewObjectFromUTF8( length + 1, (uint8_t*) utf8String, asString );
}
#pragma once

#import <Foundation/Foundation.h>

@interface DEREncoder
+ (NSData*)derEncodeInteger:(NSData*)value;
+(NSData*)derEncodeSignature:(NSData*)signature;
@end
#pragma once

#import <Foundation/Foundation.h>

@interface DEREncoder : NSObject 
+ (NSData*)derEncodeInteger:(NSData*)value;
+(NSData*)derEncodeSignature:(NSData*)signature;
@end

//
//  CryptoOps.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/7/16.
//
//

#ifndef CryptoOps_h
#define CryptoOps_h

#import <Foundation/Foundation.h>
#import "libbase58.h"
#import "AddressManager.h"

#ifndef WINOBJC
#import <CoreBitcoin/CoreBitcoin.h>
#endif



@interface CryptoOps : NSObject

+ (NSString*)signData:(NSString*)privBytes withAddress:(NSString*)tag;
+ (NSData*)hexEncodedHashToData:(NSString*)data;
+ (NSData*)hexEncodedStringToData:(NSString*)test;
+ (NSString*)dataToHexEncodedString:(NSData*)test;


@end



#endif /* CryptoOps_h */

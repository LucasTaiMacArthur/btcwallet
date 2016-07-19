//
//  CryptoOps.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/7/16.
//
//

#ifndef CryptoOps_h
#define CryptoOps_h

#import <openssl/rand.h>
#import <openssl/ec.h>
#import <openssl/sha.h>
#import <openssl/ripemd.h>
#import <openssl/obj_mac.h>
#import <Foundation/Foundation.h>
#import "libbase58.h"
#import "AddressManager.h"

@interface CryptoOps : NSObject


+ (NSString *)generateKeyPair;

@end



#endif /* CryptoOps_h */

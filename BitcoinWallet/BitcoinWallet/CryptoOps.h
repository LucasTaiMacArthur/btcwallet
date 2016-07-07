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
#import <openssl/obj_mac.h>
#import <Foundation/Foundation.h>

@interface CryptoOps : NSObject

typedef struct keyPair{
    
    unsigned char *privKey;
    unsigned char *pubKey;
    
    
} keyPair;

+ (void)generateKeyPair;

@end



#endif /* CryptoOps_h */

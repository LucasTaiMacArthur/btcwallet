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
#import <CoreBitcoin/CoreBitcoin.h>



@interface CryptoOps : NSObject

+ (NSString*)signData:(NSString*)privBytes withAddress:(NSString*)tag;





@end



#endif /* CryptoOps_h */

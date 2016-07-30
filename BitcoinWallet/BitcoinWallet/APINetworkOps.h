//
//  APINetworkOps.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/27/16.
//
//

#ifndef APINetworkOps_h
#define APINetworkOps_h

#import "AddressManager.h"
#import "CryptoOps.h"

@interface APINetworkOps : NSObject

+ (void)generateAddressAndAddToAddressManagerWithTag:(NSString*)tag;
+ (NSData*)generatePartialTXWithInput:(NSString*)input andOutput:(NSString*)output andValue:(NSNumber*)val;
+ (NSString*)sendCompletedTransaction:(NSData*)transactionData forAddress:(NSString*)addressName;
+ (NSString*)getTXSkeletonWithData:(NSData*)jsonSkeleton;

@end


#endif /* APINetworkOps_h */

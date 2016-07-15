//
//  NetworkOps.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/8/16.
//
//

#ifndef NetworkOps_h
#define NetworkOps_h

#import "MainViewController.h"

@interface NetworkOps : NSObject

+ (NSString*)getAddressBalance:(NSString *)address changeWithLabel:(UILabel *)label;
+ (NSData*)getAddressQRCode:(NSString *)address changeWithData:(UIImageView *)data;

@end


#endif /* NetworkOps_h */

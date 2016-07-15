//
//  MainViewController.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/11/16.
//
//

#ifndef MainViewController_h
#define MainViewController_h

#import <UIKit/UIKit.h>
#import "CryptoOps.h"
#import "NetworkOps.h"


@interface MainViewController : UIViewController
@property (strong, nonatomic) NSString* btcString;
@property (strong, nonatomic) NSString* balString;
@property (strong,nonatomic) UILabel* balance;


@end

#endif /* MainViewController_h */

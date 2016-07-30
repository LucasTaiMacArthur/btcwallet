//
//  MenuViewController.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/22/16.
//
//

#ifndef MenuViewController_h
#define MenuViewController_h
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AddressManager.h"
#import "NetworkOps.h"
#import "AddressListView.h"
#import "APINetworkOps.h"
#import "SendTransactionViewController.h"

@interface MenuViewController : UIViewController

@property (nonatomic,strong) UIButton *makePaymentButton;
@property (nonatomic,strong) UIButton *myAddressesButton;
@property (nonatomic,strong) UIButton *myContactsButton;
@property (nonatomic,strong) UIButton *myTransactionsButton;
@property (nonatomic,strong) UIButton *refreshButton;




@end

#endif /* MenuViewController_h */

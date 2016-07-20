//
//  AddressViewController.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/20/16.
//
//

#ifndef AddressViewController_h
#define AddressViewController_h

#import <UIKit/UIKit.h>

@interface AddressViewController : UIViewController

@property(nonatomic,strong) NSString* bitcoinAddress;
@property(nonatomic,strong) UILabel* balanceLabel;

@end

#endif /* AddressViewController_h */

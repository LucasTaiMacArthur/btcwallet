//
//  SendTransactionViewController.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/25/16.
//
//

#ifndef SendTransactionViewController_h
#define SendTransactionViewController_h
#import <UIKit/UIKit.h>
#import "ContactManager.h"
#import "AddressManager.h"
#import "APINetworkOps.h"
#import "CryptoOps.h"

@interface SendTransactionViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong,atomic) UINavigationBar *navBar;
@property (strong,atomic) UITextField *amountField;
@property (strong,atomic) UILabel *btcLabel;
@property (strong,atomic) UILabel *fromLabel;
@property (strong,atomic) UIPickerView *contactPicker;

@property (strong,atomic) UIButton *makePaymentButton;
@property (strong,atomic) NSArray *pickerData;
@property (strong,atomic) NSDictionary *contactData;
@property (strong,atomic) UILabel *toLabel;

@property (strong,atomic) UIPickerView *addressPicker;
@property (strong,atomic) NSArray *pickerDataAddresses;
@property (strong,atomic) NSDictionary *addressData;







@end

#endif /* SendTransactionViewController_h */

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
#import "AddressManager.h"
#import "AddressViewController.h"

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (atomic,strong) UITableView *mainTable;
@property (atomic,strong) NSArray *tableData;


@end

#endif /* MainViewController_h */

//
//  AddressListView.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/25/16.
//
//

#ifndef AddressListView_h
#define AddressListView_h

#include <UIKit/UIKit.h>
#include "AddressManager.h"
#include "AddressViewController.h"
#include "CryptoOps.h"
#import "NetworkOps.h"
#import "APINetworkOps.h"


@interface AddressListView : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) UINavigationBar* navBar;
@property (atomic,strong) UITableView *mainTable;
@property (atomic,strong) NSArray *tableData;
@property (atomic,strong) NSDictionary *pairDict;



@end

#endif /* AddressListView_h */

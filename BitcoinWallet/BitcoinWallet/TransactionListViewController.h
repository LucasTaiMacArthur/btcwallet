//
//  TransactionListViewController.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/30/16.
//
//

#ifndef TransactionListViewController_h
#define TransactionListViewController_h
#import <UIKit/UIKit.h>
#import "APINetworkOps.h"
#import "TransactionManager.h"

@interface TransactionListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UINavigationBar* navBar;
@property (atomic,strong) UITableView *mainTable;
@property (atomic,strong) NSArray *tableData;
@property (atomic,strong) NSSet *pairDict;

@property (atomic,strong) NSMutableArray *toAddr;
@property (atomic,strong) NSMutableArray *fromAddr;
@property (atomic,strong) NSMutableArray *amount;

@end

#endif /* TransactionListViewController_h */

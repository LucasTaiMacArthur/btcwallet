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
#import <Foundation/Foundation.h>
#include "AddressManager.h"
#include "AddressViewController.h"
#include "CryptoOps.h"
#import "NetworkOps.h"
#import "APINetworkOps.h"
// import ui/notifcations for the toast if we are on a windows system
#ifdef WINOBJC
#import <UWP/WindowsUIXamlControls.h>
#import <UWP/WindowsDataXmlDom.h>
#endif



@interface AddressListView : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) UINavigationBar* navBar;
@property (atomic,strong) UITableView *mainTable;
@property (atomic,strong) NSArray *tableData;
@property (atomic,strong) NSDictionary *pairDict;



@end

#endif /* AddressListView_h */

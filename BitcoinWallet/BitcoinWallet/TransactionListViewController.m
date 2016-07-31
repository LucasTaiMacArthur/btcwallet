//
//  TransactionListViewController.m
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/30/16.
//
//

#import <Foundation/Foundation.h>
#import "TransactionListViewController.h"

@implementation TransactionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // add navigation bar
    _navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, frameWidth, 44)];
    _navBar.barTintColor = [UIColor colorWithRed:(0xc5/255.0f) green:(0xef/255.0f) blue:(0xf7/255.0f) alpha:1.0];
    
    // add navbar item with buttons
    UINavigationItem *navBar = [[UINavigationItem alloc] initWithTitle:@"Addresses"];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:@selector(addNewAddressPressed)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:@selector(backButtonPressed)];
    navBar.rightBarButtonItem = addButton;
    navBar.leftBarButtonItem = backButton;
    [_navBar pushNavigationItem:navBar animated:NO];
    // add navigation bar
    [self.view addSubview:_navBar];
    
    // dummy data
    TransactionManager *transactionMan = [TransactionManager globalManager];
    //[transactionMan createKeyPairsWithDummyData];
    _pairDict = [transactionMan getTransactionHashes];
    _tableData = [[NSArray arrayWithArray:[_pairDict allObjects]] retain];
    
    // create paralell arrays for To, From, Amount
    NSUInteger len = [_tableData count];
    _fromAddr = [[NSMutableArray alloc]initWithCapacity:len];
    _toAddr = [[NSMutableArray alloc]initWithCapacity:len];
    _amount = [[NSMutableArray alloc]initWithCapacity:len];
    
    // fetch all the data
    
    for (NSString *s in _tableData){
        printf("Getting Information for hash - %s\n",[s UTF8String]);
        NSDictionary *hashInfo = [APINetworkOps getTXHashInfo:s];
        NSNumber *txAmt = [hashInfo objectForKey:@"total"];
        
        NSArray *addressesInvolved = [hashInfo objectForKey:@"addresses"];
        for (NSString *addr in addressesInvolved) {
            printf("address involved was %s\n",[addr UTF8String]);
        }
    }

    
    // create tableview
    CGRect mainTableFrame = CGRectMake(0, 64, frameWidth, frameHeight-64);
    _mainTable = [[UITableView alloc]initWithFrame:mainTableFrame style:UITableViewStylePlain];
    [_mainTable setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_mainTable setDelegate:self];
    [_mainTable setDataSource:self];
    _mainTable.backgroundColor = [UIColor colorWithRed:(210.0/255.0f) green:(215.0/255.0f) blue:(211.0/255.0f) alpha:1.0];
    [self.view addSubview:_mainTable];
    
    
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableData count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *contactCellIdent = @"contactCell";
    UITableViewCell *contactCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contactCellIdent];
    contactCell.textLabel.text = [_tableData objectAtIndex:indexPath.row];
    
    [APINetworkOps getTXHashInfo:contactCell.textLabel.text];
    
    return contactCell;
}


- (void)addNewAddressPressed {

}


- (void)backButtonPressed {
    [self dismissViewControllerAnimated:TRUE completion:^{
        // nil
    }];
}


@end

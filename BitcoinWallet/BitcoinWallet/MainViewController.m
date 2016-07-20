//
//  MainViewController.m
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/11/16.
//
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    
    // dummy data
    AddressManager *addrMan = [AddressManager globalManager];
    NSDictionary *pairDict = [addrMan getKeyPairs];
    _tableData = [[NSArray arrayWithArray:[pairDict allValues]] retain];
    
    // create tableview
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
    CGRect mainTableFrame = CGRectMake(0, 20, frameWidth, frameHeight);
    _mainTable = [[UITableView alloc]initWithFrame:mainTableFrame style:UITableViewStylePlain];
    [_mainTable setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_mainTable setDelegate:self];
    [_mainTable setDataSource:self];
    [self.view addSubview:_mainTable];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableData count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *bitcoinCellIdentifier = @"BitcoinCell";
    UITableViewCell *addressCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bitcoinCellIdentifier];
    addressCell.textLabel.text = [_tableData objectAtIndex:indexPath.row];
    return addressCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressViewController *itemController = [[AddressViewController alloc] init];
    itemController.bitcoinAddress = @"LOL";
}








@end

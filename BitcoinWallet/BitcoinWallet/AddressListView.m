//
//  AddressListView.m
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/25/16.
//
//

#import <Foundation/Foundation.h>
#import "AddressListView.h"

@implementation AddressListView

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
    AddressManager *addressMan = [AddressManager globalManager];
    //[addressMan createKeyPairsWithDummyData];
    _pairDict = [addressMan getKeyTagMapping];
    _tableData = [[NSArray arrayWithArray:[_pairDict allKeys]] retain];
    
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
    
    
    
    // check in dict if
    
    return contactCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    // get the row
    UITableViewCell *cellSelected = [tableView cellForRowAtIndexPath:indexPath];
    NSString *tag = cellSelected.textLabel.text;
    // get the address
    NSString *address = [_pairDict objectForKey:tag];
    printf("Adress associated with %s was %s\n",[tag UTF8String],[address UTF8String]);
    
    AddressViewController *toShow = [AddressViewController initWithName:tag andAddress:address];
    [toShow setModalPresentationStyle:UIModalPresentationFullScreen];
    [toShow setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:toShow animated:YES completion:^{
    }];

    
}

- (void)addNewAddressPressed {
    UIAlertController *newAddress = [UIAlertController alertControllerWithTitle:@"Create New Address" message:@"Provide a nickname for this address" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *submit = [UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // get string pair
        NSString *newTag = newAddress.textFields.firstObject.text;
        [APINetworkOps generateAddressAndAddToAddressManagerWithTag:newTag];
        // add kp to the manager
        [self.view setNeedsDisplay];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // just quietly exit
    }];
    
    [newAddress addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Adress Name";
    }];

    
    [newAddress addAction:cancel];
    [newAddress addAction:submit];


    [self presentViewController:newAddress animated:YES completion:^{
        // nothing
    }];
}


- (void)backButtonPressed {
    [self dismissViewControllerAnimated:TRUE completion:^{
        // nil
    }];
}


@end

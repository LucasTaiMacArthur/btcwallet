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

static NSDictionary *contacts;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    ContactManager *man = [ContactManager globalManager];
	[man createKeyPairsWithDummyData];
    /*
    printf("THE CONTACT DIR WAS: %i\n",[man contactDirectoryExists]);

    
    if ([man contactDirectoryExists]){
    }else {
        [man createContactDirectory];
    }
    
    printf("THE CONTACT DIR WAS: %i\n",[man contactDirectoryExists]);
    
    if ([man addContact:@"Joe Joe"] && [man addContact:@"John Smith"]) {
        printf("Both Contacts Successfully Added\n");
    }
    
    
    [man getAllContactNames];
    
     
    */
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    // add navigation bar
    _navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, frameWidth, 44)];
    _navBar.barTintColor = [UIColor colorWithRed:(0xc5/255.0f) green:(0xef/255.0f) blue:(0xf7/255.0f) alpha:1.0];
    
    // add navbar item with buttons
    UINavigationItem *staticItem = [[UINavigationItem alloc] initWithTitle:@"Contacts"];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:@selector(addButtonPressed)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:@selector(backButtonPressed)];
    staticItem.rightBarButtonItem = addButton;
    staticItem.leftBarButtonItem = backButton;
    [_navBar pushNavigationItem:staticItem animated:NO];
    // add navigation bar
    [self.view addSubview:_navBar];
    
    
    // dummy data
    ContactManager *contactMan = [ContactManager globalManager];
    NSDictionary *pairDict = [contactMan getKeyPairs];
    contacts = pairDict;
    _tableData = [[NSArray arrayWithArray:[pairDict allKeys]] retain];
    
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
    NSString *address = [contacts objectForKey:tag];
    printf("contact addr associated with %s was %s\n",[tag UTF8String],[address UTF8String]);
    
    ContactViewController *toShow = [ContactViewController initWithName:tag andAddress:address];
    [toShow setModalPresentationStyle:UIModalPresentationFullScreen];
    [toShow setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:toShow animated:YES completion:^{
    }];

    
}

- (void)backButtonPressed {
    [self dismissViewControllerAnimated:TRUE completion:^{
        // nil
    }];
}

- (void)addButtonPressed {
    
    CreateContactViewController *toShow = [[CreateContactViewController alloc] init];
    [toShow setModalPresentationStyle:UIModalPresentationFullScreen];
    [toShow setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:toShow animated:YES completion:^{
    }];

}









@end

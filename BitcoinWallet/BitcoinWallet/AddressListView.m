//
//  AddressListView.m
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/25/16.
//
//

#import <Foundation/Foundation.h>
#import "AddressListView.h"

// import ui/notifcations for the toast if we are on a windows system
#ifdef WINOBJC
#import <UWP/WindowsUIXamlControls.h>
#import <UWP/WindowsDataXmlDom.h>
#endif

@implementation AddressListView

static UITextField *winNameField;

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
    _pairDict = [[addressMan getKeyTagMapping] retain];
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
    NSString *key = [_tableData objectAtIndex:indexPath.row];
    NSString *addr = [_pairDict objectForKey:key];
    NSLog(@"ADDR WAS %@",addr);
    double totalVal = 1;//[NetworkOps getBalanceSimple:addr];
    NSString *finalLabel = [NSString stringWithFormat:@"%@ - Balance: %.3f BTC",key,totalVal];
    contactCell.textLabel.text = finalLabel;
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

	#ifndef WINOBJC

    UIAlertController *newAddress = [UIAlertController alertControllerWithTitle:@"Create New Address" message:@"Provide a nickname for this address" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *submit = [UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // get string pair
        UITextField *addressName = (UITextField*)newAddress.textFields.firstObject;
        NSString *newTag = addressName.text;
		if(newTag == NULL) {
				return;
		}
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
	#endif 

	#ifdef WINOBJC
	// windows code because UIALERTCONTROLLER as above is not valid. UIAlertView Text Fields aren't supported by IW yet
	// The correct mapping is content dialog
	WXCContentDialog *alert = [WXCContentDialog make];
	alert.primaryButtonText = @"Accept";
	alert.secondaryButtonText = @"Reject";

	// put a text block as the title
	WXCTextBlock *title = [WXCTextBlock make];
	title.text = @"Create New Address";
	alert.title = title;

	// put a text box in as the content
	WXCTextBox* textBox = [WXCTextBox make];
	textBox.placeholderText = @"Type an Address Nickname";
	alert.content = textBox;

	[alert showAsyncWithSuccess:^(WXCContentDialogResult success) {
		//  if accept is pressed (WXCContentDialogResult.WXCContentDialogResultPrimary = 1)
		if (success == 1){
			// grab the text box's data, make a new address with that name
			NSString *newTag = textBox.text;
			// if string is null it's no good
			if(newTag == NULL) {
				return;
			}
			[APINetworkOps generateAddressAndAddToAddressManagerWithTag:newTag];
		}
	} failure:^(NSError* failure) {
		// nope
	}];
    
	#endif

}


- (void)backButtonPressed {
    [self dismissViewControllerAnimated:TRUE completion:^{
        // nil
    }];
}

- (void)AddressSubmitPressed {
    [self dismissViewControllerAnimated:TRUE completion:^{
        // nil
    }];
}




@end

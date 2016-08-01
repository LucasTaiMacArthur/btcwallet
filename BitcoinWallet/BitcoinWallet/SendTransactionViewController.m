//
//  SendTransactionViewController.m
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/25/16.
//
//

#import <Foundation/Foundation.h>
#import "SendTransactionViewController.h"

@implementation SendTransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set contact info
    ContactManager *cm = [ContactManager globalManager];
    _contactData = [cm getKeyPairs];
    _pickerData = [[_contactData allKeys] retain];
    
    // set address info
    AddressManager *am = [AddressManager globalManager];
    _addressData = [am getKeyTagMapping];
    _pickerDataAddresses = [[_addressData allKeys] retain];
    
    printf("picker data cnt is %lu\n",(unsigned long)[_pickerData count]);

    
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
    
    self.view.backgroundColor = [UIColor colorWithRed:(210.0/255.0f) green:(215.0/255.0f) blue:(211.0/255.0f) alpha:1.0];

    
    // add navigation bar
    _navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, frameWidth, 44)];
    _navBar.barTintColor = [UIColor colorWithRed:(0xc5/255.0f) green:(0xef/255.0f) blue:(0xf7/255.0f) alpha:1.0];
    
    // add navbar item with buttons
    
    UINavigationItem *navBar = [[UINavigationItem alloc] initWithTitle:@"Send Transaction"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:@selector(backButtonPressed)];
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleDone target:nil action:@selector(sendPaymentPressed)];
    navBar.rightBarButtonItem = submitButton;
    navBar.leftBarButtonItem = backButton;
    [_navBar pushNavigationItem:navBar animated:NO];
    // add navigation bar
    [self.view addSubview:_navBar];
    
    // set up text field
    self.amountField = [[UITextField alloc] init];
    [self.amountField setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.amountField.textAlignment = NSTextAlignmentCenter;
    self.amountField.layer.borderWidth = 1;
    self.amountField.placeholder = @"Enter Amount in BTC";
    [self.amountField setKeyboardType:UIKeyboardTypeDecimalPad];
    [self.view addSubview:self.amountField];
    
    // set up text block
    self.btcLabel = [[UILabel alloc] init];
    self.btcLabel.text = @"TO";
    self.btcLabel.font = [UIFont systemFontOfSize:25];
    [self.btcLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.btcLabel setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:self.btcLabel];
    
    // set up text block
    self.toLabel = [[UILabel alloc] init];
    self.toLabel.text = @"FROM";
    self.toLabel.font = [UIFont systemFontOfSize:25];
    [self.toLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.toLabel setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:self.toLabel];
    
    // set up the contact spinner
    self.contactPicker = [[UIPickerView alloc]init];
    self.contactPicker.delegate = self;
    self.contactPicker.dataSource = self;
    [self.contactPicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.contactPicker];
    
    // set up the address spinner
    self.addressPicker = [[UIPickerView alloc]init];
    self.addressPicker.delegate = self;
    self.addressPicker.dataSource = self;
    [self.addressPicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.addressPicker];

    
    
    
    



    
    // set platform agnostic constraints
    NSDictionary *metrics = @{ @"pad": @80.0, @"margin": @40, @"paymentButtonHeight": @150};
    NSDictionary *views = @{ @"amount" : self.amountField,
                             @"btc" : self.btcLabel,
                             @"to" : self.toLabel,
                             @"contact" : self.contactPicker,
                             @"address" : self.addressPicker
                             };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-75-[btc][contact]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[contact]-10-[to][address][amount]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[btc]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[contact]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[to]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[address]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[amount]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];



    
}

- (void)sendPaymentPressed {
    NSString *pickerContact = [self pickerView:_contactPicker titleForRow:[_contactPicker selectedRowInComponent:0] forComponent:0];
    NSString *pickerAddress = [self pickerView:_addressPicker titleForRow:[_addressPicker selectedRowInComponent:0] forComponent:0];
    NSString *paymentMessage = [NSString stringWithFormat:@"Confirm you want to send %@ BTC from your address \"%@\" to your contact \"%@\"\n",_amountField.text, pickerAddress, pickerContact];
    UIAlertController *newAddress = [UIAlertController alertControllerWithTitle:@"Confirm Payment" message:paymentMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *submit = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // send the transaction handler the from -> to address and the amount
        
        double amountInSatoshi = [[_amountField text]doubleValue] * 100000000;
        NSNumber *amount = [NSNumber numberWithDouble:amountInSatoshi];
        NSString *inputAddr = [_addressData objectForKey:pickerAddress];
        NSString *outputAddr = [_contactData objectForKey:pickerContact];
        printf("about to make an api call with addresses %s | %s  for amount %f\n",[inputAddr UTF8String],[outputAddr UTF8String],amountInSatoshi);
        NSData *skele = [[APINetworkOps generatePartialTXWithInput:inputAddr andOutput:outputAddr andValue:amount] retain];
        NSString *partialTx = [APINetworkOps getTXSkeletonWithData:skele];
        
        NSData *dataToSign = [[partialTx dataUsingEncoding:NSUTF8StringEncoding] retain];
        
        NSString* returnedData = [APINetworkOps sendCompletedTransaction:dataToSign forAddress:pickerAddress];
        
        NSData *dataFromString = [returnedData dataUsingEncoding:NSUTF8StringEncoding];
        
        //  create the json object
        NSDictionary *finalTX = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:dataFromString options:0 error:nil];
        
        // error check (literally check for errors in the resturned object
        if ( [finalTX objectForKey:@"errors"]) {
            // if errors, fail quiet *for now*
            return;
        
        } else {
            // else if no errors, assume correct names from input
            NSString *pt1 = [NSString stringWithFormat:@"%@,%@,",pickerAddress,pickerContact];
            // now get the hash from /tx/hash->string
            NSDictionary *tx = [finalTX objectForKey:@"tx"];
            NSString *txHash = [tx objectForKey:@"hash"];
            
            // create transaction with format TO,FROM,HASH
            NSString *finalTxString = [NSString stringWithFormat:@"%@%@\n",pt1,txHash];
        
            // create a transaction + add it to the trans controller
            TransactionManager *txMan = [TransactionManager globalManager];
            [txMan addTransHash:finalTxString];
        }
        
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // just quietly exit
    }];
    
    [newAddress addAction:cancel];
    [newAddress addAction:submit];
    
    
    [self presentViewController:newAddress animated:YES completion:^{
        // nothing
    }];

    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == _addressPicker) {
        return [_addressData count];
    } else {
        return [_contactData count];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if (component == 0) {
        return 30;
    }else {
        return 0;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 150;
    } else {
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == _addressPicker) {
        return [_pickerDataAddresses objectAtIndex:row];
    } else {
        return [_pickerData objectAtIndex:row];
    }
}

- (void)backButtonPressed {
    [self dismissViewControllerAnimated:TRUE completion:^{
        // nil
    }];
}





@end

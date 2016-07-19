//
//  MainViewController.m
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/11/16.
//
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"

@interface MainViewController ()
@property (strong,nonatomic) UILabel* address;
@property (strong, nonatomic) UIImageView* qrcode;



@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [CryptoOps generateKeyPair];
    
    /*
    AddressManager *addrman = [AddressManager globalManager];
    //[addrman createKeyPairsWithDummyData];
    NSDictionary *kp = [addrman getKeyPairs];
    NSInteger tr = [NetworkOps returnBalanceFromAddresses:kp];
    
    printf("Final Answer is that that the balance of addrs is %lu\n",(long)tr);
    */
    
    while(1) {}
    
    
    // set up text block
    self.address = [[UILabel alloc] init];
    [self.address setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.address setTextAlignment:NSTextAlignmentCenter];
    _btcString = [CryptoOps generateKeyPair];
    NSString *toDisplay = [NSString stringWithFormat:@"BTC Address: %@",_btcString];
    [self.address setText:toDisplay];
    self.address.lineBreakMode = NSLineBreakByWordWrapping;
    self.address.numberOfLines = 2;
    [self.view addSubview:self.address];
    
    
    
    // get Balance for Address by API
    self.balance = [[UILabel alloc] init];
    [self.balance setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.balance setTextAlignment:NSTextAlignmentCenter];
    [self.balance setText:@"Address Balance: "];
    self.balance.lineBreakMode = NSLineBreakByWordWrapping;
    self.balance.numberOfLines = 2;
    [self.view addSubview:self.balance];
    [NetworkOps getAddressBalance:_btcString changeWithLabel:self.balance];
     
    
    
    // get QR Code for Address by API
    _qrcode = [[UIImageView alloc] init];
    //[self.qrcode setTranslatesAutoresizingMaskIntoConstraints:NO];

    //[NetworkOps getAddressQRCode:_btcString changeWithData:_qrcode];
    

    
    
    
    
    
    // get QR Code for Address by API
    
    // set platform agnostic constraints
    NSDictionary *metrics = @{ @"pad": @80.0, @"margin": @40, @"mapHeight": @50};
    NSDictionary *views = @{ @"address"   : _address,
                             @"balance"   : _balance
                             };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[address]-10-[balance]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[address]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[balance]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    
    
    
    
}





@end

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
@property (strong,nonatomic) UILabel* balance;
@property (strong, nonatomic) NSString* btcString;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // set up text block
    self.address = [[UILabel alloc] init];
    [self.address setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.address setTextAlignment:NSTextAlignmentCenter];
    _btcString = [CryptoOps generateKeyPair];
    [self.address setText:_btcString];
    [self.view addSubview:self.address];
    
    // set up text block
    self.balance = [[UILabel alloc] init];
    [self.balance setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.balance setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.balance];
    
    
    
}





@end

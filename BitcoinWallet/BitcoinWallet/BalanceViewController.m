//
//  BalanceViewController.m
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/22/16.
//
//

#import <Foundation/Foundation.h>
#import "BalanceViewController.h"

@implementation BalanceViewController

static NSString* kBTCString = @"BTC";
static NSString* kBalStringTest = @"57.244";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up balance
    self.balanceLabel = [[UILabel alloc] init];
    self.balanceLabel.layer.borderWidth = 1;
    self.balanceLabel.text = kBalStringTest;
    [self.balanceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.balanceLabel setTextAlignment:NSTextAlignmentRight];
    [self.view addSubview:self.balanceLabel];
    
    // set up currency unit string
    self.unitLabel = [[UILabel alloc] init];
    self.unitLabel.layer.borderWidth = 1;
    self.unitLabel.text = kBTCString;
    [self.unitLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.unitLabel setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:self.unitLabel];
    
    // set platform agnostic constraints
    NSDictionary *metrics = @{ @"pad": @80.0, @"margin": @40, @"paymentButtonHeight": @150};
    NSDictionary *views = @{ @"balanceLabel" : self.balanceLabel,
                             @"unitLabel" : self.unitLabel
                             };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[balanceLabel]-350-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-75-[balanceLabel]-125-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[unitLabel]-350-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-200-[unitLabel]-25-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    
    
}

@end

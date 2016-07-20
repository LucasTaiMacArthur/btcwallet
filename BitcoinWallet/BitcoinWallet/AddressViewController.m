//
//  AddressViewController.m
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/20/16.
//
//

#import <Foundation/Foundation.h>
#import "AddressViewController.h"

@implementation AddressViewController

- (void)viewDidLoad {
    // assuming that the caller which creates VC will fill self.bitcoinAddress
    
    // set up text block
    self.balanceLabel = [[UILabel alloc] init];
    self.balanceLabel.text = @"Address Balance: ";
    [self.balanceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.balanceLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.balanceLabel];
    
    // set platform agnostic constraints
    NSDictionary *metrics = @{ @"pad": @80.0, @"margin": @40, @"mapHeight": @50};
    NSDictionary *views = @{ @"balanceLabel"   : self.balanceLabel
                             };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[balanceLabel]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[balanceLabel]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];

    
    
}

@end

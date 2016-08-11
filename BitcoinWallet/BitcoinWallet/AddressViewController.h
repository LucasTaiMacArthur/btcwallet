//
//  AddressViewController.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/20/16.
//
//

#ifndef AddressViewController_h
#define AddressViewController_h
#import "NetworkOps.h"
#import "Bolts.h"
#import <UIKit/UIKit.h>

@interface AddressViewController : UIViewController

@property (strong,atomic) UINavigationBar *navBar;
@property (strong,atomic) UIImageView *qrImage;
@property (strong,atomic) UILabel *nameLabel;
@property (strong,nonatomic) NSString *addressName;
@property (strong,nonatomic) NSString *address;

+ (id)initWithName:(NSString*)name andAddress:(NSString*)address;


@end

#endif /* AddressViewController_h */

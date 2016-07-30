//
//  ContactViewController.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/22/16.
//
//

#ifndef ContactViewController_h
#define ContactViewController_h
#import <UIKit/UIKit.h>
#import "NetworkOps.h"

@interface ContactViewController : UIViewController

@property (strong,atomic) UINavigationBar *navBar;
@property (strong,atomic) UIImageView *qrImage;
@property (strong,atomic) UILabel *nameLabel;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *qrCode;

+ (id)initWithName:(NSString*)nameStr andAddress:(NSString*)qrStr;


@end

#endif /* ContactViewController_h */

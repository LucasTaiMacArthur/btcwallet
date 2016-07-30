//
//  CreateContactViewController.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/24/16.
//
//

#ifndef CreateContactViewController_h
#define CreateContactViewController_h
#import <UIKit/UIKit.h>
#import "ContactManager.h"
@import AVFoundation;

@interface CreateContactViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (strong,nonatomic) AVCaptureVideoPreviewLayer *displayView;
@property (strong,atomic) UINavigationBar *navBar;
@property (strong,atomic) UILabel *instructionLabel;
@property (strong,atomic) UIView *previewContainer;

@end


#endif /* CreateContactViewController_h */

//
//  CreateContactViewController.m
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/24/16.
//
//

#import <Foundation/Foundation.h>
#import "CreateContactViewController.h"

#ifdef WINOBJC
#import <UWP/WindowsUIXamlControls.h>
#import <UWP/WindowsMediaCapture.h>
#import <UWP/WindowsDevicesEnumeration.h>
#endif

@implementation CreateContactViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;

    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *frontCam = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *err = nil;
    AVCaptureDeviceInput *camInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCam error:&err];
    // start the capture session
    [captureSession addInput:camInput];
    dispatch_queue_t delegateQ = dispatch_queue_create("delQ",NULL);
    // attach metadata output to the session
    AVCaptureMetadataOutput *qrOut = [[AVCaptureMetadataOutput alloc] init];
    [captureSession addOutput:qrOut];
    [qrOut setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    [qrOut setMetadataObjectsDelegate:self queue:delegateQ];

    
    // add navigation bar
    _navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, frameWidth, 44)];
    _navBar.barTintColor = [UIColor colorWithRed:(0xc5/255.0f) green:(0xef/255.0f) blue:(0xf7/255.0f) alpha:1.0];
    
    
    // add navbar item with buttons
    
    UINavigationItem *staticItem = [[UINavigationItem alloc] initWithTitle:@"Scan Contact QR"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:@selector(backButtonPressed)];
    staticItem.leftBarButtonItem = backButton;
    [_navBar pushNavigationItem:staticItem animated:NO];
    // add navigation bar
    [self.view addSubview:_navBar];
    
    // set up text block
    self.instructionLabel = [[UILabel alloc] init];
    self.instructionLabel.text = @"Bring QR Code in Frame";
    self.instructionLabel.adjustsFontSizeToFitWidth = TRUE;
    [self.instructionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.instructionLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.instructionLabel];


    // set platform agnostic constraints
    NSDictionary *metrics = @{ @"pad": @80.0, @"margin": @40, @"paymentButtonHeight": @150};
    NSDictionary *views = @{ @"submit" : self.instructionLabel,
                             @"container" : self.previewContainer
                             };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[container]-20-[submit]-80-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[submit]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
	
    // start the camera
    [captureSession startRunning];



}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    // check for empty array
    if(metadataObjects.count == 0){
        return;
    }
    AVMetadataMachineReadableCodeObject *qr = [metadataObjects objectAtIndex:0];
    if (qr.type == AVMetadataObjectTypeQRCode) {
        NSString *addrString = qr.stringValue;
        printf("THE QR CODE READ %s\n",[qr.stringValue UTF8String]);
        
        UIAlertController *newAddress = [UIAlertController alertControllerWithTitle:@"Create Contact" message:@"Provide a name for this contact" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *submit = [UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // get string pair
			UITextField *nameField = (UITextField*)newAddress.textFields.firstObject;
            NSString *newTag = nameField.text;

			// quit if no name is given
			if (newTag == NULL) {
				return;
			}

            NSString *finalString = [NSString stringWithFormat:@"%@,%@\n",newTag,addrString];
            ContactManager *contactManager = [ContactManager globalManager];
            [contactManager addKeyPair:finalString];
            
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

        
        
    }
    
}

- (void)backButtonPressed {
    [self dismissViewControllerAnimated:TRUE completion:^{
        // nil
    }];
}



@end

//
//  CreateContactViewController.m
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/24/16.
//
//

#import <Foundation/Foundation.h>
#import "CreateContactViewController.h"

@implementation CreateContactViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
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
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
    staticItem.leftBarButtonItem = backButton;
    [_navBar pushNavigationItem:staticItem animated:NO];
    // add navigation bar
    [self.view addSubview:_navBar];
    

    
    // add the imageview with callback
    _displayView = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [_displayView setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.submitButton.layer.borderWidth = 1;
    self.submitButton.layer.cornerRadius = 15;
    self.submitButton.clipsToBounds = TRUE;
    
    self.submitButton.backgroundColor = [UIColor colorWithRed:(0x87/255.0f) green:(0xd3/255.0f) blue:(0x7c/255.0f) alpha:1.0];
    [self.submitButton setTitle:@"Submit"
                            forState:UIControlStateNormal];
    [self.submitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.submitButton addTarget:self
                               action:nil
                     forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton sizeToFit];
    self.submitButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.submitButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.submitButton.titleLabel.textColor = [UIColor blackColor];
    self.submitButton.titleLabel.adjustsFontSizeToFitWidth = TRUE;
    [self.view addSubview:self.submitButton];
    
    
    // add the container uiview
    _previewContainer = [[UIView alloc] initWithFrame:CGRectMake(20, 100, frameWidth-40, 400)];
    _previewContainer.layer.borderWidth = 1;
    _previewContainer.layer.cornerRadius = 15;
    _previewContainer.clipsToBounds = TRUE;
    [_previewContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:_previewContainer];
    
    [_displayView setFrame:_previewContainer.frame];
    [self.view.layer addSublayer:_displayView];




    
    // set platform agnostic constraints
    NSDictionary *metrics = @{ @"pad": @80.0, @"margin": @40, @"paymentButtonHeight": @150};
    NSDictionary *views = @{ @"submit" : self.submitButton,
                             @"container" : self.previewContainer
                             };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[container]-20-[submit]-60-|"
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
        printf("THE QR CODE READ %s\n",[qr.stringValue UTF8String]);
    }
    
}

@end

//
//  ViewController.m
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/5/16.
//
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UITextField *entryField;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UILabel *notificationLabel;
@property (strong, nonatomic) NSFileManager *fileman;

@end

@implementation ViewController

NSString * const ksubmitPasswordString = @"Submit Password";
BOOL password_exists = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[CryptoOps generateKeyPair];
    // set up submit button
    
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.submitButton setTitle:ksubmitPasswordString
                       forState:UIControlStateNormal];
    [self.submitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.submitButton addTarget:self
                          action:@selector(submitButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
    
    // set up text field
    self.entryField = [[UITextField alloc] init];
    [self.entryField setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.entryField.textAlignment = NSTextAlignmentCenter;
    self.entryField.placeholder = @"Enter Password Here";
    [self.view addSubview:self.entryField];
    
    // set up text block
    self.notificationLabel = [[UILabel alloc] init];
    [self.notificationLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.notificationLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.notificationLabel];
    
    // Create a file manager
    self.fileman = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [docurl stringByAppendingString:@"/password.txt"];
    printf("%s\n",[docurl UTF8String]);
    
    //check if a password file exists, if not, set the text accordingly
    password_exists = [self.fileman fileExistsAtPath:fileurl];
    if (!password_exists) {
        printf("no pw file exists, creating file\n");
        NSString * registerPasswordString = @"Register Password";
        [self.submitButton setTitle:registerPasswordString forState:UIControlStateNormal];
        self.notificationLabel.text = @"No Password Detected";
        self.notificationLabel.textColor = [UIColor redColor];
        
    }else{
        self.notificationLabel.text = @"Enter Password Below";
        self.notificationLabel.textColor = [UIColor greenColor];
    }
    
    // set platform agnostic constraints
    NSDictionary *metrics = @{ @"pad": @80.0, @"margin": @40, @"mapHeight": @50};
    NSDictionary *views = @{ @"submitButton"   : self.submitButton,
                             @"entryField"   : self.entryField,
                             @"notificationLabel"   : self.notificationLabel
                             };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[notificationLabel]-50-[entryField][submitButton]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[entryField]-50-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[submitButton]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[notificationLabel]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    
    
        
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitButtonPressed {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [docurl stringByAppendingString:@"/password.txt"];

    if (password_exists){
        // get password data
        NSData *pwdData = [self.fileman contentsAtPath:fileurl];
        NSString *toPrint = [[NSString alloc] initWithData:pwdData encoding:NSUTF8StringEncoding];
        printf("The data at the file was %s\n",[toPrint UTF8String]);
        // check for password equality
        NSString *entryText = _entryField.text;
        if ([toPrint isEqualToString:entryText]) {
            printf("STRINGS EQUAL - Moving ON\n");
            MainViewController *con = [[MainViewController alloc]init];
            [self presentViewController:con animated:YES completion:^{
                //
            }];
        }else {
            printf("STRINGS NOT EQUAL - STOP\n");
        }
    }else {
        NSString *tmp = _entryField.text;
        NSData *toWrite = [tmp dataUsingEncoding:NSUTF8StringEncoding];
        BOOL filecreat = [self.fileman createFileAtPath:fileurl contents:toWrite attributes:nil];
        if (filecreat) {
            printf("Success\n");
        }else {
            printf("Failure\n");
        }

    }
    
}

@end

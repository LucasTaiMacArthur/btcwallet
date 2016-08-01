//
//  PasswordManager.m
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/20/16.
//
//

#import <Foundation/Foundation.h>
#import "PasswordManager.h"

@implementation PasswordManager

// wrap the password file path
+ (NSString*)getPasswordFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [docurl stringByAppendingString:@"/password.txt"];
    return fileurl;
}

// check the SHA256 hashed password at documents/password.txt
+ (int)verifyPassword:(NSString*)inputString {
    
	#ifndef WINOBJC
    // get password data from file
    NSString *pwdFilePath = [PasswordManager getPasswordFilePath];
    NSFileManager *fileman = [NSFileManager defaultManager];
    NSData *pwdData = [fileman contentsAtPath:pwdFilePath];
    
    // check for password equality
    NSString *entryText = inputString;
    const unsigned char *str = [entryText UTF8String];
    unsigned char *d = malloc(SHA_DIGEST_LENGTH);
    SHA(str, strlen([entryText UTF8String]), d);
    NSData *checkString = [NSData dataWithBytes:d length:SHA_DIGEST_LENGTH];

    
    if ([checkString isEqualToData:pwdData]) {
        return 1;
    } else {
        return 0;
    }

	#endif

	return 0;
}

// create a password file at documents/password.txt hashed with sha256
+ (int)createPasswordFile:(NSString*)inputString {
    #ifndef WINOBJC
    NSString *pwdFilePath = [PasswordManager getPasswordFilePath];
    NSFileManager *fileman = [NSFileManager defaultManager];
    const unsigned char *str = [inputString UTF8String];
    unsigned char *dig = malloc(SHA_DIGEST_LENGTH);
    SHA(str, strlen([inputString UTF8String]), dig);
    NSData *toWrite = [NSData dataWithBytes:dig length:SHA_DIGEST_LENGTH];
    BOOL fileCreated = [fileman createFileAtPath:pwdFilePath contents:toWrite attributes:nil];

    
    if (fileCreated) {
        return 1;
    }else {
        return 0;
    }
	#endif

	return 0;
}

+ (int)passwordFileExists {
    NSString *pwdFilePath = [PasswordManager getPasswordFilePath];
    NSFileManager *fileman = [NSFileManager defaultManager];

    return [fileman fileExistsAtPath:pwdFilePath];
}


@end

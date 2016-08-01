//
//  PasswordManager.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/20/16.
//
//

#ifndef PasswordManager_h
#define PasswordManager_h

#ifndef WINOBJC
#import <openssl/sha.h>
#endif // !WINOBJC

@interface PasswordManager : NSObject

+ (int)verifyPassword:(NSString*)inputString;
+ (int)createPasswordFile:(NSString*)inputString;
+ (int)passwordFileExists;
+ (NSString*)getPasswordFilePath;

@end
#endif /* PasswordManager_h */

//
//  PasswordManager.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/20/16.
//
//

#ifndef PasswordManager_h
#define PasswordManager_h
#import <openssl/sha.h>

@interface PasswordManager : NSObject

+ (int)verifyPassword:(NSString*)inputString;
+ (int)createPasswordFile:(NSString*)inputString;
+ (int)passwordFileExists;

@end
#endif /* PasswordManager_h */

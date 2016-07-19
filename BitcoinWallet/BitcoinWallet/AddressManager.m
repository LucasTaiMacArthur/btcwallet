//
//  AddressManager.m
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/18/16.
//
//

#import <Foundation/Foundation.h>
#include "AddressManager.h"



@implementation AddressManager : NSObject 

static AddressManager *globalManager = nil;


+ (id)globalManager {
    if (globalManager == nil){
        globalManager = [[AddressManager alloc] init];
        return globalManager;
    }
    return globalManager;
}

- (void)createKeyPairsWithDummyData {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [docurl stringByAppendingString:@"/keypairs.txt"];
    const unsigned char *str = "1,2\n3,4";
    NSFileManager *fileman = [NSFileManager defaultManager];
    NSData *toWrite = [NSData dataWithBytes:str length:strlen(str)];
    BOOL filecreat = [fileman createFileAtPath:fileurl contents:toWrite attributes:nil];
    if(filecreat){
        printf("SUCCESFULL DUMMY FILE CREATED\n");
    }else {
        printf("DUMMY FILE CREATION FAILED\n");
    }
}

- (NSDictionary*)getKeyPairs {
    // process file kp (private,public)
    NSFileManager *fileman = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [docurl stringByAppendingString:@"/keypairs.txt"];
    NSData *pwdData = [fileman contentsAtPath:fileurl];
    NSString *csvString = [[NSString alloc]initWithData:pwdData encoding:NSUTF8StringEncoding];
    printf("%s\n",[csvString UTF8String]);

    
    

    
    
    
    return nil;
}



@end


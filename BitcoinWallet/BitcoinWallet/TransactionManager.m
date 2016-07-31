//
//  TransactionManager.m
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/25/16.
//
//

#import <Foundation/Foundation.h>
#include "TransactionManager.h"

@implementation TransactionManager

static TransactionManager *globalManager;

// transactions will have the signature [recipient,amount(in satoshi),success\n]

+ (id)globalManager {
    if (globalManager == nil){
        globalManager = [[TransactionManager alloc]init];
        return globalManager;
    } else {
        return globalManager;
    }
}

- (void)createKeyPairsWithDummyData {
    NSString *line1 = [[NSString alloc]initWithFormat:@"e6a0e05e79b8534aacfb4298ea54d26bc15e0a0f1ecda63ea7882614fa51a20e\n"];
    NSString *line2 = [[NSString alloc]initWithFormat:@"610d0edae2d813bad3c95d71f43080c17f1dd9234d92caacdcd86df39a1d4670\n"];
    [self addTransHash:line2];
}


- (int)addTransHash:(NSString*)toAdd {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [docurl stringByAppendingString:@"/transactions.txt"];
    NSFileManager *fileman = [NSFileManager defaultManager];
    
    NSData *dat1 = [fileman contentsAtPath:fileurl];
    NSData *toWrite = [NSData dataWithBytes:[toAdd UTF8String] length:[toAdd length]];
    NSMutableData *concatData = [NSMutableData dataWithData:dat1];
    [concatData appendData:toWrite];
    
    // remove file if it exists
    if ([fileman fileExistsAtPath:fileurl]) {
        printf("I've removed the file?\n");
        [fileman removeItemAtPath:fileurl error:nil];
    }
    
    // write new file with full data
    BOOL filecreat = [fileman createFileAtPath:fileurl contents:concatData attributes:nil];
    if (filecreat) {
        printf("Success - file written\n");
    }else {
        printf("Failure! - file not written\n");
    }
    
    return 1;
}

// gets mapping of name(k) -> pubkey(v)
- (NSSet*)getTransactionHashes {
    // process file kp (private,public)
    NSFileManager *fileman = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [docurl stringByAppendingString:@"/transactions.txt"];
    NSData *pwdData = [fileman contentsAtPath:fileurl];
    NSString *csvString = [[NSString alloc]initWithData:pwdData encoding:NSUTF8StringEncoding];
    printf("%s\n",[csvString UTF8String]);
    
    NSCharacterSet *splitSet = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
    NSArray *splitString = [[NSArray alloc] init];
    splitString = [csvString componentsSeparatedByCharactersInSet:splitSet];
    printf("Array Size is %lu",(unsigned long)[splitString count]);
    
    NSMutableSet *returnSet = [[NSMutableSet alloc] init];
    
    // splitstring count is going to be +1 more, since there is a sentinel
    for(int i = 0; i < [splitString count] - 1; i = i + 4){
        id transaction = [splitString objectAtIndex:(i)];
        [returnSet addObject:transaction];
    }
    return returnSet;
}




@end

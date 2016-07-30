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
    NSString *line1 = [[NSString alloc]initWithFormat:@"2612a133d2d5207a5fdea0e51388b578597a6aeaff98e7817bbd922d32b53602\n"];
    [self addKeyPair:line1];
}


- (int)addKeyPair:(NSString*)toAdd {
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




@end

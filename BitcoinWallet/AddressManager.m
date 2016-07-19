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
    NSString *line1 = [[NSString alloc]initWithFormat:@"bit1,1JdJQftq3kQRTBVBMRJ4dcZe5yBJCuz6MR\n"];
    NSString *line2 = [[NSString alloc]initWithFormat:@"bit2,1wuyDWpAzcz84XBWB5WLzHtHxnHb5Kqwo\n"];
    [self addKeyPair:line1];
    [self addKeyPair:line2];
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
    
    NSCharacterSet *splitSet = [NSCharacterSet characterSetWithCharactersInString:@"\n,"];
    NSArray *splitString = [[NSArray alloc] init];
    splitString = [csvString componentsSeparatedByCharactersInSet:splitSet];
    printf("Array Size is %lu",(unsigned long)[splitString count]);
    
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] init];
    
    // splitstring count is going to be +1 more, since there is a trailing \n
    // split will split on this newline and leave an extra entry at the end (2n+1) entries in total
    for(int i = 0; i < [splitString count] - 1; i = i + 2){
        id privkey = [splitString objectAtIndex:i];
        id pubkey = [splitString objectAtIndex:(i+1)];
        [returnDict setObject:pubkey forKey:privkey];
    }
    
    
    return returnDict;
}

- (int)addKeyPair:(NSString*)toAdd {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [docurl stringByAppendingString:@"/keypairs.txt"];
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


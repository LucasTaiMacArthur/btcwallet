//
//  NetworkOps.m
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/8/16.
//
//

#import <Foundation/Foundation.h>
#include "NetworkOps.h"

@implementation NetworkOps : NSObject 

+ (NSString *)getAddressBalance: (NSString *)address {
    
    NSString *urlString = [NSString stringWithFormat:@"https:/www.blockexplorer.com/api/addr/%@/balance",address];
    NSURL *apiURL =  [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask *tsk = [[NSURLSession sharedSession] dataTaskWithURL:apiURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data){
            NSString *ret = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"STRING WAS %@",ret);
            }
        }
    ];
    [tsk resume];
    
    
    
    return nil;
    
}

@end

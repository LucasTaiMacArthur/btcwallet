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

+ (NSString *)getAddressBalance: (NSString *)address changeWithLabel:(UILabel *)label {
    
    NSString *urlString = [NSString stringWithFormat:@"https:/www.blockexplorer.com/api/addr/%@/balance",address];
    NSURL *apiURL =  [NSURL URLWithString:urlString];
    __block NSString *to_ret = [[NSString alloc] init];
    
    NSURLSessionDataTask *tsk = [[NSURLSession sharedSession] dataTaskWithURL:apiURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data){
            to_ret = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSString *str = [NSString stringWithFormat:@"Address Balance: %@",to_ret];
            label.text = str;
            
            
            }
        }
    ];
    [tsk resume];
    
    
    
    return to_ret;
    
}

+ (void)getBalanceSimple: (NSString *)address callback: (void(^)(NSInteger)) callback {
    
    NSString *urlString = [NSString stringWithFormat:@"https:/www.blockexplorer.com/api/addr/%@/balance",address];
    NSURL *apiURL =  [NSURL URLWithString:urlString];
    __block NSInteger to_ret = 0;
    
    NSURLSessionDataTask *tsk = [[NSURLSession sharedSession] dataTaskWithURL:apiURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data){
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            to_ret = [str integerValue];
            callback(to_ret);
        }
    }
                                 ];
    [tsk resume];
    
}



+ (NSData *)getAddressQRCode: (NSString *)address changeWithData:(UIImageView *)img  {
    
    NSString *apiCall = [NSString stringWithFormat:@"https://api.qrserver.com/v1/create-qr-code/?data=%@&size=200x200",address];
    NSURL *url = [NSURL URLWithString:apiCall];
    __block NSData *to_ret = [[NSData alloc] init];
    
    NSURLSessionDataTask *tsk = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data){
            printf("Recieved image data back from qrserver\n");
            UIImage *toPut = [[UIImage alloc]initWithData:data];
            img.image = toPut;
        }
    }
                                 ];
    [tsk resume];
    
    
    
    return to_ret;
    
}

+ (void)myCallback:(NSInteger)test {
    printf("Got Callback was: %li\n",(long)test);
}

+ (NSUInteger)returnBalanceFromAddresses:(NSDictionary*)keypairDict {
    
    
    
    // enumerate all addresses
    NSArray<NSString *> *vals = [keypairDict allValues];
    __block long count = [vals count];
    __block long balance = 0;
    
    for(NSString *val in vals){
        printf("val was %s\n",[val UTF8String]);
        // each ret decrements the counter, increment the balance
        [self getBalanceSimple:val callback:^(NSInteger test)  {
            //[lock lock];
            printf("RET WAS %li\n",(long)test);
            balance += test;
            count--;
            //[lock unlock];
        }];
    }
    
    // busy wait while count is zero
    while(count > 0){}
    
    
    NSUInteger ret = balance;
    
    return ret;
}


@end

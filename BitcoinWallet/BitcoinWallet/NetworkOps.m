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

+ (double)getBalanceSimple: (NSString *)address {
    
    // set up NS
    NSString *urlString = [NSString stringWithFormat:@"https://api.blockcypher.com/v1/btc/test3/addrs/%@/balance",address];
    NSURL *apiURL =  [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:defaultConfig];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:apiURL];
    
    
    __block bool returned = FALSE;
    __block int strVal = 0;
    NSURLSessionDataTask *dataTsk = [sessionManager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSData *dat = (NSData*)responseObject;
        NSDictionary *jsonData = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:dat options:nil error:nil];
        // the data we want is at /final_balance
        NSNumber *final_balance = [jsonData valueForKey:@"final_balance"];
        NSLog(@"VAL WAS %@",final_balance);
        strVal = [final_balance intValue];
        returned = TRUE;
    }];
    
    
    
    [dataTsk resume];
    
    while (!returned) {
        // busy wait
    }
    
    return strVal;

    
}



+ (NSData *)getAddressQRCode: (NSString *)address  {
    
    NSLog(@"in call");
    NSString *apiCall = [NSString stringWithFormat:@"https://api.qrserver.com/v1/create-qr-code/?data=%@&size=300x300",address];
    NSURL *url = [NSURL URLWithString:apiCall];
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:defaultConfig];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    
    __block NSData *to_ret = [[NSData alloc] init];
    __block bool returned = FALSE;
    
    NSURLSessionDataTask *dataTsk = [sessionManager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"in completionHandlr %@",error);
        printf("Recieved image data back from qrserver\n");
        to_ret = [(NSData*)responseObject retain];
        returned = TRUE;
    }];
    
    

    [dataTsk resume];
    
    while (!returned) {
        // busy wait
    }
    
    
    
    return to_ret;
    
}

+ (void)myCallback:(NSInteger)test {
    printf("Got Callback was: %li\n",(long)test);
}

+ (NSUInteger)returnBalanceFromAddresses:(NSDictionary*)keypairDict {
    
    
    
    // enumerate all addresses
    NSArray<NSString *> *vals = [keypairDict allValues];
    __block long count = [vals count];
    __block double balance = 0;
    
    for(NSString *val in vals){
        printf("val was %s\n",[val UTF8String]);
        // each ret decrements the counter, increment the balance
        double add = [self getBalanceSimple:val];
        balance += add;
        count--;
    }
    
    
    NSUInteger ret = balance;
    
    return ret;
}


@end

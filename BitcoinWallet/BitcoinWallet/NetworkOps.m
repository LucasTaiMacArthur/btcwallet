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
    
    __block bool returned = FALSE;
    __block double strVal = 0;
    
    NSURLSessionDataTask *tsk = [[NSURLSession sharedSession] dataTaskWithURL:apiURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data){
            NSDictionary *jsonData = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
            // the data we want is at /final_balance
            NSNumber *final_balance = [jsonData valueForKey:@"final_balance"];
            strVal = [final_balance doubleValue];
            returned = TRUE;
        }
    }
                                 ];

    
    [tsk resume];
    
    while (!returned) {
        // busy wait
    }
    
    return strVal;
    
    
}




+ (NSData *)getAddressQRCode: (NSString *)address  {
    
    NSString *apiCall = [NSString stringWithFormat:@"https://api.qrserver.com/v1/create-qr-code/?data=%@&size=300x300",address];
    NSURL *url = [NSURL URLWithString:apiCall];
    __block NSData *to_ret = [[NSData alloc] init];
    __block bool returned = FALSE;
    
    NSURLSessionDataTask *tsk = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data){
            printf("Recieved image data back from qrserver\n");
            to_ret = [data retain];
            returned = TRUE;
        }
    }
                                 ];
    [tsk resume];
    
    while (!returned) {
        // busy wait
    }
    
    
    
    return to_ret;
    
}

+ (void)myCallback:(NSInteger)test {
    printf("Got Callback was: %li\n",(long)test);
}

+ (double)returnBalanceFromAddresses:(NSDictionary*)keypairDict {
    
    
    
    // enumerate all addresses
    NSArray<NSString *> *vals = [keypairDict allValues];
    __block long count = [vals count];
    __block long balance = 0;
    
    for(NSString *val in vals){
        // each ret decrements the counter, increment the balance
        double add = [self getBalanceSimple:val];
        balance += add;
        count--;
    }
    
    // busy wait while count is zero
    while(count > 0){}
    
    
    
    return balance;
}


@end
